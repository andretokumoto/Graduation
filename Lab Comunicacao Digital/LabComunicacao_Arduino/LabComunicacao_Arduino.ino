#include <SoftwareSerial.h>

// ==========================================================
// Conexões
// TX da FPGA  -> pino 4 (RX do Arduino)
// TX do Arduino (pino 11) -> RX da FPGA (usar divisor de tensão 5V -> 3.3V)
// GND do Arduino e GND da FPGA devem estar conectados
// ==========================================================
SoftwareSerial fpgaserial(4, 11);

void setup() {
  // Comunicação com o PC
  Serial.begin(9600);

  // Comunicação com a FPGA
  fpgaserial.begin(9600);

  // Reduz o tempo de espera do parse de strings
  Serial.setTimeout(50);

  Serial.println("Sistema pronto.");
  Serial.println("Digite um numero entre 0 e 255 e pressione ENTER.");
}

void loop() {
  // ==========================================================
  // 1. Lê uma linha completa do Monitor Serial
  // ==========================================================
  if (Serial.available() > 0) {
    // Lê tudo até o caractere '\n'
    String entrada = Serial.readStringUntil('\n');

    // Remove '\r', espaços e tabs
    entrada.trim();

    // Só processa se realmente houver conteúdo
    if (entrada.length() > 0) {
      int valor = entrada.toInt();

      // Mantém apenas os 8 bits menos significativos
      byte dado = (byte)(valor & 0xFF);

      // Envia o byte para a FPGA
      fpgaserial.write(dado);

      Serial.print("Valor enviado para FPGA: ");
      Serial.println(dado);

      Serial.print("Binario enviado: ");
      for (int i = 7; i >= 0; i--) {
        Serial.print((dado >> i) & 1);
      }
      Serial.println();
    }
  }

  // ==========================================================
  // 2. Recebe 1 byte da FPGA
  // ==========================================================
  if (fpgaserial.available() > 0) {
    byte dadoRecebido = fpgaserial.read();

    Serial.print("Recebido da FPGA (decimal): ");
    Serial.println(dadoRecebido);

    Serial.print("Recebido da FPGA (binario): ");
    for (int i = 7; i >= 0; i--) {
      Serial.print((dadoRecebido >> i) & 1);
    }
    Serial.println();
  }
}