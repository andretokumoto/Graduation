
_main:

;ExemploLCD.c,36 :: 		void main()
;ExemploLCD.c,38 :: 		ADCON1  = 0x0F;                           //Configura os pinos como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;ExemploLCD.c,40 :: 		Lcd_Init();                               //Inicializa modulo LCD
	CALL        _Lcd_Init+0, 0
;ExemploLCD.c,41 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                 //Apaga cursor
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;ExemploLCD.c,42 :: 		Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;ExemploLCD.c,44 :: 		while(1)
L_main0:
;ExemploLCD.c,47 :: 		lcd_out(1,3,"EU SOU O");    // descomente essa funcao
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_ExemploLCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_ExemploLCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;ExemploLCD.c,48 :: 		lcd_out(2,4,"BATMAN");     // descomente essa funcao
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_ExemploLCD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_ExemploLCD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;ExemploLCD.c,49 :: 		}
	GOTO        L_main0
;ExemploLCD.c,50 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_helloWorldPIC18:

;ExemploLCD.c,52 :: 		void helloWorldPIC18()    // Comente essa funcao
;ExemploLCD.c,54 :: 		lcd_chr(1,3,'H');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       72
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;ExemploLCD.c,55 :: 		lcd_chr_cp ('e');
	MOVLW       101
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,56 :: 		lcd_chr_cp ('l');
	MOVLW       108
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,57 :: 		lcd_chr_cp ('l');
	MOVLW       108
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,58 :: 		lcd_chr_cp ('o');
	MOVLW       111
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,59 :: 		lcd_chr_cp (' ');
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,60 :: 		lcd_chr_cp ('W');
	MOVLW       87
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,61 :: 		lcd_chr_cp ('o');
	MOVLW       111
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,62 :: 		lcd_chr_cp ('r');
	MOVLW       114
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,63 :: 		lcd_chr_cp ('l');
	MOVLW       108
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,64 :: 		lcd_chr_cp ('d');
	MOVLW       100
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,66 :: 		lcd_chr(2,2,'P');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       80
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;ExemploLCD.c,67 :: 		lcd_chr_cp ('I');
	MOVLW       73
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,68 :: 		lcd_chr_cp ('C');
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,69 :: 		lcd_chr_cp ('1');
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,70 :: 		lcd_chr_cp ('8');
	MOVLW       56
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,71 :: 		lcd_chr_cp ('F');
	MOVLW       70
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,72 :: 		lcd_chr_cp ('4');
	MOVLW       52
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,73 :: 		lcd_chr_cp ('5');
	MOVLW       53
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,74 :: 		lcd_chr_cp ('2');
	MOVLW       50
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,75 :: 		lcd_chr_cp ('0');
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;ExemploLCD.c,76 :: 		}
L_end_helloWorldPIC18:
	RETURN      0
; end of _helloWorldPIC18
