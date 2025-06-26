#line 1 "C:/Users/aluno/Documents/tokumoto/exemplodisplaycombotao/displaybotao.c"


void main(){

 unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
#line 9 "C:/Users/aluno/Documents/tokumoto/exemplodisplaycombotao/displaybotao.c"
 unsigned char ucStatus_inc;
 unsigned char ucStatus_dec;
 unsigned int uiContador;
 unsigned int uiValor;

 ADCON1 = 0x0f;

 TRISB.RB0=1;
 TRISB.RB1=1;

 TRISA.RA2=0;
 TRISA.RA3=0;
 TRISA.RA4=0;
 TRISA.RA5=0;

 TRISD = 0;

 ucStatus_inc=0;
 ucStatus_dec=0;
 uiContador=0;

 while(1){



 if((PORTB.RB0==0)&&(ucStatus_inc==0)){

 ucStatus_inc=1;
 uiContador++;

 if(uiContador>9999){
 uiContador=9999;
 }
 }
 if((PORTB.RB0==1)&&(ucStatus_inc==1)){

 ucStatus_inc=0;
 }

 if((PORTB.RB1==0)&&(ucStatus_dec==0)){

 ucStatus_dec=1;
 uiContador--;

 if(uiContador>9999){

 uiContador=9999;
 }
 }
 if((PORTB.RB1==1)&&(ucStatus_dec==1)){

 ucStatus_dec=0;
 }

 uiValor = uiContador;



 PORTD = ucMask[uiValor%10];

 PORTA.RA5 = 1;
 Delay_ms(2);
 PORTA.RA5 = 0;
 uiValor/=10;

 PORTD = ucMask[uiValor%10];
 PORTA.RA4 = 1;
 Delay_ms(2);
 PORTA.RA4 = 0;
 uiValor/=10;

 PORTD = ucMask[uiValor%10];
 PORTA.RA3 = 1;
 Delay_ms(2);
 PORTA.RA3 = 0;
 uiValor/=10;

 PORTD = ucMask[uiValor%10];
 PORTA.RA2 = 1;
 Delay_ms(2);
 PORTA.RA2 = 0;
 }
}
