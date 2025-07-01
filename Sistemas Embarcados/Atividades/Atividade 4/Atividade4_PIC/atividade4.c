void main(){
                          //  "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"
   unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

   unsigned char ucStatus_inc; // Variavel de travamento do incremento.
   unsigned int  uiContador = 0;   // Variavel de armazenamento do contador.
   unsigned int  uiValor = 0;      // Variavel auxiliar para exibido do contador.

   ADCON1 = 0x0f;       // Configura todos canais como Digital.

   TRISB.RB1 = 1;
   TRISA.RA3 = 0;
   TRISA.RA4 = 0;
   TRISB.RB5 = 0;
   TRISD = 0x00;
   PORTB.RB1 = 0;

   UART1_Init(9600);
   Delay_ms(100);

   ucStatus_inc = 1;
   uiContador = 0;


   
   while(1){

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

      if((PORTB.RB1 == 1) && (ucStatus_inc == 0)){
         ucStatus_inc = 1;
         uiContador++;
         if(uiContador > 99){
            uiContador = 99;
         }

         if(uiContador % 2 == 0){
            PORTB.RB5 = 1;
         } else {
            PORTB.RB5 = 0;
         }

         UART1_Write(uiContador);
         UART1_Write(PORTB.RB5);
      }

      if((PORTB.RB1 == 0) && (ucStatus_inc == 1)){
         ucStatus_inc = 0;
      }

   }
}

