const int sinalVermelho = 13;
const int sinalAmarelo = 10;
const int sinalVerde = 8;


void setup() {
  // put your setup code here, to run once:
  pinMode(sinalVermelho, OUTPUT);
  pinMode(sinalAmarelo, OUTPUT);
  pinMode(sinalVerde, OUTPUT);

}

void loop() {
  // put your main code here, to run repeatedly:
  //sinal vermelho ativo
  digitalWrite(sinalVermelho,HIGH);
  digitalWrite(sinalAmarelo,LOW);
  digitalWrite(sinalVerde,LOW);
  delay(5000);//5 segundos

    //sinal Amarelo ativo
  digitalWrite(sinalVermelho,LOW);
  digitalWrite(sinalAmarelo,HIGH);
  digitalWrite(sinalVerde,LOW);
  delay(2000);//5 segundos

      //sinal Verde ativo
  digitalWrite(sinalVermelho,LOW);
  digitalWrite(sinalAmarelo,LOW);
  digitalWrite(sinalVerde,HIGH);
  delay(3000);//5 segundos
}
