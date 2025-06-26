//Slave

#include "Wire.h"
#include "string.h"
#include <LiquidCrystal.h> 

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
const int R = 9;
const int G = 10;
const int B = 7;
int buzzer = 6;
const int myAdress = 8; // Endereço I2C

int modoAtual = 0;
int intensidadeLuminosa = 0;
String mensagem = "";

unsigned long tempoAnterior = 0;
bool estadoLed = false;

int buzzerStatus = LOW;

void setup() {
  Serial.begin(9600);
  pinMode(R, OUTPUT);
  pinMode(G, OUTPUT);
  pinMode(B, OUTPUT);
  pinMode(buzzer, OUTPUT);
  lcd.begin(16, 2);

  modoAtual = 0;
  
  Wire.begin(myAdress); // Estabelece o endereço do dispositivo no barramento I2C
  Wire.onReceive(receiveEvent); // Declara a função auxiliar usada para o recebimento dos dados
}

void loop() {

  digitalWrite(buzzer,buzzerStatus);
  
  //Serial.println(intensidadeLuminosa);
  
  if (modoAtual > 7) modoAtual = 0;
  
  if (modoAtual == 0) {
    analogWrite(G, 0);
    analogWrite(B, 0);
    analogWrite(R, 0);
  }

  else if (modoAtual == 1) {
    analogWrite(G, 0);
    analogWrite(B, 0);
    analogWrite(R, intensidadeLuminosa);
  }

  else if (modoAtual == 2) {
    analogWrite(B, 0);
    analogWrite(R, 0);
    if (millis() - tempoAnterior >= 1000) {
      tempoAnterior = millis();
      estadoLed = !estadoLed;

      if (estadoLed == HIGH) {
        analogWrite(G, intensidadeLuminosa);
      } else {
        analogWrite(G, 0);
      }
    }
  }

  else if (modoAtual == 3) {
    analogWrite(B, 0);
    if (millis() - tempoAnterior >= 500) {
      tempoAnterior = millis();
      estadoLed = !estadoLed;

      if (estadoLed == HIGH) {
        analogWrite(G, intensidadeLuminosa);
        analogWrite(R, intensidadeLuminosa);
      } else {
        analogWrite(G, 0);
        analogWrite(R, 0);
      }
    }
  }

  else if (modoAtual == 4) {
    analogWrite(G, 0);
    analogWrite(B, intensidadeLuminosa);
    analogWrite(R, 0);
  }

  else if (modoAtual == 5) {
    analogWrite(G, 0);
    if (millis() - tempoAnterior >= 1000) {
      tempoAnterior = millis();
      estadoLed = !estadoLed;

      if (estadoLed == HIGH) {
        analogWrite(B, intensidadeLuminosa);
        analogWrite(R, intensidadeLuminosa);
      } else {
        analogWrite(B, 0);
        analogWrite(R, 0);
      }
    }
  }

  else if (modoAtual == 6) {
    analogWrite(R, 0);
    if (millis() - tempoAnterior >= 500) {
      tempoAnterior = millis();
      estadoLed = !estadoLed;

      if (estadoLed == HIGH) {
        analogWrite(G, intensidadeLuminosa);
        analogWrite(B, intensidadeLuminosa);
      } else {
        analogWrite(G, 0);
        analogWrite(B, 0);
      }
    }
  }

  else if (modoAtual == 7) {
    analogWrite(G, intensidadeLuminosa);
    analogWrite(B, intensidadeLuminosa);
    analogWrite(R, intensidadeLuminosa);
  }
}

void receiveEvent(int howMany) {
  String received = "";

  while (Wire.available()) {
    received += (char)Wire.read();
  }

  if (received.indexOf("luminosidade") != -1) {
    
    if (received.indexOf("100%") != -1) {
      intensidadeLuminosa = 255;
    } 
    else if (received.indexOf("75%") != -1) {
      intensidadeLuminosa = 192;
    } 
    else if (received.indexOf("50%") != -1) {
      intensidadeLuminosa = 128;
    } 
    else if (received.indexOf("25%") != -1) {
      intensidadeLuminosa = 64;
    } 
    else if (received.indexOf("0%") != -1) {
      intensidadeLuminosa = 0;
    }
}


  else if (received.indexOf("Botao") != -1) {
    modoAtual++;
    Serial.println(modoAtual);
   
  }

  else if (received.indexOf("LigarBuzzer") != -1) {
    buzzerStatus = HIGH;
  }

  else if (received.indexOf("DesligarBuzzer") != -1) {
    buzzerStatus = LOW;
  }

  else{
    mensagem = received;
    lcd.clear();                // Limpa o LCD
    lcd.setCursor(0, 0);        // Move o cursor para o início
    lcd.print(mensagem);        // Exibe a mensagem no LCD
  }
  Serial.println(received);
}