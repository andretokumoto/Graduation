const int pinEncoder = 2;
int estadoAnterior = LOW;
long contagem = 0;

void setup() {
  Serial.begin(9600);
  pinMode(pinEncoder, INPUT);
}

void loop() {
  int estado = digitalRead(pinEncoder);
  Serial.println(estado);
   delay(50);
}