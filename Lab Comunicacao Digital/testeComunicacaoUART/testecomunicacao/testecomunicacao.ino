#include <SoftwareSerial.h>

// --- Comunicacao com a FPGA ---
SoftwareSerial fpgaserial(4, 8);

const int pinoEncoder = 2;
const int pinoPWM = 7;
const int pinoBotao = 5;

const int ranhuras = 20;
volatile unsigned int contadorPulsos = 0;

double velocidadeDesejada = 2200.0;
double velocidadeAtual = 0.0;
double erroAtual = 0.0;
double erroAnterior = 0.0;
double uk = 0.0;
double uk1 = 0.0;
double kp = 0.05;
double ki = 0.008;
unsigned long tempoAmostragem = 100;
unsigned long tempoAnterior = 0;

// --- Controle de Tempo para UART (500 Hz = 2000 microssegundos) ---
unsigned long tempoAnteriorUart = 0;
const unsigned long periodoUartMicros = 2000; 

bool motorAtivo = false;
bool estadoBotaoAnterior = HIGH;

void contarPulso() {
  contadorPulsos++;
}

void setup() {
  Serial.begin(9600);
  // Dica: Se possivel, aumente para 19200 ou 38400 na FPGA e aqui para evitar gargalo!
  fpgaserial.begin(9600); 
  
  pinMode(pinoEncoder, INPUT_PULLUP);
  pinMode(pinoPWM, OUTPUT);
  pinMode(pinoBotao, INPUT_PULLUP); 
  attachInterrupt(digitalPinToInterrupt(pinoEncoder), contarPulso, RISING);
}

void loop() {
  
  // --- Botao de Start/Stop ---
  bool estadoBotao = digitalRead(pinoBotao);
  if (estadoBotao == LOW && estadoBotaoAnterior == HIGH) {
    delay(20); // debounce
    if (digitalRead(pinoBotao) == LOW) {
      motorAtivo = !motorAtivo;

      if (!motorAtivo) {
        analogWrite(pinoPWM, 0);
        uk = 0.0;
        uk1 = 0.0;
        erroAtual = 0.0;
        erroAnterior = 0.0;
        noInterrupts();
        contadorPulsos = 0;
        interrupts();
        Serial.println("status:PAUSADO");
      } else {
        Serial.println("status:RODANDO");
      }
    }
  }
  estadoBotaoAnterior = estadoBotao;

  if (!motorAtivo) return;

  unsigned long tempoAtualMicros = micros();
  unsigned long tempoAtualMillis = millis();

  // =========================================================================
  // 1. ENVIO E RECEPÇÃO DA UART A 500 Hz (A cada 2000 microssegundos)
  // =========================================================================
  if (tempoAtualMicros - tempoAnteriorUart >= periodoUartMicros) {
    tempoAnteriorUart = tempoAtualMicros;

    // Envia o dado da velocidade atual (calculada no bloco de 100ms)
    byte dadoParaEnviar = (byte)(velocidadeAtual / 100.0);
    fpgaserial.write(dadoParaEnviar);

    // Timeout reduzido drasticamente para nao travar o loop de 500Hz!
    // 1 ms de timeout ja e suficiente para o retorno do byte
    unsigned long inicioEspera = millis();
    const unsigned long timeoutFPGA = 1; 
    while (fpgaserial.available() == 0) {
      if (millis() - inicioEspera > timeoutFPGA) {
        break; 
      }
    }

    if (fpgaserial.available() > 0) {
      int8_t erroRecebido = (int8_t)fpgaserial.read();
      erroAtual = (double)erroRecebido * 100.0;
    }
  }

  // =========================================================================
  // 2. CONTROLE DO MOTOR E CALCULO PI (A cada 100 ms)
  // =========================================================================
  if (tempoAtualMillis - tempoAnterior >= tempoAmostragem) {

    noInterrupts();
    unsigned int pulsos = contadorPulsos;
    contadorPulsos = 0;
    interrupts();

    // Atualiza a velocidade atual baseada nos pulsos do encoder
    velocidadeAtual = (pulsos / (double)ranhuras) * (60000.0 / tempoAmostragem);

    double T = tempoAmostragem / 1000.0;

    // O erroAtual usado aqui foi o ultimo atualizado pela UART de 500Hz
    uk = uk1 + kp * (erroAtual - erroAnterior) + ki * T * erroAtual;

    if (uk > 255.0) uk = 255.0;
    if (uk < 0.0)   uk = 0.0;

    analogWrite(pinoPWM, (int)uk);

    uk1 = uk;
    erroAnterior = erroAtual;
    tempoAnterior = tempoAtualMillis;

    // Monitoramento serial de debug
    Serial.print("VelocidadeAtual:"); Serial.print(velocidadeAtual);
    Serial.print(",");
    Serial.print("erroFPGA:"); Serial.print(erroAtual);
    Serial.print(",");
    Serial.print("PWM:"); Serial.println(uk);
  }
}