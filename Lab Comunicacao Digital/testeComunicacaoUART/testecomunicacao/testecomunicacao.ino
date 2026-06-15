#include <SoftwareSerial.h>

SoftwareSerial fpgaserial(4, 11); // pino 4 = RX (da FPGA), pino 11 = TX (para FPGA)

void setup() {
    Serial.begin(9600);
    fpgaserial.begin(9600);
}

void loop() {
    // Envia numero para a FPGA (sem sinal, 2 bytes, byte alto primeiro)
    if (Serial.available() > 0) {
        uint16_t dado = (uint16_t)Serial.parseInt();
        fpgaserial.write((byte)(dado >> 8));   // byte alto
        fpgaserial.write((byte)(dado & 0xFF)); // byte baixo
        Serial.print("Enviado: ");
        Serial.println(dado);
        while (Serial.available() > 0) Serial.read();
    }

    // Recebe resultado da FPGA (com sinal, 2 bytes, LSB primeiro)
    if (fpgaserial.available() >= 2) {
        uint8_t low  = fpgaserial.read();
        uint8_t high = fpgaserial.read();
        int16_t resultado = (int16_t)((high << 8) | low);
        Serial.print("Recebido: ");
        Serial.println(resultado);
    }
}
