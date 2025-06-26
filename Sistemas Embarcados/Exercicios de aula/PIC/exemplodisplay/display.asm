
_main:

;display.c,10 :: 		void main(){ // funcao principal do programa
;display.c,12 :: 		ADCON1 = 6; //configura todos os pinos AD como I/O
	MOVLW       6
	MOVWF       ADCON1+0 
;display.c,14 :: 		TRISA = 0; //define portA como saida
	CLRF        TRISA+0 
;display.c,15 :: 		PORTA = 0; //reseta todos os pinos do porta
	CLRF        PORTA+0 
;display.c,17 :: 		TRISD = 0; //define portD como saida
	CLRF        TRISD+0 
;display.c,18 :: 		PORTD = 255; //seta todos os pinos do portd
	MOVLW       255
	MOVWF       PORTD+0 
;display.c,21 :: 		do { //inicio da rotina de loop
L_main0:
;display.c,22 :: 		PORTA.RA2= 1; //liga primeiro display
	BSF         PORTA+0, 2 
;display.c,23 :: 		PORTD = 0b11111101; //escreve digito 6
	MOVLW       253
	MOVWF       PORTD+0 
;display.c,24 :: 		Delay_ms(1); //delay de 1ms
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
	NOP
;display.c,25 :: 		PORTA.RA2= 0; //desliga primeiro display
	BCF         PORTA+0, 2 
;display.c,27 :: 		PORTA.RA3= 1; //liga segundo display
	BSF         PORTA+0, 3 
;display.c,28 :: 		PORTD = 0b00111111; //escreve digito 0
	MOVLW       63
	MOVWF       PORTD+0 
;display.c,29 :: 		Delay_ms(1); //delay de 1ms
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	NOP
	NOP
;display.c,30 :: 		PORTA.RA3= 0; //desliga terceiro display
	BCF         PORTA+0, 3 
;display.c,32 :: 		PORTA.RA4= 1; //liga terceiro display
	BSF         PORTA+0, 4 
;display.c,33 :: 		PORTD = 0b01101101; //escreve digito 5
	MOVLW       109
	MOVWF       PORTD+0 
;display.c,34 :: 		Delay_ms(1); //delay de 1ms
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
	NOP
;display.c,35 :: 		PORTA.RA4= 0; //desliga terceiro display
	BCF         PORTA+0, 4 
;display.c,37 :: 		PORTA.RA5= 1; //liga quarto display
	BSF         PORTA+0, 5 
;display.c,38 :: 		PORTD = 0b00000111; //escreve digito 7
	MOVLW       7
	MOVWF       PORTD+0 
;display.c,39 :: 		Delay_ms(1); //delay de 1ms
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	NOP
	NOP
;display.c,40 :: 		PORTA.RA5= 0; //desliga quarto display
	BCF         PORTA+0, 5 
;display.c,43 :: 		while (1);
	GOTO        L_main0
;display.c,45 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
