/*
 * testecomunicacao.ino
 *
 * Envia um valor de 16 bits (0–65535) para a FPGA via UART.
 *
 * Protocolo:
 *   O valor é transmitido em DOIS bytes consecutivos:
 *     1º byte  →  bits [15:8]  (byte alto / MSB)
 *     2º byte  →  bits [ 7:0]  (byte baixo / LSB)
 *
 *   A FPGA monta os dois bytes na chegada e atualiza a saída
 *   de 32 bits somente após receber o par completo.
 *
 * Ligações:
 *   Arduino pino 4  → RX do SoftwareSerial (não usado para TX neste sketch)
 *   Arduino pino 11 → TX do SoftwareSerial → pino UART_RX da FPGA
 */

#include <SoftwareSerial.h>

// RX no pino 4 (não conectado / não usado), TX no pino 11
SoftwareSerial fpgaserial(4, 11);

void setup() {
  Serial.begin(9600);
  fpgaserial.begin(9600);

  Serial.println("Sistema pronto. Digite um numero (0-65535) e pressione Enter:");
}

void loop() {
  // -----------------------------------------------------------
  // Lê um número do Monitor Serial e envia para a FPGA
  // -----------------------------------------------------------
  if (Serial.available() > 0) {
    long valorEntrada = Serial.parseInt();

    // Garante que cabe em 16 bits
    if (valorEntrada >= 0 && valorEntrada <= 65535) {
      uint16_t dado16 = (uint16_t)valorEntrada;

      byte byteAlto  = (byte)(dado16 >> 8);    // bits [15:8]
      byte byteBaixo = (byte)(dado16 & 0xFF);  // bits [ 7:0]

      // Envia byte alto primeiro, depois byte baixo
      fpgaserial.write(byteAlto);
      fpgaserial.write(byteBaixo);

      Serial.print("Valor enviado (decimal): ");
      Serial.println(dado16);
      Serial.print("  Byte alto  (hex): 0x");
      if (byteAlto < 0x10) Serial.print("0");
      Serial.println(byteAlto, HEX);
      Serial.print("  Byte baixo (hex): 0x");
      if (byteBaixo < 0x10) Serial.print("0");
      Serial.println(byteBaixo, HEX);
      Serial.print("  Binario 16 bits : ");
      for (int i = 15; i >= 0; i--) {
        Serial.print((dado16 >> i) & 1);
        if (i == 8) Serial.print("_");  // separador visual entre bytes
      }
      Serial.println();
      Serial.println("---");
    } else {
      Serial.println("Valor fora do intervalo! Use 0 a 65535.");
    }

    // Descarta \n e \r residuais do buffer
    while (Serial.available() > 0) Serial.read();
  }
}
