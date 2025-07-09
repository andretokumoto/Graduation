#include <Wire.h>

String comando = "";
byte ByteHora;
byte ByteMinuto;

void setup() {
  Serial.begin(9600);   // Comunicação com PC
  Serial2.begin(9600);  // Comunicação com PIC (via UART)

  Wire.begin(0x2C);             // Endereço I2C do Arduino (como escravo)
  Wire.setClock(100000);        // Frequência I2C 100kHz
  Wire.onReceive(receiveEvent); // Evento ao receber dados I2C
}

void loop() {
  if (Serial.available()) {
    comando = Serial.readStringUntil('\n');
    comando.trim();
    delay(50);

    if (comando == "Ventoinha0") {
      Serial2.write('0');
    } 
    else if (comando == "Ventoinha1") {
      Serial2.write('1');
    } 
    else if (comando == "Ventoinha2") {
      Serial2.write('2');
    }
    else if (comando == "VentoinhaManual") {
      Serial2.write('3');
    }
    else if (comando == "Hora") {
      Serial2.write('4');  // Solicita hora ao PIC
    }
  }
}

void receiveEvent(int howMany) {
  if (howMany >= 2) {
    ByteHora = Wire.read();
    ByteMinuto = Wire.read();

    Serial.print("Hora: ");
    if (ByteHora < 10) Serial.print("0");
    Serial.print(ByteHora);
    Serial.print(":");
    if (ByteMinuto < 10) Serial.print("0");
    Serial.println(ByteMinuto);
  }
}