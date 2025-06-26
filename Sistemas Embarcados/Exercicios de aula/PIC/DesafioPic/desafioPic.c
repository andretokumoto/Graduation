void main(){
                          //  "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"
   unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

   unsigned char ucStatus_inc; // Variavel de travamento do incremento.
   unsigned int  uiContador;   // Variavel de armazenamento do contador.
   unsigned int  uiValor;      // Variavel auxiliar para exibido do contador.

   ADCON1 = 0x0f;       // Configura todos canais como Digital.

   TRISB.RB1=1;         // Entrada do botão
   TRISA.RA3=0;         // Saída para display (dezenas)
   TRISA.RA4=0;         // Saída para display (unidades)
   TRISB.RB5=0;         // Saída para LED
  // TRISC.RC1 = 0;       // Saída para buzzer

   ucStatus_inc=0;
   uiContador=0;

   while(1){

      // Leitura da tecla e incremento da contagem
      if((PORTB.RB1==1)&&(ucStatus_inc==0)){
         ucStatus_inc=1;
         uiContador++;
         if(uiContador>99){         // Máximo 2 dígitos para exibir nos dois displays centrais
            uiContador=99;
         }

         // Controle do LED (RB5): liga se par, desliga se ímpar
         if(uiContador % 2 == 0){
            PORTB.RB5 = 1;
         } else {
            PORTB.RB5 = 0;
         }

         // Buzzer (RC1) toca brevemente se múltiplo de 5
        /*if((uiContador % 5 == 0) && (uiContador>0)){
            PORTC.RC1 = 1;
            Delay_ms(100);
            PORTC.RC1 = 0;
         } */
      }

      if((PORTB.RB1==0)&&(ucStatus_inc==1)){
         ucStatus_inc=0;
      }

      // Atualiza os displays com valor atual
      uiValor = uiContador;

      // Mostra unidade
      PORTD = ucMask[uiValor % 10];
      PORTA.RA4 = 1;
      Delay_ms(2);
      PORTA.RA4 = 0;
      uiValor /= 10;

      // Mostra dezena
      PORTD = ucMask[uiValor % 10];
      PORTA.RA3 = 1;
      Delay_ms(2);
      PORTA.RA3 = 0;
   }
}