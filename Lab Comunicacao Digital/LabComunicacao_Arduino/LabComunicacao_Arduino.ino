#include <SoftwareSerial.h>

// Conexões:
// TX da FPGA -> Pino 4 (RX) do Arduino [cite: 181]
// Pino 11 (TX) do Arduino -> Divisor de Tensão (5V para 3.3V) -> RX da FPGA [cite: 181]
SoftwareSerial fpgaserial(4, 11);

void setup() {
  Serial.begin(9600);      // Monitor Serial do PC [cite: 182]
  fpgaserial.begin(9600);  // Comunicação com a FPGA [cite: 182]
  
  Serial.println("Sistema Pronto. Digite um NUMERO e aperte ENTER:"); [cite: 183]
}

void loop() {
  // 1. Recebe valor numérico do PC e manda para a FPGA
  if (Serial.available() > 0) {
    // Lê a entrada como um número inteiro (ex: "10" vira o valor 10)
    int valor = Serial.parseInt(); 
    
    // Envia apenas o byte (8 bits) para a FPGA 
    // Isso casa com o rt[7:0] do seu módulo CPU.v [cite: 36]
    fpgaserial.write((byte)valor); 
    
    Serial.print("Valor numérico enviado: ");
    Serial.println(valor);
  }

  // 2. Recebe da FPGA e manda para o PC
  if (fpgaserial.available()) {
    // A FPGA envia o resultado processado (ex: o resultado da instrução outTX) [cite: 36, 140]
    byte c = fpgaserial.read(); [cite: 185]
    
    Serial.print("Recebido da FPGA (Resultado): ");
    Serial.println((int)c); // Mostra o valor numérico recebido
  }
}