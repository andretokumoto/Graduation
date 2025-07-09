void main() {

   Lcd_Init();
   Lcd_Cmd(_LCD_CURSOR_OFF);
   Lcd_Cmd(_LCD_CLEAR);

   UART1_Init(9600);
   I2C1_Init(100000);  

   PORTA = 255;
   TRISA = 255;

   ADCON0 = 0b00000001;
   ADCON2 = 0x0E;

   PWM1_Init(5000);
   PWM1_Start();

   TRISA0_bit = 1;

   ADCON1 = 0b00001110;
   ADC_Init();
   CMCON = 0b00000111;

   while(1){
      if(UART1_Data_Ready()){
         ucRead = UART1_Read();
         Delay_ms(50);

         if(ucRead == '0'){
             Lcd_Out(1,1,"V = 0% Vmax   ");
             potencia = 0;
             statusVent = 0;
             Delay_ms(100);
         }
         else if(ucRead == '1'){
             Lcd_Out(1,1,"V = 50% Vmax ");
             potencia = 127;
             statusVent = 0;
             Delay_ms(100);
         }
         else if(ucRead == '2'){
             Lcd_Out(1,1,"V = 100% Vmax");
             potencia = 255;
             statusVent = 0;
             Delay_ms(100);
         }
         else if(ucRead == '3'){
             statusVent = 1;
             Delay_ms(100);
         }
         else if(ucRead == '4'){ // Comando "Hora"
             Leitura_RTC();       // Lê hora e minuto do RTC

             I2C1_Start();
             I2C1_Wr(0x58);       // Endereço do Arduino (escrita)
             I2C1_Wr(ucHora);     // Envia hora
             I2C1_Wr(ucMinuto);   // Envia minuto
             I2C1_Stop();
         }
      }

      if(statusVent == 0){
         PWM1_Set_Duty(potencia);
         Delay_10us();
      }
      else {
         pot1 = ADC_Read(0);
         uiValorAD = pot1 >> 2;
         PWM1_Set_Duty(uiValorAD);
         Delay_10us();

         pot1_percent = ((long)pot1 * 100) / 1023;
         IntToStr(pot1_percent, pot1_string);
         Ltrim(pot1_string);

         Lcd_Out(1,1,"                ");
         Lcd_Out(1,1,"V = ");
         Lcd_Out(1,5, pot1_string);
         Lcd_Out(1,8,"% Vmax");
      }
   }
}
