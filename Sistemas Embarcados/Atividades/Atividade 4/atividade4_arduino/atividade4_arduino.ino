String estadoled;
byte ByteRecebido;
int contador = 0;

void setup() {
  Serial.begin(9600);    // UART para monitor serial
  Serial2.begin(9600);   // UART2 para comunicação com o PIC
}

void loop() {
  //Serial.println(Serial2.available());
  if (Serial2.available() >= 3) {              // Espera os dois bytes chegarem
    ByteRecebido = Serial2.read();             // Primeiro byte: contagem
    contador = ByteRecebido;

    ByteRecebido = Serial2.read();             // Segundo byte: estado do LED

    if (ByteRecebido == 1) {
      estadoled = "LED ON";
    } else {
      estadoled = "LED OFF";
    }

    Serial.print("Valor da contagem: ");
    Serial.print(contador);
    Serial.print("  ");
    Serial.println(estadoled);
  }
}
