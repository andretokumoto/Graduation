// Exemplo: PushButton_Display7seg

void main(){
                          //  "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"
   unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
   /* Variavel do tipo vetor que armazena os valores correspondentes ao numero
   para ser mostrado no display de 7 segmentos */

   unsigned char ucStatus_inc; // Variavel de travamento do incremento.
   unsigned char ucStatus_dec; // Variavel de travamento do decremento.
   unsigned int  uiContador;   // Variavel de armazenamento do contador.
   unsigned int  uiValor;      // Variavel auxiliar para exibido do contador.

   ADCON1 = 0x0f;       // Configura todos canais como Digital.

   TRISB.RB0=1;         // Define o pino RB0 do PORTB como entrada.
   TRISB.RB1=1;         // Define o pino RB1 Do PORTB como entrada.

   TRISA.RA2=0;         // Define o pino RA2 do PORTA como saida(Selecao Display 1).
   TRISA.RA3=0;         // Define o pino RA3 do PORTA como saida(Selecao Display 2).
   TRISA.RA4=0;         // Define o pino RA4 do PORTA como saida(Selecao Display 3).
   TRISA.RA5=0;         // Define o pino RA5 do PORTA como saida(Selecao Display 4).

   TRISD = 0;           // Define todos os pinos Do PORTD como saida.

   ucStatus_inc=0;      // Inicializa a variavel com o valor 0.
   ucStatus_dec=0;      // Inicializa a variavel com o valor 0.
   uiContador=0;        // Inicializa a variavel com o valor 0.

   while(1){            // Aqui definimos uma condicao sempre verdadeira como parametro,
			//portanto todo o bloco sera repetido indefinidamente.

      // Le Tecla E Incrementa Contador
      if((PORTB.RB0==0)&&(ucStatus_inc==0)){    // Incrementa somente uma vez quando a
						// tecla for pressionada.
         ucStatus_inc=1;        // Variavel de travamento do incremento.
         uiContador++;          // Esse operador aritmetico(++) realiza o mesmo que
				// variavel = variavel + 1.
         if(uiContador>9999){ 	// Define o valor maximo a ser mostrado no displays como 9999.
            uiContador=9999;
         }
      }
      if((PORTB.RB0==1)&&(ucStatus_inc==1)){   	// Volta a disponibilizar a opcao de
						//incremento quando a tecla for solta.
         ucStatus_inc=0;
      }
      // Le tecla e decrementa contador.
      if((PORTB.RB1==0)&&(ucStatus_dec==0)){   	// Decrementa somente uma vez quando a
						//tecla for pressionada.
         ucStatus_dec=1;        // Variavel de travamento do decremento.
         uiContador--;          // Esse operador aritmetico(--) realiza o mesmo que
				// variavel = variavel - 1.
         if(uiContador>9999){   // Define o valor maximo quando ocorrer a transicao
				// (decremento) de 0 para 9999.
            uiContador=9999;
         }
      }
      if((PORTB.RB1==1)&&(ucStatus_dec==1)){    // Volta a disponibilizar a opcao de
						// decremento quando a tecla for solta.
         ucStatus_dec=0;
      }

      uiValor = uiContador;     // Coloca o conteudo da variavel do contador na
				// variavel auxiliar.

      // Mostra valor da unidade:
      PORTD = ucMask[uiValor%10];        // Pega modulo da divisao por 10 e coloca o
					 // valor no PORTD.
      PORTA.RA5 = 1;                     // Liga o transistor associado ao display 1.
      Delay_ms(2);                       // Delay para escrita no display.
      PORTA.RA5 = 0;                     // Desliga o transistor associado ao display 1.
      uiValor/=10;                       // Divide variavel por 10 para definir a dezena.
      // Mostra valor da dezena:
      PORTD = ucMask[uiValor%10];
      PORTA.RA4 = 1;
      Delay_ms(2);
      PORTA.RA4 = 0;
      uiValor/=10;
      // Mostra valor da centena:
      PORTD = ucMask[uiValor%10];
      PORTA.RA3 = 1;
      Delay_ms(2);
      PORTA.RA3 = 0;
      uiValor/=10;
      // Mostra valor do milhar:
      PORTD = ucMask[uiValor%10];
      PORTA.RA2 = 1;
      Delay_ms(2);
      PORTA.RA2 = 0;
   }
}