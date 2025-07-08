// --- Ligacoes entre PIC e LCD ---
sbit LCD_RS at RE2_bit;   // PINO 2 DO PORTE INTERLIGADO AO RS DO DISPLAY
sbit LCD_EN at RE1_bit;   // PINO 1 DO PORTE INTERLIGADO AO EN DO DISPLAY
sbit LCD_D7 at RD7_bit;   // PINO 7 DO PORTD INTERLIGADO AO D7 DO DISPLAY
sbit LCD_D6 at RD6_bit;   // PINO 6 DO PORTD INTERLIGADO AO D6 DO DISPLAY
sbit LCD_D5 at RD5_bit;   // PINO 5 DO PORTD INTERLIGADO AO D5 DO DISPLAY
sbit LCD_D4 at RD4_bit;   // PINO 4 DO PORTD INTERLIGADO AO D4 DO DISPLAY

// Selecionando direcao de fluxo de dados dos pinos utilizados para a comunicacao com display LCD
sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

char ucRead;
int potencia = 0;
int statusVent = 0;

unsigned int uiValorAD;
unsigned int pot1 = 0;             // Valor analógico lido de AN0
unsigned int pot1_percent = 0;     // Porcentagem calculada de pot1
char pot1_string[7];               // String para exibir valor no LCD

void main() {

   Lcd_Init();
   Lcd_Cmd(_LCD_CURSOR_OFF);
   Lcd_Cmd(_LCD_CLEAR);

   UART1_Init(9600);

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
            else {
                statusVent = 1;
                Delay_ms(100);
            }
      }

      if(statusVent == 0){
          PWM1_Set_Duty(potencia);
          Delay_10us();
      }
      else {

            uiValorAD = ADC_Read(0);
            pot1 = uiValorAD;
            uiValorAD *= 0.24;
            PWM1_Set_Duty(uiValorAD);
            Delay_10us();

                                // Lê valor bruto (0–1023)
            pot1_percent = (pot1 * 100) / 1023;           // Converte para porcentagem (0–100)

            IntToStr(pot1_percent, pot1_string);
            //Ltrim(pot1_string);

	    Lcd_Out(1,1,"V = ");
            Lcd_Out(1,5, pot1_string);
            Lcd_Out(1,8,"% Vmax   ");



      }

   }
}
