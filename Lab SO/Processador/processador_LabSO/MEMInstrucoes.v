module MEMInstrucoes(reset, pc, opcode, jump, OUTrs, OUTrt, OUTrd, imediato, clock/*, entradaDeInstrucao,ControleFimDeLeitura, controleSalvaInstrucao*/, biosEmExecucao, encerrarBios);

    input [31:0] pc/*, entradaDeInstrucao*/;
    input clock, reset;
    input encerrarBios;
    /*input [1:0] controleSalvaInstrucao,ControleFimDeLeitura;*/
    output reg [5:0] opcode;
    output reg [4:0] OUTrs, OUTrt, OUTrd;
    output reg [15:0] imediato;
    output reg [25:0] jump;
    output reg biosEmExecucao; // Sinal que indica que a bios está em execução
	

    reg [31:0] Bios[120:0];
    reg [1:0] executaBios;
    reg [31:0] instrucao;
    reg [31:0] memoria[200:0];
	 reg [31:0] cursorDePosicao;//guarda a prosição de começo de pilha para um programa que será carregado para a memInst
	 	
	parameter TAM_BLOCO = 32'd200;//tamanho dos blocos na memoria
	
	
	parameter add=6'b000000,addi=6'b000001,sub=6'b000010,subi=6'b000011,mult=6'b000100;
	parameter j=6'b010001,jumpR=6'b010010,jal=6'b010011,beq=6'b010100,bne=6'b010101,blt=6'b010110;
	parameter lw=6'b010111,sw=6'b011000,multi=6'b000101,div=6'b000110,divi=6'b000111,rdiv=6'b001000;
	parameter mov=6'b011001,movi=6'b011010,mfhi=6'b011011,mflo=6'b011100;
	parameter in=6'b011101,out=6'b011110,fim=6'b011111,spc = 6'b100110;
	parameter scpc = 6'b100001, scrg=6'b100010, cproc = 6'b100011;
	
	
		
    // verificar se a bios está em execução
    always @(*) begin
        if(executaBios == 2'b01) begin
            biosEmExecucao = 1'b1;
        end
        else begin
            biosEmExecucao = 1'b0;
        end
    end

    //selecionar a instrução (BIOS ou memória principal)
    always @(pc) begin
        if(executaBios == 2'b01) begin
            instrucao = Bios[pc];
        end
        else begin
            instrucao = memoria[pc];
        end
    end

	 //funçao de puxar algoritmo do hd para memoria de instruções
	/*always@(negedge clock)
		begin
			
			//puxar do hd para memória - salva na memória de instrução
			if(controleSalvaInstrucao == 2'b01 && ControleFimDeLeitura == 2'b00) 
				begin
					memoria[cursorDePosicao] = entradaDeInstrucao;
				end

			if(ControleFimDeLeitura == 2'b01)
				begin
					cursorDePosicao = cursorDePosicao + TAM_BLOCO;//os blocos de processos são fixos em 150 posições
				end
			
			
		end*/
	 
  
    always@(negedge clock or posedge reset)                           
    begin 
        if(reset == 1'b1) begin
            executaBios <= 2'b01; // Executa a bios
				cursorDePosicao = 15'd0;//zera cursor
        end
        else if(encerrarBios == 1'b1) begin
            executaBios <= 2'b00; // Encerra a bios
        end

		  //puxar do hd para memória - atulização de cursor
		/*if(controleSalvaInstrucao == 2'b01) 
				begin
					cursorDePosicao = cursorDePosicao + 32'd1;
				end*/
			


			//bios ---------------------------------------------------------------			
						//lfhd puxa uma programa 
						Bios[32'd1] = {6'b011010,5'd0,5'd0,5'd0,11'd0};// movi r0, 0
						Bios[32'd2] = {6'b011010,5'd1,5'd0,5'd0,11'd0};// movi r1, 0
						Bios[32'd3] = {6'b011010,5'd2,5'd0,5'd0,11'd0};// movi r2, 0
						Bios[32'd4] = {6'b011010,5'd3,5'd0,5'd0,11'd0};// movi r3, 0
						Bios[32'd5] = {6'b011010,5'd4,5'd0,5'd0,11'd0};// movi r4, 0
						Bios[32'd6] = {6'b011010,5'd5,5'd0,5'd0,11'd0};// movi r5, 0
						Bios[32'd7] = {6'b011010,5'd6,5'd0,5'd0,11'd0};// movi r6, 0
						Bios[32'd8] = {6'b011010,5'd7,5'd0,5'd0,11'd0};// movi r7, 0
						Bios[32'd9] = {6'b011010,5'd8,5'd0,5'd0,11'd0};// movi r8, 0
						Bios[32'd10] = {6'b011010,5'd9,5'd0,5'd0,11'd0};// movi r9, 0
						Bios[32'd11] = {6'b011010,5'd10,5'd0,5'd0,11'd0};// movi r10, 0
						Bios[32'd12] = {6'b011010,5'd11,5'd0,5'd0,11'd0};// movi r11, 0
						Bios[32'd13] = {6'b011010,5'd12,5'd0,5'd0,11'd0};// movi r12, 0
						Bios[32'd14] = {6'b011010,5'd13,5'd0,5'd0,11'd0};// movi r13, 0
						Bios[32'd15] = {6'b011010,5'd14,5'd0,5'd0,11'd0};// movi r14, 0
						Bios[32'd16] = {6'b011010,5'd15,5'd0,5'd0,11'd0};// movi r15, 0
						Bios[32'd17] = {6'b011010,5'd16,5'd0,5'd0,11'd0};// movi r16, 0
						Bios[32'd18] = {6'b011010,5'd17,5'd0,5'd0,11'd0};// movi r17, 0
						Bios[32'd19] = {6'b011010,5'd18,5'd0,5'd0,11'd0};// movi r18, 0
						Bios[32'd20] = {6'b011010,5'd19,5'd0,5'd0,11'd0};// movi r19, 0
						Bios[32'd21] = {6'b011010,5'd20,5'd0,5'd0,11'd0};// movi r20, 0
						Bios[32'd22] = {6'b011010,5'd21,5'd0,5'd0,11'd0};// movi r21, 0
						Bios[32'd23] = {6'b011010,5'd22,5'd0,5'd0,11'd0};// movi r22, 0
						Bios[32'd24] = {6'b011010,5'd23,5'd0,5'd0,11'd0};// movi r23, 0
						Bios[32'd25] = {6'b011010,5'd24,5'd0,5'd0,11'd0};// movi r24, 0
						Bios[32'd26] = {6'b011010,5'd25,5'd0,5'd0,11'd0};// movi r25, 0
						Bios[32'd27] = {6'b011010,5'd26,5'd0,5'd0,11'd0};// movi r26, 0
						Bios[32'd28] = {6'b011010,5'd27,5'd0,5'd0,11'd0};// movi r27, 0
						Bios[32'd29] = {6'b011010,5'd28,5'd0,5'd0,11'd0};// movi r28, 0
						Bios[32'd30] = {6'b011010,5'd29,5'd0,5'd0,11'd0};// movi r29, 0
						Bios[32'd31] = {6'b011010,5'd30,5'd0,5'd0,11'd1};// movi r30, 1
						Bios[32'd32] = {6'b011010,5'd31,5'd0,5'd0,11'd10};// movi r31, 10
						
						Bios[32'd33] = {6'b011000,5'd31,5'd0,5'd0,11'd0};//sw rzero, 200(r30)
						Bios[32'd34] = {6'b011010,5'd31,5'd0,5'd0,11'd0};//addi r30,r30,1
						Bios[32'd35] = {6'b011010,5'd31,5'd0,5'd0,11'd0};//beq r30,r31, +2
						Bios[32'd36] = {6'b011010,26'd33};					//jump 33
						Bios[32'd37] = {6'b011010,5'd0,5'd0,5'd0,11'd0};// encerraBios
			//-------------------------------------------------------------------------------------
//---------------------------SO---------------------------------------------------
			//jump menu
			//------------------------------------mudança contexto-----------
			//-----------salva contexto--------
			//scpc r20 -- salva o contexto do pc - pc em um registrador no escalonador
			//movi r21, 13
			//lw r22, 1(r20)//puxa numero do processo atual
			//multi r22, r22, 200
			//sw r20, 1(r22)//salva contexto do pc
			//scrg r1 , 1--- salva o contexto dos registradores
			//scrg r2 , 2
			//scrg r3 , 3
			//scrg r4 , 4
			//scrg r5
			//scrg r6
			//scrg r7
			//scrg r8
			//scrg r9
			//scrg r10
			//scrg r11
			//scrg r12
			//scrg r13
			//scrg r14
			//scrg r15
			//scrg r16
			//scrg r17
			//scrg r18
			//scrg r19
			//scrg r26
			//scrg r27
			//scrg r28
			//scrg r29
			//scrg r30
			//scrg r31
			//jump escalonador

			//-----------carrega contexto------
			//movi r20, 13
			//lw r21, 1(r20)//puxa numero do processo atual
			//multi r21, r21, 200
			//lw r22, 1(r21)//pega pc do processo atual
			//--- puxa o contexto dos registradores

			//movi r20, 1
			//add r21,r21,r20
			//lw r1, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r2, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r3, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r4, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r5, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r6, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r7, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r8, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r9, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r10, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r11, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r12, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r13, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r14, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r15, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r16, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r17, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r18, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r19, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r26, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r27, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r28, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r29, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//lw r30, 1(r21)//pega o contexto do reg na mem de dados
			//addi r21,1

			//mov r31,r25 // manda o dado lido para o processo
			//movi r23, 13
			//lw r24, 1(r23)
			//cproc, r24 -- comando para mudar o processo
			//jr r22 // retorna o pocessamento do processo
			//------------------------------fim mudança de contexto---------------------------
			
			//-----interrupção para entrada de dados ------ 
			//cproc,rzero --- muda processo para o SO
			//movi r20,13 // pega numero do processo
			//movi r21, 2 // valor de status correspondente a espera por io
			//lw r24, 1(r20)//pega o processo interrompidoS
			//sw r21, 1(r24) // muda status do processo
			//movi r21, 14  // posição com contador de processos io

			//movi r20,15
			//lw r23, 1(r20) //inicio da fila de processos IO
			//add r23, r23,r22 // pega a proxima posição da fila
			
			//sw r24 , 1(r23) //salva processo na fila
			//addi r22, 1 //incrementa o numero de processos io
			//sw r22 , 1(r21)//atualiza numero de processos io
			//movi r21, 15 // ponteiro para inicio da fila
			//sw r23, 1(r21)//salva o ponteiro

			//jump escalonador
			
			//-------------- escalonador --------------
			//cproc,rzero
			//movi r20 , 1 // inicia o contador
			//movi r21 , 1 // estado processo como 01
			//lw r22, 0(rzero) //numero de processos ativos
			//beq r22 , rzero , volta menu
			//movi r22, 11 // condição de saida do laço - lista toda percorrida
			//movi r23,1
			//lw r25, 13(r23)

		//LO - procura um processo interrompido que esteja com processamento normal(não IO)

			//beq r22 , r20, L1 // fim do laço
			//beq r25,r20, // incrementa index --- e o processo atual
			//lw r24, 1(r20) // pega o estado naquele index
			//beq r24,r21, muda processo atual
			//addi r20,1//incrementa contador
			//jump LO
			
			//---muda processo atual
			//movi r21,13
			//sw r20, 1(r21)//muda o processo em execução
			//jump muda para o processo

		//L1 --- ve se o processo atual esta em processamento normal(Não IO)
			//movi r20,1 // estado normal
			//lw r21, 13(r20) // pega o processo atual
			//lw r22, 1(r21)//pega o estado do processo
			//beq r22,r20, muda para o processo
			//jump L2

		//L2 - pega uma instrução esperando IO
			//movi r21, 14 
			//lw r22, 1(r21)//numero processo esperando io
			//beq r22,rzero, volta menu
			//movi r21, 15
			//lw r22, 1(r21) // o inicio da fila de processos IO 
			//lw r24, 1(r22)//pega o processo

			// -- muda para o processo
			//movi r25, 13 //posição qu salva processo atual
			//sw r24, 1(r25) //muda o processo atual
			//movi r20,1
			//sw r20, 1(r24)//muda status do processo

			//-----desenfila
			//movi r21, 14 //decrementa contador
			//lw r22, 1(r21)
			//subi r22,1
			//sw r22, 1(r21)

			//movi r21, 15//muda ponteiro
			//lw r22, 1(r21)
			//addi r22,1 //pega o proximo da fila			
			//sw r22, 1(r21)

			//jump entrada de dados


		// -- muda para o processo

			//jump carrega contexto


			//------------fim escalonador --------------

			//-----finalizar um processo------
			//cproc,rzero
			//movi r20,13
			//lw r21, 1(r20) // pega o processo atual
			//mov r22 , rzero
			//sw r22, 1(r21)//marca o processo como inativo
			//lw r23, 0(rzero)//numero de processos rodando
			//subi r23, 1 // decrementa o numero de processos ativos
			//sw r23, 0(rzero)//salva novo numero de processos rodando
			//jump escalonador

			//--------entrada de dados---------

			//in r25 -- entrada de dados do usuario
			//jump carrega contexto

			//----saida de dados----------------

			//scpc r20 - armazena pc do processo
			//addi r20,r20,1 -- pc+1
			//mov r24, rret -- move o valor do registrador de retorno do processo para um registrador de sistema
			//movi r21,16
			//sw r24, 1(r21)
			//out 1(r21)
			//jr r20 - retorna para o processo

			//----- inicia um processo --------
		
			//movi r22, 11
			//lw r20, 1(r22)    -- puxa o processo a ser iniciado
			//movi r21, 11'd1 // marca processo como em processamento normal
			//sw r21 , 1(r20) //salva estado do processo na lista de processos
			//mov r23, r20 
			//multi r23,r23,200 //pc(zero) relativo
			//sw r23, 1(r23)
			//jump entrada de novo processo

			// -------  executar processos --------
			//ledmenuoff
			//movi r22, 0 // contador de processos que foram iniciados
			//in r20 // entrada do numero de processos que irão rodar
			//sw r20, 0, rzero // salva na memoria de dados o numero de processos rodando
			//beq r20, rzero // volta para o menu(sem processos para rodar)

						//----entrada processo
			//in r21 processo que ira rodar
			//movi r24, 11
			//sw r21, 1(r24) // salva qual processo vai ser executado
			//movi r23, 12 //endereço de onde esta o contador de processos
			//lw r22, 1(r23) // puxa o valor do contador de processos iniciados
			//addi r22,r22,1 // incrementa contador
			//sw r22 , 1(r23) // salva contador
			//jump inicia processo

//---entrada de novo processo
			//movi r23, 12 //endereço de onde esta o contador de processos
			//lw r22, 1(r23) // puxa o valor do contador
			//lw r20, 0(rzero) // puxa numero de processos totais
			//beq r20,r22, escalonador
			//jump entrada processo


			//-------------------------fim gerenciador de processos ----------------------------------------------

			//----------------------------menu do SO---------------------------------------------------------------
			//ledmenuon
			//cproc,rzero
			//in r20 // opçao
			//movi r21 , 1 //  //listar
			//movi r22 , 2 // criar
			//movi r23 , 3  // editar
			//movi r24 , 4 // deletar
			//beq rzero, r20, +5  // executar
			//beq r21, r20, + 
			//beq r22, r20, +
			//beq r23, r20, +
			//beq r24, r20, +
			//jump menu
			//jump executar processos

			// ------------------------------------fim do menu-----------------------------------------

    end
	 
	 
	     always @(*) begin
        opcode    = instrucao[31:26];
        jump      = instrucao[25:0];
        OUTrd     = instrucao[25:21];
        OUTrs     = instrucao[20:16];
        OUTrt     = instrucao[15:11];
        imediato  = instrucao[10:0];
    end


endmodule