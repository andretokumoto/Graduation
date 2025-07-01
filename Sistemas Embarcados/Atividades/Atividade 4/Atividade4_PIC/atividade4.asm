
_main:

;atividade4.c,1 :: 		void main(){
;atividade4.c,3 :: 		unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
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
	CLRF        main_uiContador_L0+0 
	CLRF        main_uiContador_L0+1 
	CLRF        main_uiValor_L0+0 
	CLRF        main_uiValor_L0+1 
;atividade4.c,9 :: 		ADCON1 = 0x0f;       // Configura todos canais como Digital.
	MOVLW       15
	MOVWF       ADCON1+0 
;atividade4.c,11 :: 		TRISB.RB1 = 1;
	BSF         TRISB+0, 1 
;atividade4.c,12 :: 		TRISA.RA3 = 0;
	BCF         TRISA+0, 3 
;atividade4.c,13 :: 		TRISA.RA4 = 0;
	BCF         TRISA+0, 4 
;atividade4.c,14 :: 		TRISB.RB5 = 0;
	BCF         TRISB+0, 5 
;atividade4.c,15 :: 		TRISD = 0x00;
	CLRF        TRISD+0 
;atividade4.c,16 :: 		PORTB.RB1 = 0;
	BCF         PORTB+0, 1 
;atividade4.c,18 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;atividade4.c,19 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
	NOP
;atividade4.c,21 :: 		ucStatus_inc = 1;
	MOVLW       1
	MOVWF       main_ucStatus_inc_L0+0 
;atividade4.c,22 :: 		uiContador = 0;
	CLRF        main_uiContador_L0+0 
	CLRF        main_uiContador_L0+1 
;atividade4.c,26 :: 		while(1){
L_main1:
;atividade4.c,28 :: 		uiValor = uiContador;
	MOVF        main_uiContador_L0+0, 0 
	MOVWF       main_uiValor_L0+0 
	MOVF        main_uiContador_L0+1, 0 
	MOVWF       main_uiValor_L0+1 
;atividade4.c,30 :: 		PORTD = ucMask[uiValor % 10];
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
;atividade4.c,31 :: 		PORTA.RA4 = 1;
	BSF         PORTA+0, 4 
;atividade4.c,32 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
;atividade4.c,33 :: 		PORTA.RA4 = 0;
	BCF         PORTA+0, 4 
;atividade4.c,34 :: 		uiValor /= 10;
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
;atividade4.c,36 :: 		PORTD = ucMask[uiValor % 10];
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
;atividade4.c,37 :: 		PORTA.RA3 = 1;
	BSF         PORTA+0, 3 
;atividade4.c,38 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	NOP
;atividade4.c,39 :: 		PORTA.RA3 = 0;
	BCF         PORTA+0, 3 
;atividade4.c,41 :: 		if((PORTB.RB1 == 1) && (ucStatus_inc == 0)){
	BTFSS       PORTB+0, 1 
	GOTO        L_main7
	MOVF        main_ucStatus_inc_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
L__main15:
;atividade4.c,42 :: 		ucStatus_inc = 1;
	MOVLW       1
	MOVWF       main_ucStatus_inc_L0+0 
;atividade4.c,43 :: 		uiContador++;
	INFSNZ      main_uiContador_L0+0, 1 
	INCF        main_uiContador_L0+1, 1 
;atividade4.c,44 :: 		if(uiContador > 99){
	MOVLW       0
	MOVWF       R0 
	MOVF        main_uiContador_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main17
	MOVF        main_uiContador_L0+0, 0 
	SUBLW       99
L__main17:
	BTFSC       STATUS+0, 0 
	GOTO        L_main8
;atividade4.c,45 :: 		uiContador = 99;
	MOVLW       99
	MOVWF       main_uiContador_L0+0 
	MOVLW       0
	MOVWF       main_uiContador_L0+1 
;atividade4.c,46 :: 		}
L_main8:
;atividade4.c,48 :: 		if(uiContador % 2 == 0){
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
	GOTO        L__main18
	MOVLW       0
	XORWF       R1, 0 
L__main18:
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;atividade4.c,49 :: 		PORTB.RB5 = 1;
	BSF         PORTB+0, 5 
;atividade4.c,50 :: 		} else {
	GOTO        L_main10
L_main9:
;atividade4.c,51 :: 		PORTB.RB5 = 0;
	BCF         PORTB+0, 5 
;atividade4.c,52 :: 		}
L_main10:
;atividade4.c,54 :: 		UART1_Write(uiContador);
	MOVF        main_uiContador_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;atividade4.c,55 :: 		UART1_Write(PORTB.RB5);
	MOVLW       0
	BTFSC       PORTB+0, 5 
	MOVLW       1
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;atividade4.c,56 :: 		}
L_main7:
;atividade4.c,58 :: 		if((PORTB.RB1 == 0) && (ucStatus_inc == 1)){
	BTFSC       PORTB+0, 1 
	GOTO        L_main13
	MOVF        main_ucStatus_inc_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
L__main14:
;atividade4.c,59 :: 		ucStatus_inc = 0;
	CLRF        main_ucStatus_inc_L0+0 
;atividade4.c,60 :: 		}
L_main13:
;atividade4.c,62 :: 		}
	GOTO        L_main1
;atividade4.c,63 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
