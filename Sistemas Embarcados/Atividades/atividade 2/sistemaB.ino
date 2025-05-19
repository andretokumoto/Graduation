const int ledG1 = 10;
const int ledG2 = 9;
const int ledG3 = 8;
const int ledY1 = 6;
const int ledY2 = 7;
const int Potenciomentro = A1;
const int LDR = A0;

int ValorLidoLDR = 0;
int ValorPot = 0;
int volume = 0;
int pwmLuminoso = 0;
int luminosoporc = 0;


unsigned long previousMilliTemp = 0;
const long intervaloTemp = 1000;

void setup() {
    Serial.begin(9600);
    pinMode(ledG1, OUTPUT);
    pinMode(ledG2, OUTPUT);
    pinMode(ledG3, OUTPUT);
    pinMode(ledY1, OUTPUT);
    pinMode(ledY2, OUTPUT);

    digitalWrite(ledG1, LOW);
    digitalWrite(ledG2, LOW);
    digitalWrite(ledG3, LOW);
    digitalWrite(ledY1, LOW);
    digitalWrite(ledY2, LOW);
}

void loop() {

    ValorPot = analogRead(Potenciomentro);
    volume = map(ValorPot, 0, 1023, 0, 100);

    if(volume == 0) {
        analogWrite(ledG1, LOW);
        analogWrite(ledG2, LOW);
        analogWrite(ledG3, LOW);
    }
   else if(volume > 0 && volume <= 33) {
       
        int brilho = map(volume, 0, 33, 0, 255);
        analogWrite(ledG1, brilho);
        analogWrite(ledG2, LOW);
        analogWrite(ledG3, LOW);
    }
    else if(volume > 33 && volume <= 66) {
     
        int brilho = map(volume, 34, 66, 0, 255);
        analogWrite(ledG1, HIGH);
        analogWrite(ledG2, brilho);
        analogWrite(ledG3, LOW);
    }
    else {

        int brilho = map(volume, 67, 100, 0, 255);
        analogWrite(ledG1, HIGH);
        analogWrite(ledG2, HIGH);
        analogWrite(ledG3, brilho);
    }

   
//***    

    ValorLidoLDR = analogRead(LDR);
   
    if(ValorLidoLDR < 500){

        analogWrite(ledY1, pwmLuminoso);
        analogWrite(ledY2, pwmLuminoso);
        pwmLuminoso++;
        luminosoporc = 100;
        delay(100);
    }
    else if(ValorLidoLDR < 900){
        digitalWrite(ledY1, HIGH);
        digitalWrite(ledY2, LOW);
        luminosoporc = 50;
       
    }
    else{
        digitalWrite(ledY1, LOW);
        digitalWrite(ledY2, LOW);
        luminosoporc = 0;
       
    }

    unsigned currentMillisTemp = millis();

    if( currentMillisTemp - previousMilliTemp >= intervaloTemp ){
      previousMilliTemp = currentMillisTemp;
   
      Serial.print("Volume da música: ");
      Serial.print(volume);
      Serial.println("% ON");
 
     
      Serial.print("Luminosidade dos LEDs: ");
      Serial.print(luminosoporc);
      Serial.println("% ON");
  }

}