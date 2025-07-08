String comando = "";

void setup() {
  Serial.begin(9600);   // Comunicação com PC
  Serial2.begin(9600);  // Comunicação com PIC (assumindo uso do Mega ou similar)
}

void loop() {

  if (Serial.available()) {
    comando = Serial.readStringUntil('\n'); // Lê até receber '\n'
    comando.trim(); // Remove espaços e quebras de linha extras
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
  }
}
