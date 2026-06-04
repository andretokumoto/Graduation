//#include <SoftwareSerial.h>

const int pinoPotenciometro = A3;
const int pinoPWM = 7;
//SoftwareSerial fpgaserial(4, 11); 

//leitura da velocidade
int ValorPotenciometro = 0;
int velocidade = 0;

//variaveis do controlador
double velocidadeDesejada = 1250.0;//rpm
double velocidadeAtual = 0.0;
double erroAtual = 0.0;
double erroAnterior = 0.0;
double uk = 0.0; // u[k]
double uk1 = 0.0; // u[k-1]
double kp = 0.1; 
double ki = 0.05;
unsigned long tempoAmostragem = 50; // T
unsigned long tempoAnterior = 0;

void setup() {
  Serial.begin(9600);
  //fpgaserial.begin(9600);  
  pinMode(pinoPotenciometro, INPUT);
  pinMode(pinoPWM, OUTPUT);
}

void loop() {

    
    unsigned long tempoAtual = millis();
    
    if (tempoAtual - tempoAnterior >= tempoAmostragem) {
      
      ValorPotenciometro = analogRead(pinoPotenciometro);
      velocidadeAtual = map(ValorPotenciometro, 0, 1023, 0, 2500);//rpm maximo desse motor a 12v eh 25000
      
      //erro no arduino vai ser no fpga depois
      erroAtual = velocidadeDesejada - velocidadeAtual;
      
      double T = tempoAmostragem / 1000.0;//conversao de millisegundos para segundos
      
      //funç~o transferencia
      uk = uk1 + kp * (erroAtual - erroAnterior) + ki*T*erroAtual;
      
      //pwm sempre entre 0 e 255
      if (uk > 255.0) uk = 255.0;
      if (uk < 0.0)   uk = 0.0;
      
      //aplica PWM
      analogWrite(pinoPWM, (int)uk);
      
      //atualiza sinais
      uk1 = uk;
      erroAnterior = erroAtual;
      tempoAnterior = tempoAtual;
      
      // monitor de controle
      Serial.print("velocidadeDesejada:"); Serial.print(velocidadeDesejada);
      Serial.print(",");
      Serial.print("VelocidadeAtual:"); Serial.print(velocidadeAtual);
      Serial.print(",");
      Serial.print("PWM:"); Serial.println(uk);
    }
    
  
}
