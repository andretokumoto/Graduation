/* Enviando dados entre PIC18F4520 e ATmega2560.*/
 
const int ledPin = 13; // Pino ao qual o LED será conectado
int piscando = 0; // variável para armazenar taxa de “piscagem”
int Control = 0;  // +++++++ VARIAVEL DE CONTROLE DA COMUNICAÇÃO ++++++++
                  // LEMBRE DE ALTERAR ESSA VARIAVE TAMBEM NO PIC

void setup() {
Serial.begin(9600);
Serial2.begin(9600);
pinMode(ledPin, OUTPUT); // Pino 13 será de saída de sinais
//Serial.println("teste");
}
 
void loop()
{
   digitalWrite(ledPin, HIGH);  
   if (Control == 0){
     if (Serial2.available()) { // Verificar se há caracteres disponíveis
       char caractere = Serial1.read(); // Armazena caracter lido. 
       Serial.print("Char Received =");
       Serial.println(caractere);
       if(caractere == 'T') {
         Serial2.write('S');
         delay(100);
       }
     }
   }

  if (Control == 1){
      Serial2.write('M');
     if (Serial2.available()){ // Verificar se há caracteres disponíveis
        char caractere = Serial2.read(); // Armazena caracter lido. 
        if (caractere == 'P'){
            Serial.print("Char Received =");
            Serial.println(caractere);
            delay(100);
        }
     }
  }
}