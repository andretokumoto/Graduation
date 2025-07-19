#include <string.h>  // Necessário para strcmp

// --- Ligações entre PIC e LCD ---
sbit LCD_RS at RE2_bit;   // PINO 2 DO PORTE INTERLIGADO AO RS DO DISPLAY
sbit LCD_EN at RE1_bit;   // PINO 3 DO PORTE INTERLIGADO AO EN DO DISPLAY
sbit LCD_D7 at RD7_bit;   // PINO 7 DO PORTD INTERLIGADO AO D7 DO DISPLAY
sbit LCD_D6 at RD6_bit;   // PINO 6 DO PORTD INTERLIGADO AO D6 DO DISPLAY
sbit LCD_D5 at RD5_bit;   // PINO 5 DO PORTD INTERLIGADO AO D5 DO DISPLAY
sbit LCD_D4 at RD4_bit;   // PINO 4 DO PORTD INTERLIGADO AO D4 DO DISPLAY

// Direção dos pinos usados para comunicação com o LCD
sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

char recebido;        // Variável para armazenar o dado lido
char comando[50];     // Buffer para a string
unsigned int i = 0;
unsigned char ucStatus = 1;

void main() {
    ADCON1  = 0x0E;                 // Configura RA0 como analógico, o resto como digital
    TRISB.RB1 = 1;                  // Botão de entrada

    Delay_ms(50);                  // Pequeno atraso inicial

    Lcd_Init();                    // Inicializa LCD
    Lcd_Cmd(_LCD_CURSOR_OFF);      // Oculta cursor
    Lcd_Cmd(_LCD_CLEAR);           // Limpa display

    UART1_Init(9600);              // Inicializa UART

    while (1) {
        // Controle do botão para acionar alarme
        if ((PORTB.RB1 == 0) && (ucStatus == 0)) {
            ucStatus = 1;
            UART1_Write('d');  // Envia comando para disparar alarme
            Delay_ms(200);     // Debounce
        } else if ((PORTB.RB1 == 0) && (ucStatus == 1)) {
            ucStatus = 0;
            Delay_ms(200);     // Debounce
        }

        // Recepção de comandos via UART
        if (UART1_Data_Ready()) {
            char c = UART1_Read();

            if (c == '\r' || c == '\n') {
                comando[i] = '\0';  // Finaliza string

                if (strcmp(comando, "desativar") == 0) {
                    UART1_Write(0);
                } else if (strcmp(comando, "ativar") == 0) {
                    UART1_Write(1);
                }

                i = 0;  // Reseta índice
            } else {
                if (i < sizeof(comando) - 1) {
                    comando[i++] = c;
                }
            }
        }

        // Resposta a comandos recebidos do Arduino
        if (UART1_Data_Ready()) {
            recebido = UART1_Read();  // Corrigido: agora lê o dado
            Delay_ms(50);

            if (recebido == 'd') {
            
                Lcd_Cmd(_LCD_CLEAR);
                Delay_ms(10);
                Lcd_Out(1,1,"ALARME DISPARADO!!");
            } 
            else if (recebido == 'p') {
            
                Lcd_Cmd(_LCD_CLEAR);
                Delay_ms(10);
                Lcd_Out(1,1,"Presenca detectada");
            } 
            else if (recebido == 'a') {
            
                Lcd_Cmd(_LCD_CLEAR);
                Delay_ms(10);
                Lcd_Out(1,1,"ALARME DISPARADO!!");
                Lcd_Out(2,1,"PORTA ABERTA!!");
            }
        }
    }
}