#include <string.h>

// --- Ligações entre PIC e LCD ---
sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Direção dos pinos usados para comunicação com o LCD
sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

// Variáveis globais
char recebido;
char lastRecebido = 0;
unsigned char ucStatus = 1;

// Variáveis para temporização e debounce
unsigned int timerCounter = 0;
unsigned int lastRB0Time = 0;
unsigned int lastRB1Time = 0;
unsigned int lastRB2Time = 0;
const unsigned int debounceDelay = 200; // ~200ms

// Protótipo da função de interrupção
void Interrupt();

void main() {
    // Configuração de portas
    ADCON1 = 0x0E;          // Configura RA0 como analógico, o resto como digital
    TRISB.RB0 = 1;          // Botão para ativar alarme
    TRISB.RB1 = 1;          // Botão para desarmar alarme
    TRISB.RB2 = 1;          // Botão para disparar alarme

    // Configura USART (TX=RC6, RX=RC7)
    TRISC.RC6 = 0;          // TX como saída
    TRISC.RC7 = 1;          // RX como entrada

    // Configura Timer0 para contagem de tempo (ajustar conforme clock do PIC)
    T0CON = 0xC7;           // Timer0 ON, 16-bit, prescaler 1:256
    TMR0H = 0x00;           // Valores iniciais
    TMR0L = 0x00;
    INTCON.TMR0IE = 1;      // Habilita interrupção do Timer0
    INTCON.GIE = 1;         // Habilita interrupções globais

    Lcd_Init();             // Inicializa LCD
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Sistema Pronto");

    // Inicializa USART para comunicação com Arduino
    UART1_Init(9600);       // Baud rate 9600
    Delay_ms(100);          // Espera estabilização

    while (1) {
        // --- Controle do botão RB0 (Ativar Alarme) ---
        if (PORTB.RB0 == 0 && (timerCounter - lastRB0Time > debounceDelay)) {
            lastRB0Time = timerCounter;

            UART1_Write('1');  // Envia comando para ativar
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Alarme Ativado");
            Delay_ms(1000);
        }

        // --- Controle do botão RB1 (Desarmar Alarme) ---
        if (PORTB.RB1 == 0 && (timerCounter - lastRB1Time > debounceDelay)) {
            lastRB1Time = timerCounter;

            UART1_Write('0');  // Envia comando para desativar
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Alarme Desativado");
            Delay_ms(1000);
        }

        // --- Controle do botão RB2 (Disparar Alarme) ---
        if (PORTB.RB2 == 0 && (timerCounter - lastRB2Time > debounceDelay)) {
            lastRB2Time = timerCounter;

            UART1_Write('2');  // Envia comando para disparar
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Alarme Disparado!");
            Delay_ms(1000);
        }

        // --- Recebe dado do Arduino via USART ---
        if (UART1_Data_Ready()) {
            recebido = UART1_Read();

            if (lastRecebido != recebido) {
                if (recebido == '2') {
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1,1,"ALARME DISPARADO!!");
                }
                else if (recebido == '3') {
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1,1,"Presenca detectada");
                }
                else if (recebido == '4') {
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1,1,"ALARME DESARMADO!!");
                }
                lastRecebido = recebido;
            }
        }
    }
}

// Rotina de interrupção do Timer0
void Interrupt() {
    if (INTCON.TMR0IF) {
        INTCON.TMR0IF = 0;  // Limpa flag de interrupção
        timerCounter++;      // Incrementa nosso contador de tempo
        TMR0H = 0x00;       // Reinicia Timer0
        TMR0L = 0x00;
    }
}