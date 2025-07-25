//trabalho final de sistemas embarcados desenvolvido por André Filipe Siqueira Tokumoto

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


char recebido;
char lastRecebido = 0;
unsigned char controleBitDisparado = 0;


unsigned char rb3Travado = 0;
unsigned char rb1Travado = 0;
unsigned char rb2Travado = 0;

unsigned char pwmValue = 0;
unsigned char fadeDirection = 1;


void main() {
    ADCON1 = 0x0E;
    TRISB.RB3 = 1;
    TRISB.RB1 = 1;
    TRISB.RB2 = 1;
    INTCON2.RBPU = 0;

    TRISD = 0x00;
    PORTD = 0x00;

    PWM1_Init(5000);
    PWM1_Start();
    PWM1_Set_Duty(0);

    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Sistema Pronto");

    UART1_Init(9600);
    Delay_ms(100);

    while (1) {

        if ((PORTB.RB3 == 0) && (rb3Travado == 0)) {
            rb3Travado = 1;
            controleBitDisparado = 0;
            UART1_Write(1);
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Ativado");
        }
        if ((PORTB.RB3 == 1) && (rb3Travado == 1)) rb3Travado = 0;


        if ((PORTB.RB1 == 0) && (rb1Travado == 0)) {
            rb1Travado = 1;
            controleBitDisparado = 0;
            UART1_Write(0);
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Desativado");
        }
        if ((PORTB.RB1 == 1) && (rb1Travado == 1)) rb1Travado = 0;


        if ((PORTB.RB2 == 0) && (rb2Travado == 0)) {
            rb2Travado = 1;
            controleBitDisparado = 1;
            UART1_Write(2);
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1,1,"Disparado");
        }
        if ((PORTB.RB2 == 1) && (rb2Travado == 1)) rb2Travado = 0;


        if (UART1_Data_Ready()) {
            recebido = UART1_Read();
            if (lastRecebido != recebido) {
                if (recebido == 2) {
                    controleBitDisparado = 1;
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1,1,"DISPARADO!!");
                } else if (recebido == 4) {
                    controleBitDisparado = 0;
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1,1,"DESARMADO!!");
                }
                lastRecebido = recebido;
            }
        }


        if (controleBitDisparado == 1) {

            if (fadeDirection == 1) {
                pwmValue += 5;
                if (pwmValue >= 250) {
                    fadeDirection = 0;
                }
            } else {
                pwmValue -= 5;
                if (pwmValue <= 5) {
                    fadeDirection = 1;
                }
            }

            PWM1_Set_Duty(pwmValue);


            if (pwmValue > 127) {
                PORTD = 0xFF;
            } else {
                PORTD = 0x00;
            }

            Delay_ms(20);
        } else {
            PWM1_Set_Duty(0);
            PORTD = 0x00;
            pwmValue = 0;
            fadeDirection = 1;
        }
    }
}

