// Comunicacao com a FPGA totalmente em bit-bang (sem SoftwareSerial),
// com frames NAO PADRAO de 16 bits nos dois sentidos:
// 1 start bit + 16 bits de dado (LSB primeiro) + 1 stop bit.
//
// Convencao mantida do projeto original:
//   - Envio (Arduino -> FPGA): 16 bits SEM SINAL (0 a 65535)
//   - Recepcao (FPGA -> Arduino): 16 bits COM SINAL (-32768 a 32767)

#define FPGA_TX_PIN 11   // Arduino -> FPGA
#define FPGA_RX_PIN 4    // FPGA -> Arduino

const long BAUD_RATE = 9600;
const unsigned long BIT_PERIOD_US = 1000000UL / BAUD_RATE; // ~104us por bit

void setup() {
  Serial.begin(9600);

  pinMode(FPGA_TX_PIN, OUTPUT);
  digitalWrite(FPGA_TX_PIN, HIGH); // linha em repouso = HIGH

  pinMode(FPGA_RX_PIN, INPUT);

  Serial.println("Sistema Pronto. Digite um numero SEM sinal (0-65535):");
}

// Envia 16 bits (LSB primeiro) no frame customizado: start(0) + 16 dados + stop(1)
void fpgaSendWord16(uint16_t dado) {
  digitalWrite(FPGA_TX_PIN, LOW);              // start bit
  delayMicroseconds(BIT_PERIOD_US);

  for (int i = 0; i < 16; i++) {               // 16 bits de dado, LSB primeiro
    digitalWrite(FPGA_TX_PIN, (dado >> i) & 0x01);
    delayMicroseconds(BIT_PERIOD_US);
  }

  digitalWrite(FPGA_TX_PIN, HIGH);             // stop bit
  delayMicroseconds(BIT_PERIOD_US);
}

// Le os 16 bits de dado do frame customizado da FPGA (LSB primeiro).
// Deve ser chamada logo apos detectar a borda de descida (inicio do start bit).
uint16_t fpgaReceiveWord16() {
  // Pula o restante do start bit e avanca ate o CENTRO do 1o bit de dado
  delayMicroseconds(BIT_PERIOD_US + BIT_PERIOD_US / 2);

  uint16_t valor = 0;
  for (int i = 0; i < 16; i++) {
    if (digitalRead(FPGA_RX_PIN) == HIGH) {
      valor |= ((uint16_t)1 << i);             // bit 0 (LSB) chega primeiro
    }
    if (i < 15) delayMicroseconds(BIT_PERIOD_US);
  }

  delayMicroseconds(BIT_PERIOD_US); // aguarda o stop bit (nao verificado)
  return valor;
}

void loop() {
  // 1. Recebe numero do PC e envia 16 bits SEM SINAL para a FPGA
  if (Serial.available() > 0) {
    long valorEntrada = Serial.parseInt();

    if (valorEntrada >= 0 && valorEntrada <= 65535) {
      uint16_t dadoParaEnviar = (uint16_t)valorEntrada;
      fpgaSendWord16(dadoParaEnviar);

      Serial.print("Decimal Enviado: ");
      Serial.print(dadoParaEnviar);
      Serial.print(" | Binario: ");
      Serial.println(dadoParaEnviar, BIN);
    } else {
      Serial.println("Erro: O valor de envio deve estar entre 0 e 65535.");
    }

    while (Serial.available() > 0) Serial.read();
  }

  // 2. Detecta e le o frame de 16 bits COM SINAL vindo da FPGA
  if (digitalRead(FPGA_RX_PIN) == LOW) {  // borda de descida = inicio do start bit
    uint16_t valorBruto = fpgaReceiveWord16();
    int16_t dadoRecebido = (int16_t)valorBruto;

    Serial.print("Recebido da FPGA (Decimal com Sinal): ");
    Serial.println(dadoRecebido);
    Serial.print("Em Binario: ");
    Serial.println(valorBruto, BIN);
    Serial.println("---");
  }
}
