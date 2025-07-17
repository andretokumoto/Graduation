#include <Key.h>
#include <Keypad.h>

// Projeto final da UC de sistemas embarcados desenvolvido por André Filipe Siqueira Tokumoto

// teclado matricial
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
const int sensorPorta = 10;
const int sensorPreseca = 52;
const int ledAlarme = 12;
const int ledPedeSenha = 13;
const int buzzerAlarme = 11;

// debounce e acionamento do sensorPorta
unsigned long lastDebaunce = 0;
unsigned long debaunceDelay = 50;
int statusPorta = HIGH;
int lastPortaSatus = LOW;

// intervalo para disparo do alarme
unsigned long previousMilli = 0;
const long intervalo = 15000;

const long intervaloBuzzer = 1000;
unsigned long previousMilliBuzzer = 0;
int BuzzerStatus = LOW;
int alarmeDisparado = LOW;
int lastStatusAlarme = LOW;

// variáveis diversas
int alarmeAtivo = HIGH;
int presencaDetectada = LOW;
static String senhaEntrada = "";
static String senhaSalva = "1234#";
int contadorDeErros = 0;
int pwmLedAlarme = 0;

Keypad teclado = Keypad(makeKeymap(teclas), pinosLinhas, pinosColunas, LINHAS, COLUNAS);


int brilho = 0;
int incremento = 5;
unsigned long ultimoTempoFade = 0;
unsigned long intervaloFade = 10;

void setup() {
  pinMode(sensorPorta, INPUT);
  pinMode(sensorPreseca, INPUT);
  pinMode(ledAlarme, OUTPUT);
  pinMode(ledPedeSenha, OUTPUT);
  pinMode(buzzerAlarme, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int DetectaSensorPorta = digitalRead(sensorPorta);
  int DetectaPresenca = digitalRead(sensorPreseca);

  if ((millis() - lastDebaunce) > debaunceDelay) {
    if (DetectaSensorPorta != statusPorta) {
      statusPorta = DetectaSensorPorta;
      if (statusPorta == HIGH) {
        if (alarmeAtivo == HIGH) presencaDetectada = HIGH;
      }
    }
  }

  if (DetectaPresenca == HIGH) {
    if (alarmeAtivo == HIGH) {
      presencaDetectada = HIGH;
    }
  }

  if (presencaDetectada == HIGH && alarmeDisparado == LOW) {
    digitalWrite(ledPedeSenha, HIGH);
    unsigned long courrentMilli = millis();

    if (courrentMilli - previousMilli <= intervalo) {
      char tecla = teclado.getKey();
      if (tecla) {
        senhaEntrada += tecla;
        if (tecla == '#') {
          if (senhaEntrada == senhaSalva) {
            alarmeAtivo = LOW;
            presencaDetectada = LOW;
            senhaEntrada = "";
            digitalWrite(ledPedeSenha, LOW);
            Serial.print("desarmou");
          } else {
            senhaEntrada = "";
            contadorDeErros++;
          }
        }
      }
    } else {
      alarmeDisparado = HIGH;
      digitalWrite(ledPedeSenha, LOW);
    }
  }

  if (alarmeDisparado != lastStatusAlarme) {
    if (alarmeDisparado == HIGH) {
      // Buzzer 
      unsigned long currentMillis = millis();
      if (currentMillis - previousMilliBuzzer >= intervaloBuzzer) {
        previousMilliBuzzer = currentMillis;
        BuzzerStatus = !BuzzerStatus;
        digitalWrite(buzzerAlarme, BuzzerStatus);
      }
    } else {
      digitalWrite(buzzerAlarme, LOW);
      contadorDeErros = 0;
    }

    lastStatusAlarme = alarmeDisparado;
  }

  //controle de led alrme com efeito fade
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

  if (contadorDeErros >= 3) alarmeDisparado = HIGH;
}




