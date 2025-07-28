unsigned long Ts = 80;

const float LSB = 0.0048828125;
unsigned long tempo = 0;


float r;
float kp = 1;
float u;
float e;
float y;

float ki = 2;
float integral = 0;


void setup() {

 pinMode(3, OUTPUT); 
 pinMode(14, INPUT);
 pinMode(7, INPUT);
 
 TCCR3B = TCCR3B & B11111000 | B00000001;  /*// for PWM frequency of 31372.55 Hz*/
 Serial.begin(2000000);

}

void loop() {
    if(millis()-tempo > Ts){

        int referencia = analogRead(14);
        r = referencia * LSB;

        int medido = analogRead(7);
        y = medido * LSB;

        e = r - y;
        integral = integral + e;

        u = e*kp + ki*integral;
       



        int saidaPWM = u*51;
        if(saidaPWM < 0 ) saidaPWM = 0;
         
        Serial.println(e);
      
        analogWrite(3,saidaPWM);

   
        tempo = millis();
    }
}
