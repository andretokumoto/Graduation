void setup() {

  Serial.begin(9600);

}

void loop() {

  if (Serial.available()) {

    char c = Serial.read();

    Serial.print("Recebido: ");
    Serial.println(c);

  }

}