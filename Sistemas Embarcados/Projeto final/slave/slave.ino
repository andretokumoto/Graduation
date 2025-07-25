//trabalho final de sistemas embarcados desenvolvido por André Filipe Siqueira Tokumoto


const int botaoPorta = 2;
const int sensorPresenca = 4;
const int ledAlarme = 12;
const int ledPedeSenha = 13;
const int buzzerAlarme = 11;
const int ledPorta = 7;


unsigned long lastDebounce = 0;
unsigned long debounceDelay = 50;
int statusBotao = HIGH;      
int lastBotaoStatus = LOW;


unsigned long previousMilli = 0;
unsigned long tempoAtivacao = 0; 
const long intervalo = 15000;
const long tempoEsperaAtivacao = 5000; 

int alarmeDisparado = LOW;
int aguardandoAtivacao = 0;


int alarmeAtivo = HIGH;
int presencaDetectada = LOW;
static String senhaEntrada = "";
static String senhaSalva = "1234#";
byte ByteRecebido;
int portaberta = HIGH;
int controleBitDisparado = LOW;

int brilho = 0;
int incremento = 5;
unsigned long ultimoTempoFade = 0;
unsigned long intervaloFade = 10;
int desarme = LOW;

void setup() {
  pinMode(botaoPorta, INPUT_PULLUP);
  pinMode(sensorPresenca, INPUT);
  pinMode(ledAlarme, OUTPUT);
  pinMode(ledPedeSenha, OUTPUT);
  pinMode(ledPorta, OUTPUT);
  pinMode(buzzerAlarme, OUTPUT);
  Serial.begin(9600);
  Serial2.begin(9600);
}

void loop() {
  digitalWrite(ledPorta, portaberta);

  if (alarmeDisparado == LOW) {
    digitalWrite(ledAlarme, alarmeAtivo);
  }

  int estadoBotao = digitalRead(botaoPorta);

  if(desarme == HIGH){

    alarmeAtivo == LOW;
    alarmeDisparado = LOW;
    presencaDetectada = LOW;

    desarme = LOW;
  }

  if (estadoBotao != lastBotaoStatus) {
    lastDebounce = millis();
  }

  if ((millis() - lastDebounce) > debounceDelay) {
    if (estadoBotao != statusBotao) {
      statusBotao = estadoBotao;
      if (statusBotao == LOW) {
        portaberta = !portaberta;
        if (alarmeAtivo == HIGH && portaberta == LOW) {
          presencaDetectada = HIGH;
          previousMilli = millis(); 
        }
      }
    }
  }
  lastBotaoStatus = estadoBotao;

  int DetectaPresenca = digitalRead(sensorPresenca);
  if (DetectaPresenca == HIGH) {
    if (alarmeAtivo == HIGH) {
      presencaDetectada = HIGH;
      previousMilli = millis(); 
    }
  }

  if (presencaDetectada == HIGH && alarmeDisparado == LOW) {
    digitalWrite(ledPedeSenha, HIGH);
    unsigned long currentMilli = millis();

    if (currentMilli - previousMilli <= intervalo) {
      if (Serial.available()) {
        senhaEntrada = Serial.readStringUntil('\n');
        senhaEntrada.trim();
        delay(50);

        if (senhaEntrada == senhaSalva) {
          alarmeAtivo = LOW;
          Serial2.write(4);
          presencaDetectada = LOW;
          senhaEntrada = "";
          digitalWrite(ledPedeSenha, LOW);
        } 
        else {
          senhaEntrada = "";
        }
      }
    } else {
      alarmeDisparado = HIGH;
      digitalWrite(ledPedeSenha, LOW);
    }
  }


  if (alarmeAtivo == LOW) {
    if (Serial.available()) {
      senhaEntrada = Serial.readStringUntil('\n');
      senhaEntrada.trim();
      delay(50);

      if (senhaEntrada == senhaSalva) {
        tempoAtivacao = millis();
        aguardandoAtivacao = 1;
        senhaEntrada = "";
      } else {
        senhaEntrada = "";
      }
    }
  }


  if (aguardandoAtivacao && (millis() - tempoAtivacao >= tempoEsperaAtivacao)) {
    alarmeAtivo = HIGH;
    presencaDetectada = LOW;
    aguardandoAtivacao = 0;
    Serial2.write(3);

    if (portaberta == LOW) alarmeDisparado = HIGH;
  }


  if (alarmeDisparado == HIGH) {
    if (controleBitDisparado == LOW) {
      Serial2.write(2);
      controleBitDisparado = HIGH;
    }
    digitalWrite(buzzerAlarme, HIGH);  
  } else {
    digitalWrite(buzzerAlarme, LOW);   
    controleBitDisparado = LOW;
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


  if (Serial2.available()) {
 
    ByteRecebido = Serial2.read();
    

    if (ByteRecebido == 0) { 

      desarme = HIGH;
      alarmeDisparado = LOW;
      alarmeAtivo = LOW;
      aguardandoAtivacao = 0;
      digitalWrite(buzzerAlarme, LOW);
      controleBitDisparado = LOW;

      Serial.print("alarme desarmado");
      Serial.println(alarmeDisparado);

    } 
    else if (ByteRecebido == 1) {

      Serial.print("alarme armado");

      tempoAtivacao = millis();
      aguardandoAtivacao = 1;

    }
     else if (ByteRecebido == 2) {
      alarmeDisparado = HIGH;
    }
  }
}

