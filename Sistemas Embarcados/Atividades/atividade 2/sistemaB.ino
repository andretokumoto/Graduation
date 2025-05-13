const int ledG1 = 2;
const int ledG2 = 3;
const int ledG3 = 4;
const int ledY1 = 6;
const int ledY2 = 7;
const int Potenciomentro = A1; 
const int LDR = A0; 

int ValorLidoLDR = 0;
int ValorPot = 0;
int volume = 0; 
int pwmLuminoso = 0;

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
    volume = map(ValorPot, 0, 1023, 0, 100); // Calcula porcentagem

    ValorLidoLDR = analogRead(LDR);

    //----------------Controle de Volume----------------
    if(volume == 0) {
        analogWrite(ledG1, 0);
        analogWrite(ledG2, 0);
        analogWrite(ledG3, 0);
    }
    else if(volume > 0 && volume <= 33) {
        // Só LEDG1 aceso
        int brilho = map(volume, 0, 33, 0, 255);
        analogWrite(ledG1, brilho);
        analogWrite(ledG2, 0);
        analogWrite(ledG3, 0);
    }
    else if(volume > 33 && volume <= 66) {
        // LEDG1 totalmente aceso, LEDG2 variando
        analogWrite(ledG1, 255);
        int brilho = map(volume, 34, 66, 0, 255);
        analogWrite(ledG2, brilho);
        analogWrite(ledG3, 0);
    }
    else {
        // LEDs G1 e G2 totalmente acesos, LEDG3 variando
        analogWrite(ledG1, 255);
        analogWrite(ledG2, 255);
        int brilho = map(volume, 67, 100, 0, 255);
        analogWrite(ledG3, brilho);
    }

 
    Serial.print("Volume: ");
    Serial.print(volume);
    Serial.println("%");
    delay(100);
    //------------ Controle de luminosidade-----------------

    if(ValorLidoLDR < 500){ //baixa luminosidade

        analogWrite(ledY1, pwmLuminoso);
        analogWrite(ledY2, pwmLuminoso);
        pwmLuminoso++;
        delay(100);
    }
    else if(ValorLidoLDR < 900){//luz natural
        digitalWrite(ledY1, HIGH);
        digitalWrite(ledY2, LOW);
        pwmLuminoso = 0;
    }
    else{
        digitalWrite(ledY1, LOW);
        digitalWrite(ledY2, LOW);
        pwmLuminoso = 0; 
    }

    if (pwm > 255){ // Define o valor limite para o duty cycle
        pwm=255;
    }
}