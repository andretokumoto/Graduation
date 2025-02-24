module MEMInstrucoes(reset, pc, opcode, jump, OUTrs, OUTrt, OUTrd, imediato, clock, entradaDeInstrucao,ControleFimDeLeitura, controleSalvaInstrucao, biosEmExecucao, encerrarBios,processoEmExecucao,pc_processo_interrompido,processo_atual);

    input [31:0] pc, entradaDeInstrucao,processo_atual, pc_processo_interrompido;
    input clock, reset;
    input encerrarBios;
    input [1:0] controleSalvaInstrucao,ControleFimDeLeitura;
    output reg [5:0] opcode;
    output reg [4:0] OUTrs, OUTrt, OUTrd;
    output reg [15:0] imediato;
    output reg [25:0] jump;
    output reg biosEmExecucao; // Sinal que indica que a bios está em execução
	 output reg [31:0] processoEmExecucao; 

    reg [31:0] Bios[120:0];
    reg [1:0] executaBios;
    reg [31:0] instrucao;
    reg [31:0] memoria[200:0];
	reg [31:0] cursorDePosicao;//guarda a prosição de começo de pilha para um programa que será carregado para a memInst
	 	
	parameter TAM_BLOCO = 32'd200;//tamanho dos blocos na memoria
		
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
	 
  
    always@(posedge clock or posedge reset)                           
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
						Bios[32'd31] = {6'b011010,5'd30,5'd0,5'd0,11'd0};// movi r30, 0
						Bios[32'd32] = {6'b011010,5'd31,5'd0,5'd0,11'd0};// movi r31, 0
						// lfhd r0  // puxa o SO do HD
						// encerraBios
			//-------------------------------------------------------------------------------------


			//--------entrada de dados---------

			//scpc r20 - armazena pc do processo
			//addi r20,r20,1 -- pc+1
			//in r25 -- entrada de dados do usuario
			//jr r20 - retorna para o processo 

			//----saida de dados----------------

			//scpc r20 - armazena pc do processo
			//addi r20,r20,1 -- pc+1
			//mov r24, rret -- move o valor do registrador de retorno do processo para um registrador de sistema
			//out r24
			//jr r20 - retorna para o processo

			//----- inicia um processo --------

			//movi r22, 11
			//lw r20, 1(r22)    -- puxa o processo a ser iniciado
			//movi r21, 11'd1 // marca processo como em processamento normal
			//sw r21 , 1(r20) //salva estado do processo na lista de processos
			//jump executar processos

			// -------  executar processos --------

			//movi r22, 0 // contador de processos que foram iniciados
			//in r20 // entrada do numero de processos que irão rodar
			//sw r20, 0, rzero // salva na memoria de dados o numero de processos rodando
			//beq r20, rzero // volta para o menu

			//----entrada processo
			//in r21 processo que ira rodar
			//movi r24, 11
			//sw r21, 1(r24) // salva qual processo vai ser 
			//movi r23, 12 //endereço de onde esta o contador de processos
			//lw r22, 1(r23) // puxa o valor do contador
			//addi r22,r22,1 // incrementa contador
			//sw r22 , 1 r23 // salva contador
			//jump inicia processo
			//lw r22, 1(r23) // puxa o valor do contador
			//lw r20, 0(rzero) // puxa numero de processos totais
			//beq r20,r22, escalonador
			//jump entrada processo


			//-------------------------fim gerenciador de processos ----------------------------------------------

			//----------------------------menu do SO---------------------------------------------------------------
			//led menu
			//in r20 // opçao
			//movi r21 , 1 //  //listar
			//movi r22 , 2 // criar
			//movi r23 , 3  // editar
			//movi r24 , 4 // deletar
			//beq rzero, r20, +    // executar
			//beq r21, r20, + 
			//beq r22, r20, +
			//beq r23, r20, +
			//beq r24, r20, +
			//jump menu
			//jump gerenciador de processos
			//jump listar diretórios
			//jump criar
			//jump editar
			//jump deletar

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