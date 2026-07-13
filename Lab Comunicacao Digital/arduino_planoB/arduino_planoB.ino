#include <SoftwareSerial.h>

// RX no 8, TX no 9
SoftwareSerial fpgaserial(8, 9);

const int pinoEncoder = 2;
const int pinoPWM = 7;

double velocidadeAtual = 0.0;
double erroAtual = 0.0;
double erroAnterior = 0.0;
double uk = 0.0;
double uk1 = 0.0;
double kp = 0.05;
double ki = 0.008;
unsigned long tempoAmostragem = 300;
unsigned long tempoAnterior = 0;

const int ranhuras = 20;
unsigned int contadorPulsos = 0;
int estadoAnteriorEncoder = LOW;
int valorEntrada = 0; 


void setup() {
  Serial.begin(9600);
  fpgaserial.begin(9600);
 
  pinMode(pinoEncoder, INPUT_PULLUP);
  pinMode(pinoPWM, OUTPUT);
  

  estadoAnteriorEncoder = digitalRead(pinoEncoder);
}

void loop() {
 

  int estadoEncoder = digitalRead(pinoEncoder);
  if (estadoEncoder == HIGH && estadoAnteriorEncoder == LOW) {
    contadorPulsos++;
  }
  estadoAnteriorEncoder = estadoEncoder;
  unsigned long tempoAtual = millis();
  if (tempoAtual - tempoAnterior >= tempoAmostragem) {

    unsigned int pulsos = contadorPulsos;
    contadorPulsos = 0;

    velocidadeAtual = 10*(pulsos / (double)ranhuras) * (60000.0 / tempoAmostragem);

    double T = tempoAmostragem / 1000.0;
    uk = uk1 + kp * (erroAtual - erroAnterior) + ki * T * erroAtual;
    if (uk > 255.0) uk = 255.0;
    if (uk < 0.0) uk = 0.0;

    analogWrite(pinoPWM, (int)uk);

    uk1 = uk;
    erroAnterior = erroAtual;
    tempoAnterior = tempoAtual; 

    Serial.print("Velocidade Simulada:");
    Serial.print(valorEntrada);
    Serial.print(",");
    Serial.print("Velocidade real:");
    Serial.print(velocidadeAtual);
    Serial.print(",");
    Serial.print("erroFPGA:");
    Serial.print(erroAtual);
    Serial.print(",");
    Serial.print("PWM:");
    Serial.println(uk);
  } 

  //receptor
  if (Serial.available() > 0) {
    
    valorEntrada = Serial.parseInt();

    byte dadoParaEnviar = (byte)(valorEntrada / 100);
    

    fpgaserial.write(dadoParaEnviar);

    Serial.print("Velocidade Simulada: ");
    Serial.print(valorEntrada);
    Serial.print(" | Binario: ");
    Serial.println(dadoParaEnviar, BIN);
    while (Serial.available() > 0) Serial.read();
  }

  //transmissor
  if (fpgaserial.available() > 0) {
    int8_t dadoRecebido = (int8_t)fpgaserial.read();
    erroAtual = (int)dadoRecebido * 100; 
  }
}