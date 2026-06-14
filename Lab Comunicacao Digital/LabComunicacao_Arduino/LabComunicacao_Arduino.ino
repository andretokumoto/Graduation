const int pinoEncoder = 2;
const int pinoPWM = 7;

const int ranhuras = 20;
volatile unsigned int contadorPulsos = 0;

double velocidadeDesejada = 2000.0;
double velocidadeAtual = 0.0;
double erroAtual = 0.0;
double erroAnterior = 0.0;
double uk = 0.0;
double uk1 = 0.0;
double kp = 0.05;
double ki = 0.008;
unsigned long tempoAmostragem = 100;
unsigned long tempoAnterior = 0;

void contarPulso() {
  contadorPulsos++;
}

void setup() {
  Serial.begin(9600);
  pinMode(pinoEncoder, INPUT_PULLUP);
  pinMode(pinoPWM, OUTPUT);
  attachInterrupt(digitalPinToInterrupt(pinoEncoder), contarPulso, RISING);
}

void loop() {
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