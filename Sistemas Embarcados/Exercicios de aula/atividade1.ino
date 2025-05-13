//atividade 1 de sistemas embarcados - André F. S. Tokumoto

const int botao = 2;
const int ledR = 3;
const int ledG = 4;

unsigned long lastDebaunce = 0;
unsigned long debaunceDelay = 50;

int statusBotao = HIGH;
int lastButtonSatus = LOW;
int contador = 0;

unsigned long previousMilli = 0;
const long intervalo = 1000;
int ledGStatus = LOW;

void setup() {

  Serial.begin(9600);
  pinMode(ledR, OUTPUT);
  pinMode(ledG, OUTPUT);
  pinMode(botao, INPUT);

//leds inicialmente apagados
  digitalWrite(ledR,LOW);
  digitalWrite(ledG,LOW);

}

void loop() {

  int leituraBotao = digitalRead(botao);

 //leitura do botao
  if( ( millis() - lastDebaunce ) > debaunceDelay){

      if( leituraBotao != statusBotao ) {
          statusBotao = leituraBotao;


          if( statusBotao == HIGH ){

            if(contador <=2){
               contador = contador + 1;//incrementa contador
            }
            else{
              contador = 1;
            }
          }
      }

      lastButtonSatus = leituraBotao;
  }

  //etapas de controle do led
  if(contador == 1){//etapa 2

      unsigned currentMillis = millis();
      
      if( currentMillis - previousMilli >= intervalo ){

          previousMilli = currentMillis;

          if(ledGStatus == LOW){
             ledGStatus = HIGH;
             Serial.println("LEDG piscando");
          }
          else{
            ledGStatus = LOW;
            Serial.println("LEDG piscando");
          }
          
          digitalWrite(ledG,ledGStatus);
          digitalWrite(ledR,LOW);
                
      }
  
  }
  if(contador == 2){//etapa 3

        digitalWrite(ledG,LOW);
        digitalWrite(ledR,HIGH);
        Serial.println("LEDR ON");
  }

  if(contador == 3){//etapa 3

        digitalWrite(ledG,LOW);
        digitalWrite(ledR,LOW);
        Serial.println("LEDs OFF");
  }

}
