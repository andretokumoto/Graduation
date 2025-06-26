
_main:

;displaybotao.c,3 :: 		void main(){
;displaybotao.c,5 :: 		unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
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
;displaybotao.c,14 :: 		ADCON1 = 0x0f;       // Configura todos canais como Digital.
	MOVLW       15
	MOVWF       ADCON1+0 
;displaybotao.c,16 :: 		TRISB.RB0=1;         // Define o pino RB0 do PORTB como entrada.
	BSF         TRISB+0, 0 
;displaybotao.c,17 :: 		TRISB.RB1=1;         // Define o pino RB1 Do PORTB como entrada.
	BSF         TRISB+0, 1 
;displaybotao.c,19 :: 		TRISA.RA2=0;         // Define o pino RA2 do PORTA como saida(Selecao Display 1).
	BCF         TRISA+0, 2 
;displaybotao.c,20 :: 		TRISA.RA3=0;         // Define o pino RA3 do PORTA como saida(Selecao Display 2).
	BCF         TRISA+0, 3 
;displaybotao.c,21 :: 		TRISA.RA4=0;         // Define o pino RA4 do PORTA como saida(Selecao Display 3).
	BCF         TRISA+0, 4 
;displaybotao.c,22 :: 		TRISA.RA5=0;         // Define o pino RA5 do PORTA como saida(Selecao Display 4).
	BCF         TRISA+0, 5 
;displaybotao.c,24 :: 		TRISD = 0;           // Define todos os pinos Do PORTD como saida.
	CLRF        TRISD+0 
;displaybotao.c,26 :: 		ucStatus_inc=0;      // Inicializa a variavel com o valor 0.
	CLRF        main_ucStatus_inc_L0+0 
;displaybotao.c,27 :: 		ucStatus_dec=0;      // Inicializa a variavel com o valor 0.
	CLRF        main_ucStatus_dec_L0+0 
;displaybotao.c,28 :: 		uiContador=0;        // Inicializa a variavel com o valor 0.
	CLRF        main_uiContador_L0+0 
	CLRF        main_uiContador_L0+1 
;displaybotao.c,30 :: 		while(1){            // Aqui definimos uma condicao sempre verdadeira como parametro,
L_main0:
;displaybotao.c,34 :: 		if((PORTB.RB0==0)&&(ucStatus_inc==0)){    // Incrementa somente uma vez quando a
	BTFSC       PORTB+0, 0 
	GOTO        L_main4
	MOVF        main_ucStatus_inc_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
L__main23:
;displaybotao.c,36 :: 		ucStatus_inc=1;        // Variavel de travamento do incremento.
	MOVLW       1
	MOVWF       main_ucStatus_inc_L0+0 
;displaybotao.c,37 :: 		uiContador++;          // Esse operador aritmetico(++) realiza o mesmo que
	INFSNZ      main_uiContador_L0+0, 1 
	INCF        main_uiContador_L0+1, 1 
;displaybotao.c,39 :: 		if(uiContador>9999){ 	// Define o valor maximo a ser mostrado no displays como 9999.
	MOVF        main_uiContador_L0+1, 0 
	SUBLW       39
	BTFSS       STATUS+0, 2 
	GOTO        L__main25
	MOVF        main_uiContador_L0+0, 0 
	SUBLW       15
L__main25:
	BTFSC       STATUS+0, 0 
	GOTO        L_main5
;displaybotao.c,40 :: 		uiContador=9999;
	MOVLW       15
	MOVWF       main_uiContador_L0+0 
	MOVLW       39
	MOVWF       main_uiContador_L0+1 
;displaybotao.c,41 :: 		}
L_main5:
;displaybotao.c,42 :: 		}
L_main4:
;displaybotao.c,43 :: 		if((PORTB.RB0==1)&&(ucStatus_inc==1)){   	// Volta a disponibilizar a opcao de
	BTFSS       PORTB+0, 0 
	GOTO        L_main8
	MOVF        main_ucStatus_inc_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
L__main22:
;displaybotao.c,45 :: 		ucStatus_inc=0;
	CLRF        main_ucStatus_inc_L0+0 
;displaybotao.c,46 :: 		}
L_main8:
;displaybotao.c,48 :: 		if((PORTB.RB1==0)&&(ucStatus_dec==0)){   	// Decrementa somente uma vez quando a
	BTFSC       PORTB+0, 1 
	GOTO        L_main11
	MOVF        main_ucStatus_dec_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
L__main21:
;displaybotao.c,50 :: 		ucStatus_dec=1;        // Variavel de travamento do decremento.
	MOVLW       1
	MOVWF       main_ucStatus_dec_L0+0 
;displaybotao.c,51 :: 		uiContador--;          // Esse operador aritmetico(--) realiza o mesmo que
	MOVLW       1
	SUBWF       main_uiContador_L0+0, 1 
	MOVLW       0
	SUBWFB      main_uiContador_L0+1, 1 
;displaybotao.c,53 :: 		if(uiContador>9999){   // Define o valor maximo quando ocorrer a transicao
	MOVF        main_uiContador_L0+1, 0 
	SUBLW       39
	BTFSS       STATUS+0, 2 
	GOTO        L__main26
	MOVF        main_uiContador_L0+0, 0 
	SUBLW       15
L__main26:
	BTFSC       STATUS+0, 0 
	GOTO        L_main12
;displaybotao.c,55 :: 		uiContador=9999;
	MOVLW       15
	MOVWF       main_uiContador_L0+0 
	MOVLW       39
	MOVWF       main_uiContador_L0+1 
;displaybotao.c,56 :: 		}
L_main12:
;displaybotao.c,57 :: 		}
L_main11:
;displaybotao.c,58 :: 		if((PORTB.RB1==1)&&(ucStatus_dec==1)){    // Volta a disponibilizar a opcao de
	BTFSS       PORTB+0, 1 
	GOTO        L_main15
	MOVF        main_ucStatus_dec_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main15
L__main20:
;displaybotao.c,60 :: 		ucStatus_dec=0;
	CLRF        main_ucStatus_dec_L0+0 
;displaybotao.c,61 :: 		}
L_main15:
;displaybotao.c,63 :: 		uiValor = uiContador;     // Coloca o conteudo da variavel do contador na
	MOVF        main_uiContador_L0+0, 0 
	MOVWF       main_uiValor_L0+0 
	MOVF        main_uiContador_L0+1, 0 
	MOVWF       main_uiValor_L0+1 
;displaybotao.c,67 :: 		PORTD = ucMask[uiValor%10];        // Pega modulo da divisao por 10 e coloca o
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
;displaybotao.c,69 :: 		PORTA.RA5 = 1;                     // Liga o transistor associado ao display 1.
	BSF         PORTA+0, 5 
;displaybotao.c,70 :: 		Delay_ms(2);                       // Delay para escrita no display.
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main16:
	DECFSZ      R13, 1, 1
	BRA         L_main16
	DECFSZ      R12, 1, 1
	BRA         L_main16
	NOP
;displaybotao.c,71 :: 		PORTA.RA5 = 0;                     // Desliga o transistor associado ao display 1.
	BCF         PORTA+0, 5 
;displaybotao.c,72 :: 		uiValor/=10;                       // Divide variavel por 10 para definir a dezena.
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
;displaybotao.c,74 :: 		PORTD = ucMask[uiValor%10];
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
;displaybotao.c,75 :: 		PORTA.RA4 = 1;
	BSF         PORTA+0, 4 
;displaybotao.c,76 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main17:
	DECFSZ      R13, 1, 1
	BRA         L_main17
	DECFSZ      R12, 1, 1
	BRA         L_main17
	NOP
;displaybotao.c,77 :: 		PORTA.RA4 = 0;
	BCF         PORTA+0, 4 
;displaybotao.c,78 :: 		uiValor/=10;
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
;displaybotao.c,80 :: 		PORTD = ucMask[uiValor%10];
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
;displaybotao.c,81 :: 		PORTA.RA3 = 1;
	BSF         PORTA+0, 3 
;displaybotao.c,82 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main18:
	DECFSZ      R13, 1, 1
	BRA         L_main18
	DECFSZ      R12, 1, 1
	BRA         L_main18
	NOP
;displaybotao.c,83 :: 		PORTA.RA3 = 0;
	BCF         PORTA+0, 3 
;displaybotao.c,84 :: 		uiValor/=10;
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
;displaybotao.c,86 :: 		PORTD = ucMask[uiValor%10];
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
;displaybotao.c,87 :: 		PORTA.RA2 = 1;
	BSF         PORTA+0, 2 
;displaybotao.c,88 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main19:
	DECFSZ      R13, 1, 1
	BRA         L_main19
	DECFSZ      R12, 1, 1
	BRA         L_main19
	NOP
;displaybotao.c,89 :: 		PORTA.RA2 = 0;
	BCF         PORTA+0, 2 
;displaybotao.c,90 :: 		}
	GOTO        L_main0
;displaybotao.c,91 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
