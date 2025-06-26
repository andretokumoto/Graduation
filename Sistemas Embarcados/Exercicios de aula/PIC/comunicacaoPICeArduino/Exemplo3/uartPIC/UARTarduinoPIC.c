//********************************************************************************
//     PROGRAMA EXEMPLO: Comunicacao USART entre PIC 18F e o Arduino.
// OBJETIVO: Aprender a utilizar a comunicacao serial assincrona do PIC18F4520.

//                       MICROCONTROLADOR: PIC18F4520.
//         http://ww1.microchip.com/downloads/en/DeviceDoc/39631E.pdf

//********************************************************************************

// CHAVES DE FUNCAO:
//  --------CHAVE1--------  --------CHAVE2---------
// |GLCD\LCD ( 1) = ON    |DIS1    ( 1) = OFF   |
// |RX       ( 2) = OFF   |DIS2    ( 2) = OFF   |
// |TX       ( 3) = OFF   |DIS3    ( 3) = OFF   |
// |REL1     ( 4) = OFF   |DIS4    ( 4) = OFF   |
// |REL2     ( 5) = OFF   |INFR    ( 5) = OFF   |
// |SCK      ( 6) = OFF   |RESIS   ( 6) = OFF   |
// |SDA      ( 7) = OFF   |TEMP    ( 7) = OFF   |
// |RTC      ( 8) = OFF   |VENT    ( 8) = OFF   |
// |LED1     ( 9) = OFF   |AN0     ( 9) = OFF   |
// |LED2     (10) = OFF   |AN1     (10) = OFF   |
//  --------------------- ----------------------

// --- Ligacoes entre PIC e LCD ---
sbit LCD_RS at RE2_bit;   // PINO 2 DO PORTD INTERLIGADO AO RS DO DISPLAY
sbit LCD_EN at RE1_bit;   // PINO 3 DO PORTD INTERLIGADO AO EN DO DISPLAY
sbit LCD_D7 at RD7_bit;  // PINO 7 DO PORTD INTERLIGADO AO D7 DO DISPLAY
sbit LCD_D6 at RD6_bit;  // PINO 6 DO PORTD INTERLIGADO AO D6 DO DISPLAY
sbit LCD_D5 at RD5_bit;  // PINO 5 DO PORTD INTERLIGADO AO D5 DO DISPLAY
sbit LCD_D4 at RD4_bit;  // PINO 4 DO PORTD INTERLIGADO AO D4 DO DISPLAY

// Selecionando direcao de fluxo de dados dos pinos utilizados para a comunicacao com display LCD
sbit LCD_RS_Direction at TRISE2_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 2 DO PORTD
sbit LCD_EN_Direction at TRISE1_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 3 DO PORTD
sbit LCD_D7_Direction at TRISD7_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 7 DO PORTD
sbit LCD_D6_Direction at TRISD6_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 6 DO PORTD
sbit LCD_D5_Direction at TRISD5_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 5 DO PORTD
sbit LCD_D4_Direction at TRISD4_bit;  // SETA DIRECAO DO FLUXO DE DADOS DO PINO 4 DO PORTD

char ucRead;        // Variavel para armazenar o dado lido.
unsigned int Control = 0;  // +++++++ VARIAVEL DE CONTROLE DA COMUNICACAO ++++++++
                           // LEMBRE DE ALTERAR ESSA VARIAVEL TAMBEM NO ARDUINO

void main(){

   ADCON1  = 0x0E;                           //Configura os pinos do PORTB como digitais, e RA0 (PORTA) como analogico

   Lcd_Init();                               //Inicializa m dulo LCD
   Lcd_Cmd(_LCD_CURSOR_OFF);                 //Apaga cursor
   Lcd_Cmd(_LCD_CLEAR);                      //Limpa display

   UART1_Init(9600);  // Utiliza bibliotecas do compilador para configurcao do Baud rate.


   while(1){  // SELECIONE A VARIAVEL DE CONTROLE (CONTROL) DECLARADA ACIMA.
     if (Control == 0){   // O PIC (Control = 0) envia um caracter e o Arduino responde com outro caracter.
       UART1_Write('T'); // Transmite o caracter para o Arduino
       lcd_out(1,1,"PIC Send/Receive");
       lcd_out(2,1,"Send = T");
       Delay_ms(50);
       if(UART1_Data_Ready()){  // Verifica se um dado foi recebido no buffer
         ucRead = UART1_Read(); // Le o dado recebido do buffer.
         Delay_ms(50);   // Pausa de 50ms.
         if (ucRead == 'S'){
          lcd_out(2,10,"Rec.= ");
          lcd_chr_cp (ucRead);
          }
       }
     }

     if (Control == 1){   // O PIC (Control = 1) recebe um caracter do Arduino e responde com outro caracter.
       if(UART1_Data_Ready()){  // Verifica se um dado foi recebido no buffer
         ucRead = UART1_Read(); // Le o dado recebido do buffer.
         Delay_ms(50);   // Pausa de 50ms.
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