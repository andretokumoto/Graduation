#include <SoftwareSerial.h>

// Define pinos: RX no 10, TX no 11
// Conecte: TX da FPGA -> Pino 10 (RX) do Arduino
// Conecte: Pino 11 (TX) do Arduino -> Divisor de Tensão -> RX da FPGA
SoftwareSerial fpgaserial(10, 11); 

void setup() {
  Serial.begin(9600);      // Comunicação com o PC (Monitor Serial)
  fpgaserial.begin(9600);  // Comunicação com a FPGA
  
  Serial.println("Sistema Pronto. Digite um numero para enviar a FPGA:");
}

void loop() {
  // 1. Recebe do PC e manda para a FPGA
  if (Serial.available()) {
    char c = Serial.read();
    fpgaserial.write(c); 
    Serial.print("Enviado para FPGA: ");
    Serial.println(c);
  }

  // 2. Recebe da FPGA e manda para o PC
  if (fpgaserial.available()) {
    char c = fpgaserial.read();
    Serial.print("Recebido da FPGA: ");
    Serial.println(c);
  }
}