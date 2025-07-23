#include <Key.h>
#include <Keypad.h>
#include <Wire.h>

// Configurações do teclado matricial
const byte LINHAS = 4;
const byte COLUNAS = 4;

char teclas[LINHAS][COLUNAS] = {
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}
};

byte pinosLinhas[LINHAS] = {2, 3, 4, 5};
byte pinosColunas[COLUNAS] = {6, 7, 8, 9};

// periféricos externos
const int botaoPorta = 51;
const int sensorPresenca = 50;
const int ledAlarme = 12;
const int ledPedeSenha = 13;
const int buzzerAlarme = 11;
const int ledPorta = 52;

// debounce e acionamento do botão
unsigned long lastDebounce = 0;
unsigned long debounceDelay = 50;
int statusBotao = HIGH;      
int lastBotaoStatus = LOW;

// intervalos de tempo
unsigned long previousMilli = 0;
unsigned long previousMilliAtivou = 0;
unsigned long previousMilliTranca = 0;
unsigned long tempoAtivacao = 0; // Variável para controle do tempo de ativação
const long intervalo = 15000;
const long intervaloBuzzer = 1000;
const long tempoEsperaAtivacao = 5000; // 5 segundos para ativação
unsigned long previousMilliBuzzer = 0;
int BuzzerStatus = LOW;
int alarmeDisparado = LOW;
int lastStatusAlarme = LOW;
int aguardandoAtivacao = 0; // Flag para indicar que está no período de ativação

// variáveis diversas
int alarmeAtivo = HIGH;
int presencaDetectada = LOW;
static String senhaEntrada = "";
static String senhaSalva = "1234#";
int pwmLedAlarme = 0;
byte ByteRecebido;
int portaberta = HIGH;
int controleBitDisparado = LOW;

Keypad teclado = Keypad(makeKeymap(teclas), pinosLinhas, pinosColunas, LINHAS, COLUNAS);

int brilho = 0;
int incremento = 5;
unsigned long ultimoTempoFade = 0;
unsigned long intervaloFade = 10;

void setup() {
  pinMode(botaoPorta, INPUT_PULLUP);
  pinMode(sensorPresenca, INPUT);
  pinMode(ledAlarme, OUTPUT);
  pinMode(ledPedeSenha, OUTPUT);
  pinMode(ledPorta, OUTPUT);
  pinMode(buzzerAlarme, OUTPUT);
  Serial.begin(9600);
  Serial2.begin(9600);
}

