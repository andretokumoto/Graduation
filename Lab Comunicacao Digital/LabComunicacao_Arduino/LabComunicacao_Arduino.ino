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

bool motorAtivo = false;
bool estadoBotaoAnterior = HIGH;

void contarPulso() {
  contadorPulsos++;
}

void setup() {
  Serial.begin(9600);
  pinMode(pinoEncoder, INPUT_PULLUP);
  pinMode(pinoPWM, OUTPUT);
  pinMode(pinoBotao, INPUT_PULLUP);  // pulldown sem resistor = INPUT_PULLUP com lógica invertida
  attachInterrupt(digitalPinToInterrupt(pinoEncoder), contarPulso, RISING);
}

void loop() {

  // leitura do botão com debounce simples
  bool estadoBotao = digitalRead(pinoBotao);
  if (estadoBotao == LOW && estadoBotaoAnterior == HIGH) {
    delay(20); // debounce
    if (digitalRead(pinoBotao) == LOW) {
      motorAtivo = !motorAtivo;

      if (!motorAtivo) {
        // zera tudo ao pausar
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

  unsigned long tempoAtual = millis();
  if (tempoAtual - tempoAnterior >= tempoAmostragem) {

    noInterrupts();
    unsigned int pulsos = contadorPulsos;
    contadorPulsos = 0;
    interrupts();

    velocidadeAtual = (pulsos / (double)ranhuras) * (60000.0 / tempoAmostragem);
    erroAtual = velocidadeDesejada - velocidadeAtual;
    double T = tempoAmostragem / 1000.0;

    uk = uk1 + kp * (erroAtual - erroAnterior) + ki * T * erroAtual;

    if (uk > 255.0) uk = 255.0;
    if (uk < 0.0)   uk = 0.0;

    analogWrite(pinoPWM, (int)uk);

    uk1 = uk;
    erroAnterior = erroAtual;
    tempoAnterior = tempoAtual;

    Serial.print("velocidadeDesejada:"); Serial.print(velocidadeDesejada);
    Serial.print(",");
    Serial.print("VelocidadeAtual:"); Serial.print(velocidadeAtual);
    Serial.print(",");
    Serial.print("PWM:"); Serial.println(uk);
  }
}