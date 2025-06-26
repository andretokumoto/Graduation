//********************************************************************************
//             PROGRAMA EXEMPLO: Acionamento do Display 7 Seg.
//              OBJETIVO: Aprender a utilizar o display 7 seg.

//                       MICROCONTROLADOR: PIC18F4520.
//              http://ww1.microchip.com/downloads/en/DeviceDoc/39631E.pdf

//********************************************************************************

void main(){ // funcao principal do programa

    ADCON1 = 6; //configura todos os pinos AD como I/O

    TRISA = 0; //define portA como saida
    PORTA = 0; //reseta todos os pinos do porta

    TRISD = 0; //define portD como saida
    PORTD = 255; //seta todos os pinos do portd


  do { //inicio da rotina de loop
    PORTA.RA2= 1; //liga primeiro display
    PORTD = 0b11111101; //escreve digito 6
    Delay_ms(1); //delay de 1ms
    PORTA.RA2= 0; //desliga primeiro display

    PORTA.RA3= 1; //liga segundo display
    PORTD = 0b00111111; //escreve digito 0
    Delay_ms(1); //delay de 1ms
    PORTA.RA3= 0; //desliga terceiro display

    PORTA.RA4= 1; //liga terceiro display
    PORTD = 0b01101101; //escreve digito 5
    Delay_ms(1); //delay de 1ms
    PORTA.RA4= 0; //desliga terceiro display

    PORTA.RA5= 1; //liga quarto display
    PORTD = 0b00000111; //escreve digito 7
    Delay_ms(1); //delay de 1ms
    PORTA.RA5= 0; //desliga quarto display
  }

  while (1);

}