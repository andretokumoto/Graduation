#line 1 "C:/Users/aluno/Documents/tokumoto/ExemploLCD/ExemploLCD.c"
#line 17 "C:/Users/aluno/Documents/tokumoto/ExemploLCD/ExemploLCD.c"
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


void helloWorldPIC18();


void main()
{
 ADCON1 = 0x0F;

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);

 while(1)
 {

 lcd_out(1,3,"EU SOU O");
 lcd_out(2,4,"BATMAN");
 }
}

void helloWorldPIC18()
{
 lcd_chr(1,3,'H');
 lcd_chr_cp ('e');
 lcd_chr_cp ('l');
 lcd_chr_cp ('l');
 lcd_chr_cp ('o');
 lcd_chr_cp (' ');
 lcd_chr_cp ('W');
 lcd_chr_cp ('o');
 lcd_chr_cp ('r');
 lcd_chr_cp ('l');
 lcd_chr_cp ('d');

 lcd_chr(2,2,'P');
 lcd_chr_cp ('I');
 lcd_chr_cp ('C');
 lcd_chr_cp ('1');
 lcd_chr_cp ('8');
 lcd_chr_cp ('F');
 lcd_chr_cp ('4');
 lcd_chr_cp ('5');
 lcd_chr_cp ('2');
 lcd_chr_cp ('0');
}
