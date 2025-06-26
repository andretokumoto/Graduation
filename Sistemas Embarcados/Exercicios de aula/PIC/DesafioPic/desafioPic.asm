
_main:

;desafioPic.c,1 :: 		void main(){
;desafioPic.c,3 :: 		unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
	MOVLW       63
	MOVWF       main_ucMask_L0+0 
	MOVLW       6
	MOVWF       main_ucMask_L0+1 
	MOVLW       91
	MOVWF       main_ucMask_L0+2 
	MOVLW       79
	MOVWF       main_ucMask_L0+3 
	MOVLW       102
	MOVWF       main_ucMask_L0+4 
	MOVLW       109
	MOVWF       main_ucMask_L0+5 
	MOVLW       125
	MOVWF       main_ucMask_L0+6 
	MOVLW       7
	MOVWF       main_ucMask_L0+7 
	MOVLW       127
	MOVWF       main_ucMask_L0+8 
	MOVLW       111
	MOVWF       main_ucMask_L0+9 
;desafioPic.c,9 :: 		ADCON1 = 0x0f;       // Configura todos canais como Digital.
	MOVLW       15
	MOVWF       ADCON1+0 
;desafioPic.c,11 :: 		TRISB.RB1=1;         // Entrada do botão
	BSF         TRISB+0, 1 
;desafioPic.c,12 :: 		TRISA.RA3=0;         // Saída para display (dezenas)
	BCF         TRISA+0, 3 
;desafioPic.c,13 :: 		TRISA.RA4=0;         // Saída para display (unidades)
	BCF         TRISA+0, 4 
;desafioPic.c,14 :: 		TRISB.RB5=0;         // Saída para LED
	BCF         TRISB+0, 5 
;desafioPic.c,17 :: 		ucStatus_inc=0;
	CLRF        main_ucStatus_inc_L0+0 
;desafioPic.c,18 :: 		uiContador=0;
	CLRF        main_uiContador_L0+0 
	CLRF        main_uiContador_L0+1 
;desafioPic.c,20 :: 		while(1){
L_main0:
;desafioPic.c,23 :: 		if((PORTB.RB1==1)&&(ucStatus_inc==0)){
	BTFSS       PORTB+0, 1 
	GOTO        L_main4
	MOVF        main_ucStatus_inc_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
L__main14:
;desafioPic.c,24 :: 		ucStatus_inc=1;
	MOVLW       1
	MOVWF       main_ucStatus_inc_L0+0 
;desafioPic.c,25 :: 		uiContador++;
	INFSNZ      main_uiContador_L0+0, 1 
	INCF        main_uiContador_L0+1, 1 
;desafioPic.c,26 :: 		if(uiContador>99){         // Máximo 2 dígitos para exibir nos dois displays centrais
	MOVLW       0
	MOVWF       R0 
	MOVF        main_uiContador_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main16
	MOVF        main_uiContador_L0+0, 0 
	SUBLW       99
L__main16:
	BTFSC       STATUS+0, 0 
	GOTO        L_main5
;desafioPic.c,27 :: 		uiContador=99;
	MOVLW       99
	MOVWF       main_uiContador_L0+0 
	MOVLW       0
	MOVWF       main_uiContador_L0+1 
;desafioPic.c,28 :: 		}
L_main5:
;desafioPic.c,31 :: 		if(uiContador % 2 == 0){
	MOVLW       1
	ANDWF       main_uiContador_L0+0, 0 
	MOVWF       R1 
	MOVF        main_uiContador_L0+1, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main17
	MOVLW       0
	XORWF       R1, 0 
L__main17:
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;desafioPic.c,32 :: 		PORTB.RB5 = 1;
	BSF         PORTB+0, 5 
;desafioPic.c,33 :: 		} else {
	GOTO        L_main7
L_main6:
;desafioPic.c,34 :: 		PORTB.RB5 = 0;
	BCF         PORTB+0, 5 
;desafioPic.c,35 :: 		}
L_main7:
;desafioPic.c,43 :: 		}
L_main4:
;desafioPic.c,45 :: 		if((PORTB.RB1==0)&&(ucStatus_inc==1)){
	BTFSC       PORTB+0, 1 
	GOTO        L_main10
	MOVF        main_ucStatus_inc_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main10
L__main13:
;desafioPic.c,46 :: 		ucStatus_inc=0;
	CLRF        main_ucStatus_inc_L0+0 
;desafioPic.c,47 :: 		}
L_main10:
;desafioPic.c,50 :: 		uiValor = uiContador;
	MOVF        main_uiContador_L0+0, 0 
	MOVWF       main_uiValor_L0+0 
	MOVF        main_uiContador_L0+1, 0 
	MOVWF       main_uiValor_L0+1 
;desafioPic.c,53 :: 		PORTD = ucMask[uiValor % 10];
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        main_uiContador_L0+0, 0 
	MOVWF       R0 
	MOVF        main_uiContador_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       main_ucMask_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(main_ucMask_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;desafioPic.c,54 :: 		PORTA.RA4 = 1;
	BSF         PORTA+0, 4 
;desafioPic.c,55 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	NOP
;desafioPic.c,56 :: 		PORTA.RA4 = 0;
	BCF         PORTA+0, 4 
;desafioPic.c,57 :: 		uiValor /= 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        main_uiValor_L0+0, 0 
	MOVWF       R0 
	MOVF        main_uiValor_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_uiValor_L0+0 
	MOVF        R1, 0 
	MOVWF       main_uiValor_L0+1 
;desafioPic.c,60 :: 		PORTD = ucMask[uiValor % 10];
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       main_ucMask_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(main_ucMask_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;desafioPic.c,61 :: 		PORTA.RA3 = 1;
	BSF         PORTA+0, 3 
;desafioPic.c,62 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	DECFSZ      R12, 1, 1
	BRA         L_main12
	NOP
;desafioPic.c,63 :: 		PORTA.RA3 = 0;
	BCF         PORTA+0, 3 
;desafioPic.c,64 :: 		}
	GOTO        L_main0
;desafioPic.c,65 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
