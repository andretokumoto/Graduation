#include <SoftwareSerial.h>

// RX no 4, TX no 11
SoftwareSerial fpgaserial(4, 11); 

void setup() {
  Serial.begin(9600);      
  fpgaserial.begin(9600);  
  
  Serial.println("Sistema Pronto. Digite um numero (0-255):");
}

void loop() {
  // 1. Recebe String do PC, converte para Byte e manda para a FPGA
  if (Serial.available() > 0) {
    // Lê o que foi digitado até o 'Enter' e converte para número
    int valorEntrada = Serial.parseInt(); 
    
    // Verifica se o valor cabe em 8 bits (0 a 255)
    if (valorEntrada >= 0 && valorEntrada <= 255) {
      byte dadoParaEnviar = (byte)valorEntrada;
      
      fpgaserial.write(dadoParaEnviar); // Envia o binário de 8 bits
      
      Serial.print("Decimal Enviado: ");
      Serial.print(dadoParaEnviar);
      Serial.print(" | Binario: ");
      Serial.println(dadoParaEnviar, BIN);
    }
    
    // Limpa o buffer do Serial (descarta \n ou \r)
    while(Serial.available() > 0) Serial.read();
  }

  // 2. Recebe 8 bits da FPGA e mostra o decimal no PC
  if (fpgaserial.available() > 0) {
    // Lê o byte bruto vindo da FPGA
    byte dadoRecebido = fpgaserial.read(); 
    
    Serial.print("Recebido da FPGA (Decimal): ");
    Serial.println(dadoRecebido); // O print de um byte já mostra o decimal
    Serial.print("Em Binario: ");
    Serial.println(dadoRecebido, BIN);
    Serial.println("---");
  }
}
