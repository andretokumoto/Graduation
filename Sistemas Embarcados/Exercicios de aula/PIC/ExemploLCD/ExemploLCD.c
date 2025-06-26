
// CHAVES DE FUNCAO:
//  --------------------- ----------------------
// |GLCD\LCD ( 1) = ON   |DIS1     ( 1) = OFF    |
// |RX       ( 2) = OFF  |DIS2     ( 2) = OFF    |
// |TX       ( 3) = OFF  |DIS3     ( 3) = OFF    |
// |REL1     ( 4) = OFF  |DIS4     ( 4) = OFF    |
// |REL2     ( 5) = OFF  |INFR     ( 5) = OFF   |
// |SCK      ( 6) = OFF  |RESIS    ( 6) = OFF   |
// |SDA      ( 7) = OFF  |TEMP     ( 7) = OFF   |
// |RTC      ( 8) = OFF  |VENT     ( 8) = OFF   |
// |LED1     ( 9) = OFF  |AN0      ( 9) = OFF    |
// |LED2     (10) = OFF  |AN1      (10) = OFF   |
//  --------------------- ----------------------

// --- Ligacoes entre PIC e LCD ---
sbit LCD_RS at RE2_bit;   // PINO 2 DO PORTD LIGADO AO RS DO DISPLAY
sbit LCD_EN at RE1_bit;   // PINO 3 DO PORTD LIGADO AO EN DO DISPLAY
sbit LCD_D7 at RD7_bit;  // PINO 7 DO PORTD LIGADO AO D7 DO DISPLAY
sbit LCD_D6 at RD6_bit;  // PINO 6 DO PORTD LIGADO AO D6 DO DISPLAY
sbit LCD_D5 at RD5_bit;  // PINO 5 DO PORTD LIGADO AO D5 DO DISPLAY
sbit LCD_D4 at RD4_bit;  // PINO 4 DO PORTD LIGADO AO D4 DO DISPLAY

// Selecionando direcao de fluxo de dados dos pinos utilizados para a comunicacao com display LCD
sbit LCD_RS_Direction at TRISE2_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 2 DO PORTD
sbit LCD_EN_Direction at TRISE1_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 3 DO PORTD
sbit LCD_D7_Direction at TRISD7_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 7 DO PORTD
sbit LCD_D6_Direction at TRISD6_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 6 DO PORTD
sbit LCD_D5_Direction at TRISD5_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 5 DO PORTD
sbit LCD_D4_Direction at TRISD4_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 4 DO PORTD

// --- Prototipo das Funcoes Auxiliares ---
void helloWorldPIC18();                        //Declara a funcao da mensagem no LCD, caractere por caractere

// --- Funcao Principal ---
void main()
{
     ADCON1  = 0x0F;                           //Configura os pinos como digitais

     Lcd_Init();                               //Inicializa modulo LCD
     Lcd_Cmd(_LCD_CURSOR_OFF);                 //Apaga cursor
     Lcd_Cmd(_LCD_CLEAR);                      //Limpa display

     while(1)
     {
        // helloWorldPIC18();			// posteriormente, comente essa função e
         lcd_out(1,3,"EU SOU O");    // descomente essa funcao
         lcd_out(2,4,"BATMAN");     // descomente essa funcao
     }
}
// --- Desenvolvimento das Funcoes Auxiliares ---
void helloWorldPIC18()    // Comente essa funcao
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