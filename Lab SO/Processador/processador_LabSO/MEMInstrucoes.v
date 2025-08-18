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
	
	
	 reg [5:0] OP_processoHD;
    reg [31:0] Bios[120:0];
    reg [1:0] executaBios;
    reg [31:0] instrucao;
    reg [31:0] memoria[3000:0];
	 //reg [31:0] cursorDePosicao;//guarda a prosição de começo de pilha para um programa que será carregado para a memInst
	 	
	parameter TAM_BLOCO = 32'd300;//tamanho dos blocos na memoria
	parameter endEscalonador = 26'd106, endMenu = 26'd245,entradaNovoProcesso = 26'd265,entradaProcesso = 26'd255,iniciaProcesso = 26'd237; //pc do escalonador
	
	parameter add=6'b000000,addi=6'b000001,sub=6'b000010,subi=6'b000011,mult=6'b000100;
	parameter j=6'b010001,jumpR=6'b010010,jal=6'b010011,beq=6'b010100,bne=6'b010101,blt=6'b010110;
	parameter lw=6'b010111,sw=6'b011000,multi=6'b000101,div=6'b000110,divi=6'b000111,rdiv=6'b001000;
	parameter mov=6'b011001,movi=6'b011010,mfhi=6'b011011,mflo=6'b011100;
	parameter in=6'b011101,out=6'b011110,fim=6'b011111,spc = 6'b100110;
	parameter scpc = 6'b100001, scrg=6'b100010, cproc = 6'b100011, encBios = 6'b100100 ,led = 6'b100101;
	
	parameter R20 = 5'd20,R21 = 5'd21,R22 = 5'd22,R23 = 5'd23,R24 = 5'd24,R25 = 5'd25 ,RZERO = 5'd0;

	

    //selecionar a instrução (BIOS ou memória principal)
    always @(pc) begin
            instrucao = memoria[pc];
    end


  
    always@(negedge clock || reset)                           
    begin 



		//bios ---------------------------------------------------------------			
			memoria[32'd0] = {cproc,26'd0};					  //cproc rzero
			memoria[32'd1] = {6'b011010,5'd0,5'd0,5'd0,11'd0};// movi r0, 0
			memoria[32'd2] = {6'b011010,5'd1,5'd0,5'd0,11'd0};// movi r1, 0
			memoria[32'd3] = {6'b011010,5'd2,5'd0,5'd0,11'd0};// movi r2, 0
			memoria[32'd4] = {6'b011010,5'd3,5'd0,5'd0,11'd0};// movi r3, 0
			memoria[32'd5] = {6'b011010,5'd4,5'd0,5'd0,11'd0};// movi r4, 0
			memoria[32'd6] = {6'b011010,5'd5,5'd0,5'd0,11'd0};// movi r5, 0
			memoria[32'd7] = {6'b011010,5'd6,5'd0,5'd0,11'd0};// movi r6, 0
			memoria[32'd8] = {6'b011010,5'd7,5'd0,5'd0,11'd0};// movi r7, 0
			memoria[32'd9] = {6'b011010,5'd8,5'd0,5'd0,11'd0};// movi r8, 0
			memoria[32'd10] = {6'b011010,5'd9,5'd0,5'd0,11'd0};// movi r9, 0
			memoria[32'd11] = {6'b011010,5'd10,5'd0,5'd0,11'd0};// movi r10, 0
			memoria[32'd12] = {6'b011010,5'd11,5'd0,5'd0,11'd0};// movi r11, 0
			memoria[32'd13] = {6'b011010,5'd12,5'd0,5'd0,11'd0};// movi r12, 0
			memoria[32'd14] = {6'b011010,5'd13,5'd0,5'd0,11'd0};// movi r13, 0
			memoria[32'd15] = {6'b011010,5'd14,5'd0,5'd0,11'd0};// movi r14, 0
			memoria[32'd16] = {6'b011010,5'd15,5'd0,5'd0,11'd0};// movi r15, 0
			memoria[32'd17] = {6'b011010,5'd16,5'd0,5'd0,11'd0};// movi r16, 0
			memoria[32'd18] = {6'b011010,5'd17,5'd0,5'd0,11'd0};// movi r17, 0
			memoria[32'd19] = {6'b011010,5'd18,5'd0,5'd0,11'd0};// movi r18, 0
			memoria[32'd20] = {6'b011010,5'd19,5'd0,5'd0,11'd0};// movi r19, 0
			memoria[32'd21] = {6'b011010,5'd20,5'd0,5'd0,11'd0};// movi r20, 0
			memoria[32'd22] = {6'b011010,5'd21,5'd0,5'd0,11'd0};// movi r21, 0
			memoria[32'd23] = {6'b011010,5'd22,5'd0,5'd0,11'd0};// movi r22, 0
			memoria[32'd24] = {6'b011010,5'd23,5'd0,5'd0,11'd0};// movi r23, 0
			memoria[32'd25] = {6'b011010,5'd24,5'd0,5'd0,11'd0};// movi r24, 0
			memoria[32'd26] = {6'b011010,5'd25,5'd0,5'd0,11'd0};// movi r25, 0
			memoria[32'd27] = {6'b011010,5'd26,5'd0,5'd0,11'd0};// movi r26, 0
			memoria[32'd28] = {6'b011010,5'd27,5'd0,5'd0,11'd0};// movi r27, 0
			memoria[32'd29] = {6'b011010,5'd28,5'd0,5'd0,11'd0};// movi r28, 0
			memoria[32'd30] = {6'b011010,5'd29,5'd0,5'd0,11'd0};// movi r29, 0
			memoria[32'd31] = {6'b011010,5'd30,5'd0,5'd0,11'd1};// movi r30, 1
			memoria[32'd32] = {6'b011010,5'd31,5'd30,5'd30,11'd10};//movi r31 , 10
			
			//inicia os status dos processos
			memoria[32'd33] = {sw,5'd0,5'd30,RZERO,11'd1};//sw rzero,30, 1(r30)
			memoria[32'd34] = {addi,5'd30,5'd30,5'd30,11'd1};//addi r30,r30,1
			memoria[32'd35] = {beq,5'd0,5'd30,5'd31,11'd2};//beq r30,r31, pc+2
			memoria[32'd36] = {j,26'd33};					//jump 33
			
			//-------------------------------------------------------------------------------------
//---------------------------SO---------------------------------------------------
	

			memoria[32'd37] = {j,endMenu};//jump menu
		//------------------------------------mudança contexto-----------
			//-----------salva contexto--------
			/*memoria[32'd38] = {cproc,RZERO,RZERO,RZERO,11'd0};//muda processo para SO
   		memoria[32'd39] = {scpc,R20,21'd0};//scpc r20 -- salva o contexto do pc - pc em um registrador no escalonador
			memoria[32'd40] = {movi,R21,RZERO,RZERO,11'd13};//movi r21, 13
			memoria[32'd41] = {lw,R22,R20,RZERO,11'd1};//lw r22, 1(r20)//puxa numero do processo atual
			memoria[32'd42] = {multi,R22,R22,R22,11'd300};//multi r22, r22, 200
			memoria[32'd43] = {sw,RZERO,R22,R20,11'd1};//sw r20, 1(r22)//salva contexto do pc
			memoria[32'd44] = {movi,R23,RZERO,RZERO,11'd1}; //movi r3 , 1			
			memoria[32'd45] = {sw,RZERO,R23,5'd1,11'd1}; //sw , r1 , 1(r23)
			memoria[32'd46] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd47] = {sw,RZERO,R23,5'd2,11'd1}; //sw , r2 , 1(r23)
			memoria[32'd48] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd49] = {sw,RZERO,R23,5'd3,11'd1}; //sw , r3 , 1(r23)
			memoria[32'd50] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd51] = {sw,RZERO,R23,5'd4,11'd1}; //sw , r4 , 1(r23)
			memoria[32'd52] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd53] = {sw,RZERO,R23,5'd5,11'd1}; //sw , r5 , 1(r23)
			memoria[32'd54] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd55] = {sw,RZERO,R23,5'd6,11'd1}; //sw , r6 , 1(r23)
			memoria[32'd56] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd57] = {sw,RZERO,R23,5'd7,11'd1}; //sw , r7 , 1(r23)
			memoria[32'd58] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd59] = {sw,RZERO,R23,5'd8,11'd1}; //sw , r8 , 1(r23)
			memoria[32'd60] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd61] = {sw,RZERO,R23,5'd9,11'd1}; //sw , r9 , 1(r23)
			memoria[32'd62] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd63] = {sw,RZERO,R23,5'd10,11'd1}; //sw , r10 , 1(r23)
			memoria[32'd64] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd65] = {sw,RZERO,R23,5'd11,11'd1}; //sw , r11 , 1(r23)
			memoria[32'd66] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd67] = {sw,RZERO,R23,5'd12,11'd1}; //sw , r12 , 1(r23)
			memoria[32'd68] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd69] = {sw,RZERO,R23,5'd13,11'd1}; //sw , r13 , 1(r23)
			memoria[32'd70] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd71] = {sw,RZERO,R23,5'd14,11'd1}; //sw , r14 , 1(r23)
			memoria[32'd72] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd73] = {sw,RZERO,R23,5'd15,11'd1}; //sw , r15 , 1(r23)
			memoria[32'd74] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd75] = {sw,RZERO,R23,5'd16,11'd1}; //sw , r16 , 1(r23)
			memoria[32'd77] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd78] = {sw,RZERO,R23,5'd17,11'd1}; //sw , r17 , 1(r23)
			memoria[32'd79] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd80] = {sw,RZERO,R23,5'd18,11'd1}; //sw , r18 , 1(r23)
			memoria[32'd81] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd82] = {sw,RZERO,R23,5'd19,11'd1}; //sw , r19 , 1(r23)
			memoria[32'd83] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd84] = {sw,RZERO,R23,5'd26,11'd1}; //sw , r26 , 1(r23)
			memoria[32'd85] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd86] = {sw,RZERO,R23,5'd27,11'd1}; //sw , r27 , 1(r23)
			memoria[32'd87] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd88] = {sw,RZERO,R23,5'd28,11'd1}; //sw , r28 , 1(r23)
			memoria[32'd89] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd90] = {sw,RZERO,R23,5'd29,11'd1}; //sw , r29 , 1(r23)
			memoria[32'd91] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1			
			memoria[32'd92] = {sw,RZERO,R23,5'd30,11'd1}; //sw , r30 , 1(r23)
			memoria[32'd93] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1
			memoria[32'd94] = {sw,RZERO,R23,5'd31,11'd1}; //sw , r31 , 1(r23)
			memoria[32'd95] = {addi,R23,R23,R23,11'd1};//addi r23, r23, 1
			
			memoria[32'd96] = {j,endEscalonador};		   //jump escalonador


			//-----------carrega contexto------
			memoria[32'd97] = {movi,R20,RZERO,RZERO,11'd13};//movi r20, 13
			memoria[32'd98] = {lw,R21,R20,RZERO,11'd1};//lw r21, 1(r20)//puxa numero do processo atual
			memoria[32'd99] = {multi,R21,R21,RZERO,11'd300};//multi r21, r21, 200
			memoria[32'd100] = {lw,R22,R21,RZERO,11'd1};//lw r22, 1(r21)//pega pc do processo atual
			//--- puxa o contexto dos registradores

			memoria[32'd101] = {movi,R20,RZERO,RZERO,11'd1};//movi r20, 1
			memoria[32'd102] = {add,R21,R21,R20,11'd0};//add r21,r21,r20

			//pega o contexto do reg na mem de dados
			memoria[32'd103] = {lw,5'd1,R21,RZERO,11'd1};//lw r1, 1(r21)
			memoria[32'd104] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd105] = {lw,5'd2,R21,RZERO,11'd1};//lw r2, 1(r21)
			memoria[32'd106] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd107] = {lw,5'd3,R21,RZERO,11'd1};//lw r3, 1(r21)
			memoria[32'd108] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd109] = {lw,5'd4,R21,RZERO,11'd1};//lw r4, 1(r21)
			memoria[32'd110] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd111] = {lw,5'd5,R21,RZERO,11'd1};//lw r5, 1(r21)
			memoria[32'd112] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd113] = {lw,5'd6,R21,RZERO,11'd1};//lw r6, 1(r21)
			memoria[32'd114] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd115] = {lw,5'd7,R21,RZERO,11'd1};//lw r7, 1(r21)
			memoria[32'd116] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd117] = {lw,5'd8,R21,RZERO,11'd1};//lw r8, 1(r21)
			memoria[32'd118] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd119] = {lw,5'd9,R21,RZERO,11'd1};//lw r9, 1(r21)
			memoria[32'd120] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd121] = {lw,5'd10,R21,RZERO,11'd1};//lw r10, 1(r21)
			memoria[32'd122] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd123] = {lw,5'd11,R21,RZERO,11'd1};//lw r11, 1(r21)
			memoria[32'd124] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd124] = {lw,5'd12,R21,RZERO,11'd1};//lw r12, 1(r21)
			memoria[32'd126] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd127] = {lw,5'd13,R21,RZERO,11'd1};//lw r13, 1(r21)
			memoria[32'd128] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd129] = {lw,5'd14,R21,RZERO,11'd1};//lw r14, 1(r21)
			memoria[32'd130] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd131] = {lw,5'd15,R21,RZERO,11'd1};//lw r15, 1(r21)
			memoria[32'd132] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd133] = {lw,5'd16,R21,RZERO,11'd1};//lw r16, 1(r21)
			memoria[32'd134] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd135] = {lw,5'd17,R21,RZERO,11'd1};//lw r17, 1(r21)
			memoria[32'd136] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd137] = {lw,5'd18,R21,RZERO,11'd1};//lw r18, 1(r21)
			memoria[32'd138] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd139] = {lw,5'd19,R21,RZERO,11'd1};//lw r19, 1(r21)
			memoria[32'd140] = {addi,R21,R21,RZERO,11'd5};//addi r21,5
			memoria[32'd141] = {lw,5'd26,R21,RZERO,11'd1};//lw r26, 1(r21)
			memoria[32'd142] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd143] = {lw,5'd27,R21,RZERO,11'd1};//lw r27, 1(r21)
			memoria[32'd144] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd145] = {lw,5'd28,R21,RZERO,11'd1};//lw r28, 1(r21)
			memoria[32'd146] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd147] = {lw,5'd29,R21,RZERO,11'd1};//lw r29, 1(r21)
			memoria[32'd148] = {addi,R21,R21,RZERO,11'd1};//addi r21,1
			memoria[32'd149] = {lw,5'd30,R21,RZERO,11'd1};//lw r30, 1(r21)
			memoria[32'd150] = {addi,R21,R21,RZERO,11'd1};//addi r21,1

			memoria[32'd151] = {mov,5'd31,R25,R25,11'd0};//mov r31,r25 //manda o dado lido para o processo
			memoria[32'd152] = {movi,R23,RZERO,RZERO,11'd13};//movi r23, 13
			memoria[32'd153] = {lw,R24,R23,RZERO,11'd1};//lw r24, 1(r23)
			memoria[32'd154] = {cproc,RZERO,R24,};//cproc, r24 -- comando para mudar o processo
			memoria[32'd155] = {jumpR,RZERO,R22,R22,11'd0};//jr r22 // retorna o pocessamento do processo
			//------------------------------fim mudança de contexto---------------------------
			
			//-----interrupção para entrada de dados ------ 
			memoria[32'd156] = {cproc,26'd0};//cproc,rzero --- muda processo para o SO
			memoria[32'd157] = {movi,R20,RZERO,RZERO,11'd13};//movi r20,13 // pega numero do processo
			memoria[32'd158] = {movi,R21,RZERO,RZERO,11'd2};//movi r21, 2 //valor de status esperando io
			memoria[32'd159] = {lw,R24,R20,R20,11'd1};//lw r24, 1(r20)//pega o processo interrompidoS
			memoria[32'd160] = {sw,RZERO,R24,R21,11'd1};//sw r21, 1(r24) // muda status do processo
			memoria[32'd161] = {movi,R21,RZERO,RZERO,11'd14};//movi r21, 14// posição com contador de processos io
			memoria[32'd162] = {movi,R20,RZERO,RZERO,11'd15};//movi r20,15
			memoria[32'd163] = {lw,R23,R20,RZERO,11'd1};//lw r23, 1(r20) //inicio da fila de processos IO
			memoria[32'd164] ={add,R23,R23,R22,11'd0};//add r23, r23,r22 // pega a proxima posição da fila
			
			memoria[32'd165] = {sw,RZERO,R23,R24,11'd1};//sw r24 , 1(r23) //salva processo na fila
			memoria[32'd166] = {addi,R22,R22,RZERO,11'd1};//addi r22, 1 //incrementa o numero de processos io
			memoria[32'd167] = {sw,RZERO,R21,R22,11'd1};//sw r22 , 1(r21)//atualiza numero de processos io
			memoria[32'd168] = {movi,R21,RZERO,RZERO,11'd15};//movi r21, 15 // ponteiro para inicio da fila
			memoria[32'd169] = {sw,RZERO,R21,R23,11'd1};//sw r23, 1(r21)//salva o ponteiro
			memoria[32'd170] = {j,endEscalonador}; //jump escalonador
			
			//-------------- escalonador --------------
			memoria[32'd171] = {cproc,26'd0};//cproc,rzero
			memoria[32'd172] = {movi,R20,RZERO,RZERO,11'd1};//movi r20 , 1 // inicia o contador
			memoria[32'd173] = {movi,R21,RZERO,RZERO,11'd1};//movi r21 , 1 // estado processo como 01
			memoria[32'd174] = {lw,R22,RZERO,RZERO,11'd0};//lw r22, 0(rzero) //numero de processos ativos
			memoria[32'd175] = {beq,RZERO,R22,RZERO,11'd5};//beq r22 , rzero , volta menu , pc+5
			memoria[32'd176] = {movi,R22,RZERO,RZERO,11'd11};//movi r22, 11 // condição de saida do laço 
			memoria[32'd177] = {movi,R23,RZERO,RZERO,11'd1};//movi r23,1
			memoria[32'd178] = {lw,R25,R23,RZERO,11'd13};//lw r25, 13(r23)
			memoria[32'd179] = {j,26'd116};//jump L0
			memoria[32'd180] = {j,endMenu};//jump menu
		//LO - procura um processo interrompido que esteja com processamento normal(não IO)

			memoria[32'd181] = {beq,RZERO,R22,R20,11'd6};//beq r22 , r20, L1 , pc+6// fim do laço
			memoria[32'd182] = {beq,RZERO,R25,R20,11'd2};//beq r25,r20, pc+2 // incrementa index --- e o processo atual
			memoria[32'd183] = {lw,R24,R20,RZERO,11'd1};//lw r24, 1(r20) // pega o estado naquele index
			memoria[32'd184] = {beq,R24,R21,RZERO,11'd3};//beq r24,r21, muda processo atual pc+3
			memoria[32'd185] = {addi,R20,R20,RZERO,11'd1};//addi r20,1//incrementa contador
			memoria[32'd186] = {j,26'd116};//jump LO
			memoria[32'd187] = {j,26'd116};//jump sai do laço
			
			//---muda processo atual
			memoria[32'd188] = {movi,R21,RZERO,RZERO,11'd13};//movi r21,13
			memoria[32'd189] = {sw,RZERO,R21,R20,11'd1};//sw r20, 1(r21)//muda o processo em execução
			memoria[32'd190] = {j,26'd149};//jump muda para o processo

		//L1 --- ve se o processo atual esta em processamento normal(Não IO)
			memoria[32'd191] = {movi,R20,RZERO,RZERO,11'd1};//movi r20,1 // estado normal
			memoria[32'd192] = {lw,R21,R20,RZERO,11'd13};//lw r21, 13(r20) // pega o processo atual
			memoria[32'd193] = {lw,R21,R20,RZERO,11'd1};//lw r22, 1(r21)//pega o estado do processo
			memoria[32'd194] = {beq,RZERO,R22,R20,11'dX};//beq r22,r20, muda para o processo pc+x   !!!!!!!!!MUDAR!!!!!!

		//L2 - pega uma instrução esperando IO
			memoria[32'd195] = {movi,R20,RZERO,RZERO,11'd1};//movi r21, 14 
			memoria[32'd196] = {lw,R22,R21,RZERO,11'd1};//lw r22, 1(r21)//numero processo esperando io
			memoria[32'd197] = {beq,RZERO,R22,RZERO,11'd5};//beq r22,rzero, volta menu  pc+5
			memoria[32'd198] = {movi,R21,RZERO,RZERO,11'd15};//movi r21, 15
			memoria[32'd199] = {lw,R22,R21,RZERO,11'd1};//lw r22, 1(r21) // o inicio da fila de processos IO 
			memoria[32'd200] = {lw,R24,R22,RZERO,11'd1};//lw r24, 1(r22)//pega o processo
			memoria[32'd201] = {j,26'd136};//jump muda para o processo io
			memoria[32'd202] = {j,endMenu};//jump menu
			
			// -- muda para o processo io
			memoria[32'd203] = {movi,R25,RZERO,RZERO,11'd13};//movi r25, 13 //posição qu salva processo atual
			memoria[32'd204] = {sw,RZERO,R25,R24,11'd1};//sw r24, 1(r25) //muda o processo atual
			memoria[32'd205] = {movi,R20,RZERO,RZERO,11'd1};//movi r20,1
			memoria[32'd206] = {sw,RZERO,R24,R20,11'd1};//sw r20, 1(r24)//muda status do processo

			//-----desenfila
			memoria[32'd207] = {movi,R21,RZERO,RZERO,11'd14};//movi r21, 14 //decrementa contador
			memoria[32'd208] = {lw,R22,R21,RZERO,11'd1};//lw r22, 1(r21)
			memoria[32'd209] = {subi,R22,R22,RZERO,11'd1};//subi r22,1
			memoria[32'd210] = {sw,RZERO,R21,R22,11'd1};//sw r22, 1(r21)

			memoria[32'd211] = {movi,R21,RZERO,RZERO,11'd15};//movi r21, 15//muda ponteiro
			memoria[32'd212] = {lw,R22,R21,RZERO,11'd1};//lw r22, 1(r21)
			memoria[32'd213] = {subi,R22,R22,RZERO,11'd1};//subi r22,1//addi r22,1 //pega o proximo da fila			
			memoria[32'd214] = {sw,RZERO,R21,R22,11'd1};//sw r22, 1(r21)

			memoria[32'd215] = {j,26'd159};//jump entrada de dados


		// -- muda para o processo

			memoria[32'd216] = {j,26'd33};//jump carrega contexto


			//------------fim escalonador --------------

			//-----finalizar um processo------
			memoria[32'd217] = {cproc,26'd0};//cproc,rzero
			memoria[32'd218] = {movi,R20,RZERO,RZERO,11'd13};//movi r20,13
			memoria[32'd219] = {lw,R21,R20,RZERO,11'd1};//lw r21, 1(r20) // pega o processo atual
			memoria[32'd220] = {mov,R22,RZERO,RZERO,11'd0};//mov r22 , rzero
			memoria[32'd221] = {sw,RZERO,R21,R22,11'd1};//sw r22, 1(r21)//marca o processo como inativo
			memoria[32'd222] = {lw,R23,R20,RZERO,11'd0};//lw r23, 0(rzero)//numero de processos rodando
			memoria[32'd223] = {subi,R23,R23,RZERO,11'd1};//subi r23, 1 // decrementa o numero de processos ativos
			memoria[32'd224] = {sw,RZERO,R21,R23,11'd0};//sw r23, 0(rzero)//salva novo numero de processos rodando
			memoria[32'd225] = {j,endEscalonador};//jump escalonador

			//--------entrada de dados---------
			memoria[32'd226] = {led,26'd3};//led , 3
			memoria[32'd227] = {in,R25,RZERO,RZERO,11'd0};//in r25 -- entrada de dados do usuario
			memoria[32'd228] = {led,26'd4};// led , 4
			memoria[32'd229] = {j,26'd33};//jump carrega contexto

			//----saida de dados----------------

			memoria[32'd230] = {scpc,R20,21'd0};//scpc r20 - armazena pc do processo
			memoria[32'd231] = {addi,R20,R20,RZERO,11'd1};//addi r20,r20,1 -- pc+1
			memoria[32'd232] = {mov,R24,5'b11111,5'b11111,11'd0};//mov r24, rret -- move o valor do registrador de retorno do processo para um registrador de sistema
			memoria[32'd233] = {movi,R21,RZERO,RZERO,11'd16};//movi r21,16
			memoria[32'd234] = {sw,RZERO,R21,R24,11'd1};//sw r24, 1(r21)
			memoria[32'd235] = {out,RZERO,R21,R21,11'd1};//out 1(r21)
			memoria[32'd236] = {jumpR,RZERO,R20,R20,11'd0};//jr r20 - retorna para o processo

			
			entradaNovoProcesso,entradaProcesso,iniciaProcesso
		*/	//----- inicia um processo --------
		
			memoria[32'd237] = {movi,R22,RZERO,RZERO,11'd11};//movi r22, 11
			memoria[32'd238] = {lw,R20,R22,RZERO,11'd1};//lw r20, 1(r22)    -- puxa o processo a ser iniciado
			memoria[32'd239] = {movi,R21,RZERO,RZERO,11'd1};//movi r21, 11'd1 //marca processo como em processamento normal
			memoria[32'd240] = {sw,RZERO,R20,R21,11'd1};//sw r21 , 1(r20) //salva estado do processo na lista de processos
			memoria[32'd241] = {mov,R23,R20,R20,11'd0};//mov r23, r20 
			memoria[32'd242] = {multi,R23,R23,RZERO,11'd300};//multi r23,r23,300 //pc(zero) relativo
			memoria[32'd243] = {sw,RZERO,R23,R23,11'd1};//sw r23, 1(r23)
			memoria[32'd244] = {j,entradaNovoProcesso};//jump entrada de novo processo

			// -------  executar processos --------
			memoria[32'd245] = {led,26'd2};//led , 2
			memoria[32'd246] = {led,26'd5};//led, 5
			memoria[32'd247] = {movi,R22,RZERO,RZERO,11'd12};//movi r22, 0 // contador de processos que foram iniciados
			memoria[32'd248] = {sw,RZERO,R22,RZERO,11'd1};//sw rzero 1(r22)
			memoria[32'd249] = {in,R20,21'd0};//in r20 // entrada do numero de processos que irão rodar
			memoria[32'd250] = {led,26'd6};//led, 6
			memoria[32'd251] = {sw,RZERO,R20,R20,11'd0};//sw r20, 0, rzero // salva na memoria de dados o numero de processos rodando
			memoria[32'd252] = {beq,RZERO,R20,RZERO,11'd2};//MUDAR beq r20, rzero // volta para o menu(sem processos para rodar)
			memoria[32'd253] = {j,entradaProcesso};
			memoria[32'd254] = {j,endMenu};
			
						//----entrada processo
			memoria[32'd255] = {led,26'd7};//led 7 
			memoria[32'd256] = {in,R21,21'd0};//in r21 processo que ira rodar
			memoria[32'd257] = {led,26'd8};//led 8
			memoria[32'd258] = {movi,R24,RZERO,RZERO,11'd11};//movi r24, 11
			memoria[32'd259] = {sw,RZERO,R24,R21,11'd1};//sw r21, 1(r24) // salva qual processo vai ser executado
			memoria[32'd260] = {movi,R23,RZERO,RZERO,11'd12};//movi r23, 12 //endereço de onde esta o contador de processos
			memoria[32'd261] = {lw,R22,R23,R23,11'd1};//lw r22, 1(r23) // puxa o valor do contador de processos iniciados
			memoria[32'd262] = {addi,R22,R22,RZERO,11'd1};//addi r22,r22,1 // incrementa contador
			memoria[32'd263] = {sw,RZERO,R23,R22,11'd1};//sw r22 , 1(r23) // salva contador
			memoria[32'd264] = {j,iniciaProcesso};//jump inicia processo

//---entrada de novo processo
			memoria[32'd265] = {movi,R23,RZERO,RZERO,11'd12};//movi r23, 12 //endereço de onde esta o contador de processos
			memoria[32'd266] = {lw,R22,R23,RZERO,11'd1};//lw r22, 1(r23) // puxa o valor do contador
			memoria[32'd267] = {lw,R20,R23,RZERO,11'd0};//lw r20, 0(rzero) // puxa numero de processos totais
			memoria[32'd268] = {beq,RZERO,R20,R22,11'd2};//beq r20,r22, +2 -- escalonador
			memoria[32'd269] = {j,entradaProcesso};//jump entrada processo
			memoria[32'd270] = {j,endEscalonador};

			//-------------------------fim gerenciador de processos ----------------------------------------------

			//----------------------------menu do SO---------------------------------------------------------------
		/*	memoria[32'd270] = {led,26'd1};//led, 1
			memoria[32'd271] = {cproc,26'd0};//cproc,rzero
			memoria[32'd272] = {in,R20,21'd0};//in r20 // opçao
			memoria[32'd273] = {movi,R21,RZERO,RZERO,11'd1};//movi r21 , 1 //  //listar
			memoria[32'd274] = {movi,R22,RZERO,RZERO,11'd2};//movi r22 , 2 // criar
			memoria[32'd275] = {movi,R23,RZERO,RZERO,11'd3};//movi r23 , 3  // editar
			memoria[32'd276] = {movi,R24,RZERO,RZERO,11'd4};//movi r24 , 4 // deletar
			memoria[32'd277] = {beq,RZERO,R20,RZERO,11'd2};//pc+2
			//beq r21, r20, 207 
			//beq r22, r20, 208
			//beq r23, r20, 209
			//beq r24, r20, 210
			memoria[32'd278] = {j,26'd272};//jump menu
			memoria[32'd279] = {j,26'd245};//jump executar processos



			// ------------------------------------fim do menu-----------------------------------------


//fatorial
		//memoria[32'd300] = {6'b100110,5'd2,5'd0,5'd0,11'd0};//in r2
		memoria[32'd300] = {mov,5'd2,R25,R25,11'd0};
		memoria[32'd302] = {6'b011010,5'd0,5'd0,5'd0,11'd1};//movi r0,1
		memoria[32'd303] = {6'b011010,5'd1,5'd0,5'd0,11'd1};//movi r1,1
		memoria[32'd304] = {6'b011001,5'd3,5'd1,5'd1,11'd0};//mov r3,r1
		memoria[32'd305] = {6'b010100,5'd8,5'd1,5'd2,11'd4};//beq r1,r2,+4
		memoria[32'd306] = {6'b000100,5'd3,5'd3,5'd2,11'd0};//mult r3,r3,r2
		memoria[32'd307] = {6'b000011,5'd2,5'd2,5'd2,11'd1};//subi r2,r2,1
		memoria[32'd308] = {6'b010001,5'd0,5'd0,5'd0,11'd4};//j linha 4
		memoria[32'd309] = {6'b011000,5'd3,5'd3,5'd3,11'd0};//sw r3,0(r0)
		memoria[32'd310] = {6'b100111,5'd3,5'd3,5'd0,11'd0};//outproc
*/
//potencia de 2
		/*memoria[32'd600] = {6'b011010,5'b11010,5'b00000,16'd1};
		memoria[32'd601] = {6'b011010,5'b11011,5'b00000,16'd30};
		memoria[32'd602] = {6'b010001,26'd3};
		//main
		memoria[32'd603] = {6'b010111,5'b00001,5'b11010,16'd1};
		memoria[32'd604] = {6'b100110,5'b11111,21'd0};
		memoria[32'd605] = {6'b011001,5'b11111,5'b11001,5'b00000,11'd0};
		memoria[32'd606] = {6'b011001,5'b00001,5'b11111,16'd0};
		memoria[32'd607] = {6'b011000,5'b00000,5'b11010,5'b00001,11'd1};
		memoria[32'd608] = {6'b010111,5'b00010,5'b11010,16'd2};
		memoria[32'd609] = {6'b011010,5'b00011,5'b00000,16'd1};
		memoria[32'd610] = {6'b011001,5'b00010,5'b00011,16'd0};
		memoria[32'd611] = {6'b011000,5'b00000,5'b11010,5'b00010,11'd2};
		memoria[32'd612] = {6'b010111,5'b00100,5'b11010,16'd3};
		memoria[32'd613] = {6'b011010,5'b00101,5'b00000,16'd0};
		memoria[32'd614] = {6'b011001,5'b00100,5'b00101,16'd0};
		memoria[32'd615] = {6'b011000,5'b00000,5'b11010,5'b00100,11'd3};
		//L0
		memoria[32'd616] = {6'b010111,5'b00110,5'b11010,16'd3};
		memoria[32'd617] = {6'b010111,5'b00111,5'b11010,16'd1};
		memoria[32'd618] = {6'b100010,5'b00110,5'b00111,16'd26};
		memoria[32'd619] = {6'b010111,5'b01000,5'b11010,16'd2};
		memoria[32'd620] = {6'b010111,5'b01001,5'b11010,16'd2};
		memoria[32'd621] = {6'b011010,5'b01010,5'b00000,16'd2};
		memoria[32'd622] = {6'b000100,5'b01011,5'b01001,5'b01010,11'd0};
		memoria[32'd623] = {6'b011001,5'b01000,5'b01011,16'd0};
		memoria[32'd624] = {6'b011000,5'b00000,5'b11010,5'b01000,11'd2};
		memoria[32'd625] = {6'b010001,26'd16};
		//L1
		memoria[32'd626] = {6'b010111,5'b01100,5'b11010,16'd2};
		memoria[32'd627] = {6'b011001,5'b01101,5'b01100,16'd0};
		memoria[32'd628] = {6'b100111,5'b00000,5'b01101,16'd0};
		memoria[32'd629] = {6'b010001,26'd30};
		//end
		memoria[32'd630] = {6'b011111,5'b00000,5'b00000,5'b00000,11'd0};

//fibinati
	memoria[32'd900] = {6'b011010,5'b11010,5'b00000,16'd1};
	memoria[32'd901] = {6'b011010,5'b11011,5'b00000,16'd30};
	memoria[32'd902] = {6'b010001,26'd3};
	//main
	memoria[32'd903] = {6'b010111,5'b00001,5'b11010,16'd1};
	memoria[32'd904] = {6'b011101,5'b11111,21'd0};
	memoria[32'd905] = {6'b011001,5'b11111,5'b11001,5'b00000,11'd0};
	memoria[32'd906] = {6'b011001,5'b00001,5'b11111,16'd0};
	memoria[32'd907] = {6'b011000,5'b00000,5'b11010,5'b00001,11'd1};
	memoria[32'd908] = {6'b010111,5'b00010,5'b11010,16'd4};
	memoria[32'd909] = {6'b011010,5'b00011,5'b00000,16'd1};
	memoria[32'd910] = {6'b011001,5'b00010,5'b00011,16'd0};
	memoria[32'd911] = {6'b011000,5'b00000,5'b11010,5'b00010,11'd4};
	memoria[32'd912] = {6'b010111,5'b00100,5'b11010,16'd2};
	memoria[32'd913] = {6'b011010,5'b00101,5'b00000,16'd1};
	memoria[32'd914] = {6'b011001,5'b00100,5'b00101,16'd0};
	memoria[32'd915] = {6'b011000,5'b00000,5'b11010,5'b00100,11'd2};
	memoria[32'd916] = {6'b010111,5'b00110,5'b11010,16'd3};
	memoria[32'd917] = {6'b011010,5'b00111,5'b00000,16'd1};
	memoria[32'd918] = {6'b011001,5'b00110,5'b00111,16'd0};
	memoria[32'd919] = {6'b011000,5'b00000,5'b11010,5'b00110,11'd3};
	memoria[32'd920] = {6'b010111,5'b01000,5'b11010,16'd5};
	memoria[32'd921] = {6'b011010,5'b01001,5'b00000,16'd1};
	memoria[32'd922] = {6'b011001,5'b01000,5'b01001,16'd0};
	memoria[32'd923] = {6'b011000,5'b00000,5'b11010,5'b01000,11'd5};
	//L0
	memoria[32'd924] = {6'b010111,5'b01010,5'b11010,16'd4};
	memoria[32'd925] = {6'b010111,5'b01011,5'b11010,16'd1};
	memoria[32'd926] = {6'b100010,5'b01010,5'b01011,16'd48};
	memoria[32'd927] = {6'b010111,5'b01100,5'b11010,16'd5};
	memoria[32'd928] = {6'b010111,5'b00001,5'b11010,16'd2};
	memoria[32'd929] = {6'b010111,5'b00010,5'b11010,16'd3};
	memoria[32'd930] = {6'b000000,5'b00011,5'b00001,5'b00010,11'd0};
	memoria[32'd931] = {6'b011001,5'b01100,5'b00011,16'd0};
	memoria[32'd932] = {6'b011000,5'b00000,5'b11010,5'b01100,11'd5};
	memoria[32'd933] = {6'b010111,5'b00100,5'b11010,16'd2};
	memoria[32'd934] = {6'b010111,5'b00101,5'b11010,16'd3};
	memoria[32'd935] = {6'b011001,5'b00100,5'b00101,16'd0};
	memoria[32'd936] = {6'b011000,5'b00000,5'b11010,5'b00100,11'd2};
	memoria[32'd937] = {6'b010111,5'b00110,5'b11010,16'd3};
	memoria[32'd938] = {6'b010111,5'b00111,5'b11010,16'd5};
	memoria[32'd939] = {6'b011001,5'b00110,5'b00111,16'd0};
	memoria[32'd940] = {6'b011000,5'b00000,5'b11010,5'b00110,11'd3};*/

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