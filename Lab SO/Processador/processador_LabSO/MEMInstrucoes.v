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
//memoria de instrucoes
			//memoria[32'd0] = 
			//jump menu
			//------------------------------------mudança contexto-----------
			//-----------salva contexto--------
			//scpc r20 -- salva o contexto do pc - pc em um registrador no escalonador
			//sw r20
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
			//-----------retorna contexto------
			//lcpc r21
			//lcrg r1 , 1--- puxa o contexto dos registradores
			//lcrg r2 , 2
			//lcrg r3 , 3
			//lcrg r4 , 4 
			//lcrg r5
			//lcrg r6
			//lcrg r7
			//lcrg r8
			//lcrg r9
			//lcrg r10
			//lcrg r11
			//lcrg r12
			//lcrg r13
			//lcrg r14
			//lcrg r15
			//lcrg r16
			//lcrg r17
			//lcrg r18
			//lcrg r19
			//lcrg r26
			//lcrg r27
			//lcrg r28
			//lcrg r29
			//lcrg r30
			//lcrg r31
			//jr r21 // retorna o pocessamento do processo
			//------------------------------fim mudança de contexto---------------------------

			//--------------------------gerenciamento de processos---------------------------------------------

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

			//----- criar um processo --------

			//lw r20,   -- puxa numero de processos atual

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