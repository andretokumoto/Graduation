const int buttonMais = 2;
const int buttonMenos = 4;//botoes de temperatura
const int ledR = 6;
const int ledG = 8;
const int LM35 = 0;
const int Buzzer = 10;

int lastButtonMais = LOW;
int lastButtonMenos = LOW;
int ButtonMaisState;
int ButtonMenosState;

unsigned long lastDebounceTime = 0;
unsigned long DebounceDelay = 50;
unsigned long previousMilliLed = 0;
const long intervaloLedR = 500;
int ledRStatus = LOW;
const long intervaloBuzzer = 3000;
unsigned long previousMilliBuzzer = 0;
int BuzzerStatus = LOW;

int Tdes;
float temperatura = 0;  //armazena temperatura
int ADClido = 0; //inicia variavel que armazena valor ADC

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(buttonMais,INPUT);
  pinMode(buttonMenos,INPUT);
  pinMode(ledR,OUTPUT);
  pinMode(ledG,OUTPUT);
  Tdes = 21;
  analogReference(INTERNAL1V1);
  pinMode(Buzzer, OUTPUT); 
}

void loop() {
  // put your main code here, to run repeatedly:
  int mais = digitalRead(buttonMais);
  int menos = digitalRead(buttonMenos);

//Mudança de temperatura---------------------------------
  Serial.print("Temperatura desejada = ");
  Serial.println(Tdes);


  if (mais != lastButtonMais || menos != lastButtonMenos){//acionamento de algum botao
      lastDebounceTime = millis();
  }

  if( (millis() - lastDebounceTime) > DebounceDelay ){

    if(mais != ButtonMaisState){ //acionamento do botao de aumentar temperatura desejada
      ButtonMaisState = mais;

      if(ButtonMaisState == HIGH){
        Tdes = Tdes+1;
        Serial.println("incrementa");
      }
    }

    
    if(menos != ButtonMenosState){ //acionamento do botao de diminuir temperatura desejada
      ButtonMenosState = menos;

      if(ButtonMenosState == HIGH){
        Tdes = Tdes-1;
        Serial.println("decrementa");
      }
    }
    
  }
 //-----------------------------------------------------------

 //leitura da temperatura e controle dos leds-------------------

  Serial.print("Temperatura = ");
  Serial.println(temperatura);

  ADClido = analogRead(LM35); // converte e armaneza valores
  temperatura = ADClido * 0.1075268817;  

  if( temperatura < (Tdes - 1.5)){//temperatura abaixo

    unsigned currentMillis = millis();
    if( currentMillis - previousMilliLed >= intervaloLedR ){
        
      previousMilliLed = currentMillis;

      if(ledRStatus == LOW){
        ledRStatus = HIGH;
      }
      else{
        ledRStatus = LOW;
      }
      digitalWrite(ledR,ledRStatus);
      digitalWrite(ledG,LOW);
    }

  }

  else if(temperatura > (Tdes - 1.5)){ //temperatura acima
    
    unsigned currentMillis = millis();
    if( currentMillis - previousMilliBuzzer >= intervaloBuzzer ){

      previousMilliBuzzer = currentMillis;
         
      if(BuzzerStatus == LOW){
        BuzzerStatus = HIGH;
      }
      else{
        BuzzerStatus = LOW;
      }
      digitalWrite(Buzzer, BuzzerStatus);
    }
  }

  else{ //temperatura dentro da faixa ideal
    digitalWrite(ledG,HIGH);
    digitalWrite(ledR,LOW);
  }
  

 //----------------------------------------------------------------
  
}