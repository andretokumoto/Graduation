// ═══════════════════════════════════════════════════
//  Controlador PI - Motor DC com Encoder
//  Pinos 4 e 11 reservados
// ═══════════════════════════════════════════════════

// ── Encoder ─────────────────────────────────────────
volatile long contagem      = 0;
long          ultimaContagem = 0;
const int     pinA = 2;   // interrupção
const int     pinB = 3;   // direção
const int     PPR  = 20;  // pulsos por revolução — ajuste

// ── Motor PWM ───────────────────────────────────────
const int pinPWM = 9;     // pino PWM do motor
                          // pinos 4 e 11 reservados

// ── Controlador PI ──────────────────────────────────
float integral     = 0.0;
float Kp           = 1.0;    // ajuste
float Ki           = 0.1;    // ajuste
const float dt     = 0.01;   // 10 ms
const int   SETPOINT = 50;   // velocidade desejada em pulsos/10ms

float controladorPI(float erro) {
  integral     += erro * dt;
  integral      = constrain(integral, -255.0, 255.0); // anti-windup
  float saida   = Kp * erro + Ki * integral;
  return constrain(saida, 0, 255);
}

// ── Interrupção do Encoder ──────────────────────────
void lerEncoder() {
  if (digitalRead(pinB) == HIGH) contagem++;
  else                           contagem--;
}

// ── Setup ───────────────────────────────────────────
void setup() {
  Serial.begin(115200);
  pinMode(pinPWM, OUTPUT);
  pinMode(4,  INPUT);   // reservado
  pinMode(11, INPUT);   // reservado

  attachInterrupt(digitalPinToInterrupt(pinA), lerEncoder, RISING);

  // Cabeçalho do Serial Plotter
  // formato: "Label1,Label2,Label3"
  Serial.println("Setpoint,Velocidade,PWM,Erro");
}

// ── Loop ────────────────────────────────────────────
void loop() {
  static unsigned long ultimoTempo = 0;

  unsigned long agora = millis();
  if (agora - ultimoTempo >= 10) {   // janela de 10 ms
    ultimoTempo = agora;

    // 1. Calcula velocidade (pulsos / 10ms)
    long delta       = contagem - ultimaContagem;
    ultimaContagem   = contagem;
    float velocidade = (float) delta;

    // 2. Calcula erro
    float erro = (float)SETPOINT - velocidade;

    // 3. Executa PI
    float saida  = controladorPI(erro);
    uint8_t pwm  = (uint8_t) saida;
    analogWrite(pinPWM, pwm);

    // 4. Envia dados ao Serial Plotter
    // formato CSV: valor1,valor2,valor3,valor4
    Serial.print(SETPOINT);
    Serial.print(",");
    Serial.print(velocidade, 1);
    Serial.print(",");
    Serial.print(map(pwm, 0, 255, 0, SETPOINT * 2)); // escala PWM junto ao gráfico
    Serial.print(",");
    Serial.println(erro, 1);
  }
}