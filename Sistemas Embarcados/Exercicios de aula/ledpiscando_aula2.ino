//circuito no qual: dois leds piscam alternadamente

const int ledPin1 = 13;
const int ledPin2 = 8;

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  Serial.begin(9600);
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(ledPin1, HIGH); 
  digitalWrite(ledPin2, LOW);  
  Serial.println("LED1_ON LED2_OFF");
  delay(1000);                       
  digitalWrite(ledPin2, HIGH); 
  digitalWrite(ledPin1, LOW);  
  Serial.println("LED2_ON LED1_OFF");
  delay(1000);                       
}
