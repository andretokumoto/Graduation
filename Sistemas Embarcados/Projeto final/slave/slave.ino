// Projeto final da UC de sistemas embarcados desenvolvido por André Filipe Siqueira Tokumoto

#include <Key.h>
#include <Keypad.h>
#include <Wire.h>]
#include <LiquidCrystal_I2C.h>



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
const int sensorPorta = 4; // Agora usando porta 4 da chave DIP
const int sensorPreseca = 50;
const int ledAlarme = 12;
const int ledPedeSenha = 13;
const int ledAlarmeDesativado = 52;
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
byte ByteRecebido;
int controleDeteccao = 0;

Keypad teclado = Keypad(makeKeymap(teclas), pinosLinhas, pinosColunas, LINHAS, COLUNAS);

// LCD I2C
LiquidCrystal_I2C lcd(0x27, 16, 2); // Endereço 0x27, LCD 16x2

int brilho = 0;
int incremento = 5;
unsigned long ultimoTempoFade = 0;
unsigned long intervaloFade = 10;

void setup() {
  pinMode(sensorPorta, INPUT_PULLUP); // <- Usando pull-up interno
  pinMode(sensorPreseca, INPUT);
  pinMode(ledAlarme, OUTPUT);
  pinMode(ledPedeSenha, OUTPUT);
  pinMode(ledAlarmeDesativado, OUTPUT);
  pinMode(buzzerAlarme, OUTPUT); 
  Serial.begin(9600);
  Serial2.begin(9600);   // UART2 para comunicação com o PIC

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

  if(alarmeAtivo == LOW){
    digitalWrite(ledAlarmeDesativado,HIGH);
  }

  if(alarmeAtivo == HIGH){
    digitalWrite(ledAlarmeDesativado,LOW);
  }

  if (DetectaSensorPorta != statusPorta) {
    lastDebaunce = millis();
    statusPorta = DetectaSensorPorta;
    if (statusPorta == LOW) {  // Invertido devido ao INPUT_PULLUP
      if (alarmeAtivo == HIGH) presencaDetectada = HIGH;
    }
  }

  if (DetectaPresenca == HIGH && controleDeteccao==0) {
    if (alarmeAtivo == HIGH) {
      presencaDetectada = HIGH;
      Serial2.write('p');
      controleDeteccao = 1;
    }
  }

  if (presencaDetectada == HIGH && alarmeDisparado == LOW) {



    digitalWrite(ledPedeSenha, HIGH);
    unsigned long courrentMilli = millis();

    if (courrentMilli - previousMilli <= intervalo) {
      char tecla = teclado.getKey();
      if (tecla) {
        senhaEntrada += tecla;

        lcd.setCursor(0, 1);
        lcd.print("            ");

        lcd.setCursor(0, 0);
        lcd.print("Senha: ");
        lcd.print(senhaEntrada);
        int espacosRestantes = 10 - senhaEntrada.length();
        for (int i = 0; i < espacosRestantes; i++) lcd.print(" ");

        if (tecla == '#') {
          if (senhaEntrada == senhaSalva) {
            if (alarmeAtivo == HIGH) {
              alarmeAtivo = LOW;
              presencaDetectada = LOW;
              senhaEntrada = "";
              digitalWrite(ledPedeSenha, LOW);
              analogWrite(ledAlarme,0);
              lcd.setCursor(0, 1);
              lcd.print("Alarme desativado ");
              Serial.println("desativado");
            } else {
              alarmeAtivo = HIGH;
              lcd.setCursor(0, 1);
              lcd.print("Alarme Ativo ");
            }
          } else {
            senhaEntrada = "";
            contadorDeErros++;
            lcd.setCursor(0, 1);
            lcd.print("Senha incorreta   ");
          }

          lcd.setCursor(0, 0);
          lcd.print("Senha:            ");
        }
      }
    } else {
      alarmeDisparado = HIGH;
      digitalWrite(ledPedeSenha, LOW);
      Serial2.write('d');
    }
  }

  if (alarmeDisparado == HIGH) {
    //Serial.println("alarme disparado"); 
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

  if (contadorDeErros >= 3) {
    alarmeDisparado = HIGH;
    Serial2.write('d');
  }

  if (alarmeAtivo == HIGH && alarmeDisparado == LOW) {
    analogWrite(ledAlarme,255);
  }

  if (lastStatusAlarme != alarmeAtivo) {
    if (alarmeAtivo == HIGH && DetectaSensorPorta == LOW) {  // Invertido para pull-up
      unsigned long currentMilliAtivou = millis();
      if (currentMilliAtivou - previousMilliAtivou <= intervalo) {
        lcd.setCursor(0, 1);
        lcd.print("Alarme Ativo");
      } else {
        alarmeDisparado = HIGH;
        Serial2.write('d');
      }
    } 
    if(alarmeAtivo == LOW){
      controleDeteccao = 0;
    }

    lastStatusAlarme = alarmeAtivo;
  }

  if (Serial2.available()) {
    ByteRecebido = Serial2.read();
    delay(50);

    Serial.print("recebido: ");
    Serial.println(ByteRecebido);

    if (ByteRecebido == 0) {
      alarmeDisparado = LOW;
      alarmeAtivo = LOW;
      contadorDeErros = 0;
      lcd.setCursor(0, 1);
      lcd.print("Alarme Desativado");
    }
    else if (ByteRecebido == 1) {
      alarmeAtivo = HIGH;
    }
    else {
      alarmeDisparado = HIGH;
      Serial2.write('d');
    }
  }
}
