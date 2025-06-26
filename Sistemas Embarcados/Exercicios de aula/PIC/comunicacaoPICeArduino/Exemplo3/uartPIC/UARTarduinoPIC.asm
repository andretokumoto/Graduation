
_main:

;UARTarduinoPIC.c,44 :: 		void main(){
;UARTarduinoPIC.c,46 :: 		ADCON1  = 0x0E;                           //Configura os pinos do PORTB como digitais, e RA0 (PORTA) como analogico
	MOVLW       14
	MOVWF       ADCON1+0 
;UARTarduinoPIC.c,48 :: 		Lcd_Init();                               //Inicializa m dulo LCD
	CALL        _Lcd_Init+0, 0
;UARTarduinoPIC.c,49 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                 //Apaga cursor
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;UARTarduinoPIC.c,50 :: 		Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;UARTarduinoPIC.c,52 :: 		UART1_Init(9600);  // Utiliza bibliotecas do compilador para configurcao do Baud rate.
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;UARTarduinoPIC.c,55 :: 		while(1){  // SELECIONE A VARIAVEL DE CONTROLE (CONTROL) DECLARADA ACIMA.
L_main0:
;UARTarduinoPIC.c,56 :: 		if (Control == 0){   // O PIC (Control = 0) envia um caracter e o Arduino responde com outro caracter.
	MOVLW       0
	XORWF       _Control+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVLW       0
	XORWF       _Control+0, 0 
L__main13:
	BTFSS       STATUS+0, 2 
	GOTO        L_main2
;UARTarduinoPIC.c,57 :: 		UART1_Write('T'); // Transmite o caracter para o Arduino
	MOVLW       84
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;UARTarduinoPIC.c,58 :: 		lcd_out(1,1,"PIC Send/Receive");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_UARTarduinoPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_UARTarduinoPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;UARTarduinoPIC.c,59 :: 		lcd_out(2,1,"Send = T");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_UARTarduinoPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_UARTarduinoPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;UARTarduinoPIC.c,60 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	NOP
	NOP
;UARTarduinoPIC.c,61 :: 		if(UART1_Data_Ready()){  // Verifica se um dado foi recebido no buffer
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;UARTarduinoPIC.c,62 :: 		ucRead = UART1_Read(); // Le o dado recebido do buffer.
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _ucRead+0 
;UARTarduinoPIC.c,63 :: 		Delay_ms(50);   // Pausa de 50ms.
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
	NOP
;UARTarduinoPIC.c,64 :: 		if (ucRead == 'S'){
	MOVF        _ucRead+0, 0 
	XORLW       83
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;UARTarduinoPIC.c,65 :: 		lcd_out(2,10,"Rec.= ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_UARTarduinoPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_UARTarduinoPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;UARTarduinoPIC.c,66 :: 		lcd_chr_cp (ucRead);
	MOVF        _ucRead+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;UARTarduinoPIC.c,67 :: 		}
L_main6:
;UARTarduinoPIC.c,68 :: 		}
L_main4:
;UARTarduinoPIC.c,69 :: 		}
L_main2:
;UARTarduinoPIC.c,71 :: 		if (Control == 1){   // O PIC (Control = 1) recebe um caracter do Arduino e responde com outro caracter.
	MOVLW       0
	XORWF       _Control+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVLW       1
	XORWF       _Control+0, 0 
L__main14:
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;UARTarduinoPIC.c,72 :: 		if(UART1_Data_Ready()){  // Verifica se um dado foi recebido no buffer
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main8
;UARTarduinoPIC.c,73 :: 		ucRead = UART1_Read(); // Le o dado recebido do buffer.
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _ucRead+0 
;UARTarduinoPIC.c,74 :: 		Delay_ms(50);   // Pausa de 50ms.
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	NOP
	NOP
;UARTarduinoPIC.c,75 :: 		if (ucRead == 'M'){
	MOVF        _ucRead+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_main10
;UARTarduinoPIC.c,76 :: 		lcd_out(1,1,"PIC Receive/Send");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_UARTarduinoPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_UARTarduinoPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;UARTarduinoPIC.c,77 :: 		lcd_out(2,1,"Rec.= ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_UARTarduinoPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_UARTarduinoPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;UARTarduinoPIC.c,78 :: 		lcd_chr_cp (ucRead);
	MOVF        _ucRead+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;UARTarduinoPIC.c,79 :: 		}
L_main10:
;UARTarduinoPIC.c,80 :: 		UART1_Write('P');
	MOVLW       80
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;UARTarduinoPIC.c,81 :: 		lcd_out(2,9,"Send = P");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_UARTarduinoPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_UARTarduinoPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;UARTarduinoPIC.c,82 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	NOP
	NOP
;UARTarduinoPIC.c,83 :: 		}
L_main8:
;UARTarduinoPIC.c,84 :: 		}
L_main7:
;UARTarduinoPIC.c,85 :: 		}
	GOTO        L_main0
;UARTarduinoPIC.c,86 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
