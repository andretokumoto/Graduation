// --- Ligacoes entre PIC e LCD ---
sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

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
unsigned int pot1 = 0;
unsigned int pot1_percent = 0;
char pot1_string[7];

unsigned char ucHora;
unsigned char ucMinuto;

void Grava_RTC();
void Leitura_RTC();

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
         else if(ucRead == '3'){
             statusVent = 1;
             Delay_ms(100);
         }
         else if(ucRead == '4'){ // <-- Comando "Hora"
             Leitura_RTC();       // Lê hora e minuto do RTC

             I2C1_Init(100000);
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
         uiValorAD = pot1 >> 2;             // 0-1023 ? 0–255
         PWM1_Set_Duty(uiValorAD);
         Delay_10us();

         pot1_percent = ((long)pot1 * 100) / 1023;
         IntToStr(pot1_percent, pot1_string);
         Ltrim(pot1_string);

         Lcd_Out(1,1,"                ");     // Limpa a linha
         Lcd_Out(1,1,"V = ");
         Lcd_Out(1,5, pot1_string);
         Lcd_Out(1,8,"% Vmax");
      }
   }
}

void Grava_RTC(){
   I2C1_Init(100000);
   I2C1_Start();
   I2C1_Wr(0xD0);
   I2C1_Wr(0);
   I2C1_Wr(0x00);
   I2C1_Wr(0x00);
   I2C1_Wr(0x00);
   I2C1_Wr(0x05);
   I2C1_Wr(0x16);
   I2C1_Wr(0x05);
   I2C1_Wr(0x19);
   I2C1_Stop();
}

void Leitura_RTC() {
   I2C1_Start();
   I2C1_Wr(0xD0);
   I2C1_Wr(0);
   I2C1_Repeated_Start();
   I2C1_Wr(0xD1);
   I2C1_Rd(1);             // Ignora segundos
   ucMinuto = I2C1_Rd(1);  // Minuto
   ucHora = I2C1_Rd(0);    // Hora
   I2C1_Stop();
}