void loop() {
  
  digitalWrite(ledPorta, portaberta);

  if(alarmeDisparado == LOW){
    digitalWrite(ledAlarme,alarmeAtivo);
  }

  int estadoBotao = digitalRead(botaoPorta);

  // Detecta mudança no estado do botão (porta)
  if (estadoBotao != lastBotaoStatus) {
    lastDebounce = millis();
  }

  if ((millis() - lastDebounce) > debounceDelay) {
    if (estadoBotao != statusBotao) {
      statusBotao = estadoBotao;
      
      if (statusBotao == LOW ) {
        portaberta = !portaberta;
        if(alarmeAtivo == HIGH && portaberta == LOW) {
          presencaDetectada = HIGH;
        }
      }
    }
  }

  lastBotaoStatus = estadoBotao;

  int DetectaPresenca = digitalRead(sensorPresenca);

  if (DetectaPresenca == HIGH) {
    if (alarmeAtivo == HIGH) {
      presencaDetectada = HIGH;
    }
  }

  if (presencaDetectada == HIGH && alarmeDisparado == LOW) {
    
    digitalWrite(ledPedeSenha, HIGH);
    unsigned long currentMilli = millis();

    if (currentMilli - previousMilli <= intervalo) {
      
        if (Serial.available()) {
            senhaEntrada = Serial.readStringUntil('\n');
            senhaEntrada.trim();
            delay(50);
            
            if (senhaEntrada == senhaSalva) {
              alarmeAtivo = LOW;
              presencaDetectada = LOW;
              senhaEntrada = "";
              digitalWrite(ledPedeSenha, LOW);
            } 
            else {
              senhaEntrada = "";
            }
        }
      
      
      
      /*char tecla = teclado.getKey();
      if (tecla) {
        senhaEntrada += tecla;
        Serial.println(senhaEntrada);

        if (tecla == '#') {
          if (senhaEntrada == senhaSalva) {
            alarmeAtivo = LOW;
            presencaDetectada = LOW;
            senhaEntrada = "";
            digitalWrite(ledPedeSenha, LOW);
          } 
          else {
            senhaEntrada = "";
          }
        }
      }*/
    } 
    else {
      alarmeDisparado = HIGH;
      digitalWrite(ledPedeSenha, LOW);
      
    }
  }

  // Verificação de senha quando alarme está desativado
  if (alarmeAtivo == LOW) {
/*    char tecla = teclado.getKey();
    if (tecla) {
      senhaEntrada += tecla;
      Serial.println(senhaEntrada);

      if (tecla == '#') {
        if (senhaEntrada == senhaSalva) {
          // Inicia o processo de ativação com temporizador
          tempoAtivacao = millis();
          aguardandoAtivacao = 1;
          senhaEntrada = "";
         // Serial.println("Aguardando 5 segundos para ativar alarme");
        } 
        else {
          senhaEntrada = "";
        }
      }
    }*/
   
        if (Serial.available()) {
            senhaEntrada = Serial.readStringUntil('\n');
            senhaEntrada.trim();
            delay(50);
            
            if (senhaEntrada == senhaSalva) {
              // Inicia o processo de ativação com temporizador
              tempoAtivacao = millis();
              aguardandoAtivacao = 1;
              senhaEntrada = "";
             // Serial.println("Aguardando 5 segundos para ativar alarme");
            } 
            else {
              senhaEntrada = "";
            }
        }    
  }

  // Verifica se passaram os 5 segundos de ativação
  if (aguardandoAtivacao && (millis() - tempoAtivacao >= tempoEsperaAtivacao)) {
    alarmeAtivo = HIGH;
    presencaDetectada = LOW;
    aguardandoAtivacao = 0;
 
  }

  if (alarmeDisparado == HIGH) { 
    
    if(controleBitDisparado == LOW){
        Serial2.write(2);
        controleBitDisparado = HIGH;
    }
    
    unsigned long currentMillis = millis();
    if (currentMillis - previousMilliBuzzer >= intervaloBuzzer) {
      previousMilliBuzzer = currentMillis;
      BuzzerStatus = !BuzzerStatus;
      digitalWrite(buzzerAlarme, BuzzerStatus);
    }
    else {
        digitalWrite(buzzerAlarme, LOW);
    }
  }


  //controle de led alarme com efeito fade
  if (alarmeDisparado == HIGH) {
    unsigned long tempoAtual = millis();
    if (tempoAtual - ultimoTempoFade >= intervaloFade) {
      ultimoTempoFade = tempoAtual;
      analogWrite(ledAlarme, brilho);
      brilho += incremento;
  
      if (brilho <= 0 || brilho >= 255) {
        incremento = -incremento;
      }
    }
  }

  //Recebe comando do PIC
  if (Serial2.available()) {
    
    ByteRecebido = Serial2.read();

    if(ByteRecebido == 0) { //desativar alarme
      alarmeDisparado = LOW;
      alarmeAtivo = LOW;
      aguardandoAtivacao = 0; // Cancela qualquer ativação pendente
      digitalWrite(buzzerAlarme, LOW);
      controleBitDisparado = LOW;
    }
    else if(ByteRecebido == 1) { //ativar o alarme - sem disparo
      alarmeAtivo = HIGH;
      aguardandoAtivacao = 0; // Cancela qualquer ativação pendente
    }
    else if(ByteRecebido == 2){ //disparo do alarme
      alarmeDisparado = HIGH;
    }
  }
}
