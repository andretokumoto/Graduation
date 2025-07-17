#include <Key.h>
#include <Keypad.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h> // Adicionado

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
unsigned long previousMilliAtivou = 0;
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

// LCD I2C
LiquidCrystal_I2C lcd(0x27, 16, 2); // Endereço 0x27, LCD 16x2

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

  // Inicializa o LCD
  lcd.init();
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Senha: ");
}

void loop() {
  int DetectaSensorPorta = digitalRead(sensorPorta);
  int DetectaPresenca = digitalRead(sensorPreseca);

  if (DetectaSensorPorta != statusPorta) {
    lastDebaunce = millis();
    statusPorta = DetectaSensorPorta;
    if (statusPorta == HIGH) {
      if (alarmeAtivo == HIGH) presencaDetectada = HIGH;
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
        
        //limpa mensagem da linha 2
        lcd.setCursor(0, 1);
        lcd.print("            ");
        
        // linha 1 sempre exibe a senha digitada
        lcd.setCursor(0, 0);
        lcd.print("Senha: ");
        lcd.print(senhaEntrada);
        int espaçosRestantes = 10 - senhaEntrada.length();
        for (int i = 0; i < espaçosRestantes; i++) lcd.print(" ");

        if (tecla == '#') {
          if (senhaEntrada == senhaSalva) {
            alarmeAtivo = LOW;
            presencaDetectada = LOW;
            senhaEntrada = "";
            digitalWrite(ledPedeSenha, LOW);
            
            // mensagem na linha 2: alarme desativado
            lcd.setCursor(0, 1);
            lcd.print("Alarme desativado ");
          } 
          else {
            senhaEntrada = "";
            contadorDeErros++;

            // mensagem na linha 2: senha incorreta
            lcd.setCursor(0, 1);
            lcd.print("Senha incorreta   ");
          }

          // limpar linha 1 após validação
          lcd.setCursor(0, 0);
          lcd.print("Senha:            ");
        }
      }
    } 
    else {
      alarmeDisparado = HIGH;
      digitalWrite(ledPedeSenha, LOW);
    }
  }

  if (alarmeDisparado == HIGH) { 
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
  
  //alarme ativado
  if(lastStatusAlarme != alarmeAtivo){
     
   //alarme que estava desativado foi ativo 
    if(alarmeAtivo == HIGH && DetectaSensorPorta == 1){
      
      unsigned long currentMilliAtivou = millis();
      if (currentMilliAtivou - previousMilliAtivou <= intervalo) {
        
          //mensagem feche a porta para o lcd (linha 2)
          lcd.setCursor(0, 1);
          lcd.print("Alarme Ativo");
      }
      else{//alarme ativo mas porta aberta
        alarmeDisparado = HIGH;
      }      
    } 
    
    lastStatusAlarme = alarmeAtivo;
  }
}

