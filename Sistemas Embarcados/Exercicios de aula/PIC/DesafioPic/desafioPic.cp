#line 1 "C:/Users/aluno/Documents/tokumoto/DesafioPic/desafioPic.c"
void main(){

 unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

 unsigned char ucStatus_inc;
 unsigned int uiContador;
 unsigned int uiValor;

 ADCON1 = 0x0f;

 TRISB.RB1=1;
 TRISA.RA3=0;
 TRISA.RA4=0;
 TRISB.RB5=0;


 ucStatus_inc=0;
 uiContador=0;

 while(1){


 if((PORTB.RB1==1)&&(ucStatus_inc==0)){
 ucStatus_inc=1;
 uiContador++;
 if(uiContador>99){
 uiContador=99;
 }


 if(uiContador % 2 == 0){
 PORTB.RB5 = 1;
 } else {
 PORTB.RB5 = 0;
 }
#line 43 "C:/Users/aluno/Documents/tokumoto/DesafioPic/desafioPic.c"
 }

 if((PORTB.RB1==0)&&(ucStatus_inc==1)){
 ucStatus_inc=0;
 }


 uiValor = uiContador;


 PORTD = ucMask[uiValor % 10];
 PORTA.RA4 = 1;
 Delay_ms(2);
 PORTA.RA4 = 0;
 uiValor /= 10;


 PORTD = ucMask[uiValor % 10];
 PORTA.RA3 = 1;
 Delay_ms(2);
 PORTA.RA3 = 0;
 }
}
