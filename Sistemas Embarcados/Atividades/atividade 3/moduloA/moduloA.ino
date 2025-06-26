// MASTER

#include "Wire.h"
const int buttonPin = 4; 
const int slaveAdress = 8; // Define o endereco do dispositivo slave que pode ser um valor entre 0 a 127
const int PotPin = A1;

boolean buttonState;             
boolean lastButtonState = HIGH;   // Alterado de LOW para HIGH para INPUT_PULLUP

int intensidadeluminosa = 0;
int UltimaIntensidade = 0;
int ValorPot = 0; 
int porcentagemPot = 0;

unsigned long lastDebounceTime = 0;  
unsigned long debounceDelay = 50;   

void setup() {
  Serial.begin(9600);
  Wire.begin(); 
  pinMode(buttonPin, INPUT_PULLUP); 
}

void loop() {

//potenciometro -------------------------------------------------------------------------------------------------------------

  ValorPot = analogRead(PotPin);
  porcentagemPot = map(ValorPot, 0, 1023, 0, 100); 

  if(porcentagemPot < 26){
    intensidadeluminosa = 0;
  }
  else if(porcentagemPot < 51){
    intensidadeluminosa = 25;
  }
  else if(porcentagemPot < 76){
    intensidadeluminosa = 50;
  }
  else if(porcentagemPot < 100){ 
    intensidadeluminosa = 75;
  }
  else {
    intensidadeluminosa = 100;
  }

  if(intensidadeluminosa != UltimaIntensidade){
    UltimaIntensidade = intensidadeluminosa;
    String comando = "luminosidade" + String(intensidadeluminosa) + "%";
    
    Wire.beginTransmission(slaveAdress); 
    Wire.write(comando.c_str()); 
    Wire.endTransmission(); 
  }

// botao ------------------------------------------------------------------------------------------------------------------

  int reading = digitalRead(buttonPin);  
  if (reading != lastButtonState) { 
    lastDebounceTime = millis(); 
  }
  if ((millis() - lastDebounceTime) > debounceDelay) { 
    if (reading != buttonState) {  
       buttonState = reading;
      
      if (buttonState == LOW) {
        String comando = "Botão ON - LUMINOSIDADE" + String(intensidadeluminosa) + "%";
        Serial.println(comando);
        String instrucao = "Botao";
        
        Wire.beginTransmission(slaveAdress); 
        Wire.write(instrucao.c_str()); 
        Wire.endTransmission(); 
      }
    }
  }
  lastButtonState = reading;

//comandos serial --------------------------------------------------------------------------------------------------

  if (Serial.available() > 0) {
    String instrucao = Serial.readStringUntil('\n');
    instrucao.trim(); // Remove espaços extras

    if(instrucao == "LigarBuzzer"){
        Wire.beginTransmission(slaveAdress); 
        Wire.write(instrucao.c_str()); 
        Wire.endTransmission(); 

        Serial.println("Buzzer ON");
    }
    else if(instrucao == "DesligarBuzzer"){
        Wire.beginTransmission(slaveAdress); 
        Wire.write(instrucao.c_str()); 
        Wire.endTransmission();  

        Serial.println("Buzzer OFF");
    }
    else if(instrucao == "DisplayLCD"){
        Serial.println("Digite a mensagem desejada:"); 
        while (Serial.available() == 0); // Aguarda entrada
        String mensagem = Serial.readStringUntil('\n');
      
        Wire.beginTransmission(slaveAdress); 
        Wire.write(mensagem.c_str()); 
        Wire.endTransmission();   

        Serial.println("Mensagem alterada");
    }
  }
}


