#include <Key.h>
#include <Keypad.h>



//Projeto final da UC de sistemas embarcados desenvolvido por André Filipe Siqueira Tokumoto



//teclado matricial
const byte LINHAS = 4;
const byte COLUNAS = 4;

char teclas[LINHAS][COLUNAS] = {// Mapeamento das teclas
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}
};

// Pinos conectados às linhas e colunas
byte pinosLinhas[LINHAS] = {2, 3, 4, 5};
byte pinosColunas[COLUNAS] = {6, 7, 8, 9};

//perifericos externos
const int sensorPorta = 10;
const int sensorPreseca = 52;
const int ledAlarme = 12;
const int ledPedeSenha = 13;
const int buzzerAlarme = A0;

//debounce e acionamento do sensorPorta (swich)
unsigned long lastDebaunce = 0;
unsigned long debaunceDelay = 50;
int statusPorta = HIGH;
int lastPortaSatus = LOW;

//intervalo para disparo do alarme
unsigned long previousMilli = 0;
const long intervalo = 15000; //30 segundos

int statusBuzzer = LOW;
int alarmeDisparado = LOW;
int lastStatusAlarme = LOW;

//variaveis diversas
int alarmeAtivo = HIGH; //define se alarme ativado
int presencaDetectada = LOW;
static String senhaEntrada = "";
static String senhaSalva = "1234#";
int contadorDeErros = 0;

Keypad teclado = Keypad(makeKeymap(teclas), pinosLinhas, pinosColunas, LINHAS, COLUNAS);

void setup() {
  // put your setup code here, to run once:
  pinMode(sensorPorta, INPUT);
  pinMode(sensorPreseca, INPUT);

  pinMode(ledAlarme, OUTPUT);
  pinMode(ledPedeSenha, OUTPUT);
  pinMode(buzzerAlarme, OUTPUT);

  Serial.begin(9600);
}

void loop() {
    // put your main code here, to run repeatedly:

    int DetectaSensorPorta = digitalRead(sensorPorta); //acionamento do switch de sensor da porta
    int DetectaPresenca = digitalRead(sensorPreseca);//detecção de presença


    // detecta mudança do estado da porta: aberta ou fechada
    if ((millis() - lastDebaunce) > debaunceDelay) {

      if (DetectaSensorPorta != statusPorta) {
          statusPorta = DetectaSensorPorta;

          if (statusPorta == HIGH) { //porta aberta
              if (alarmeAtivo == HIGH) presencaDetectada = HIGH; //detecta que a sala foi aberta com alarme ativo
          }
      }
    }

    //detector de presença
    if (DetectaPresenca == HIGH) {
       //Serial.println("detectou");
       if (alarmeAtivo == HIGH) {
          presencaDetectada = HIGH;
          //Serial.println("presença");
       }
    }

    //se presença ou porta foi detectada, iniciar temporizador
    if (presencaDetectada == HIGH && alarmeDisparado == LOW) {
        digitalWrite(ledPedeSenha, HIGH); //indica que deve digitar a senha
        unsigned long courrentMilli = millis();

        if (courrentMilli - previousMilli <= intervalo) {
            //digitação da senha
            char tecla = teclado.getKey();
            if (tecla) {
                senhaEntrada += tecla;
               // Serial.print("senha: ");
                //Serial.println(senhaEntrada);
                //mandar para LCD
                if (tecla == '#') {  // Confirmação
                    if (senhaEntrada == senhaSalva) { //senha correta
                        alarmeAtivo = LOW;
                        presencaDetectada = LOW;
                        senhaEntrada = "";
                        digitalWrite(ledPedeSenha, LOW);
                        Serial.print("desarmou");
                    } else {
                        senhaEntrada = ""; //errou, recomeça
                        contadorDeErros++;
                    }
                }
            }
        } else {
            //tempo esgotou, alarme dispara
            alarmeDisparado = HIGH;
            digitalWrite(ledPedeSenha, LOW);
        }
    }


    //acionamento do alarme
    if(alarmeDisparado != lastStatusAlarme){//verifica mudança no estado do alarme
        //manda para pic
        if(alarmeDisparado == HIGH){
          analogWrite(buzzerAlarme,255);
          Serial.println("buzzer");
        }

        lastStatusAlarme = alarmeDisparado;
    }

    if(contadorDeErros >= 3) alarmeDisparado = HIGH; //3 erros aciona o alarme



}