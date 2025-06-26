#line 1 "C:/Users/aluno/Documents/tokumoto/comunicacaoPICeArduino/Exemplo3/uartPIC/UARTarduinoPIC.c"
#line 25 "C:/Users/aluno/Documents/tokumoto/comunicacaoPICeArduino/Exemplo3/uartPIC/UARTarduinoPIC.c"
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
unsigned int Control = 0;


void main(){

 ADCON1 = 0x0E;

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);

 UART1_Init(9600);


 while(1){
 if (Control == 0){
 UART1_Write('T');
 lcd_out(1,1,"PIC Send/Receive");
 lcd_out(2,1,"Send = T");
 Delay_ms(50);
 if(UART1_Data_Ready()){
 ucRead = UART1_Read();
 Delay_ms(50);
 if (ucRead == 'S'){
 lcd_out(2,10,"Rec.= ");
 lcd_chr_cp (ucRead);
 }
 }
 }

 if (Control == 1){
 if(UART1_Data_Ready()){
 ucRead = UART1_Read();
 Delay_ms(50);
 if (ucRead == 'M'){
 lcd_out(1,1,"PIC Receive/Send");
 lcd_out(2,1,"Rec.= ");
 lcd_chr_cp (ucRead);
 }
 UART1_Write('P');
 lcd_out(2,9,"Send = P");
 Delay_ms(50);
 }
 }
 }
}
