module MEMInstrucoes(reset, pc, opcode, jump, OUTrs, OUTrt, OUTrd, imediato, clock, entradaDeInstrucao, posicaoParaSalvarInstrucao, controleSalvaInstrucao, biosEmExecucao, encerrarBios);

		input [31:0] pc, entradaDeInstrucao, posicaoParaSalvarInstrucao;
		input clock, reset;
		input encerrarBios;
		input [2:0] controleSalvaInstrucao;
		output reg [5:0] opcode;
		output reg [4:0] OUTrs, OUTrt, OUTrd;
		output reg [15:0] imediato;
		output reg [25:0] jump;
		output reg biosEmExecucao; // Sinal que indica que a bios está em execução

		reg [31:0] Bios[120:0];
		reg [1:0] executaBios;
		reg [31:0] instrucao;
		reg [31:0] memoria[200:0];

		// Lógica combinatória para verificar se a bios está em execução
		always @(*) begin
			 if(executaBios == 2'b01) begin
				  biosEmExecucao = 1'b1;
			 end
			 else begin
				  biosEmExecucao = 1'b0;
			 end
		end

		// Lógica síncrona para reset e encerrarBios
		always@(posedge clock or posedge reset)                           
		begin 
			 if(reset == 1'b1) begin
				  executaBios <= 2'b01; // Executa a bios
			 end
			 else if(encerrarBios == 1'b1) begin
				  executaBios <= 2'b00; // Encerra a bios
			 end

			//bios ---------------------------------------------------------------			
						//lfhd puxa uma programa 
						//Bios[32'd0] = {} 
						
						// movi r0, 0
						// movi r1, 0
						// movi r2, 0
						// movi r3, 0
						// movi r4, 0
						// movi r5, 0
						// movi r6, 0
						// movi r7, 0
						// movi r8, 0
						// movi r9, 0
						// movi r10, 0
						// movi r11, 0
						// movi r12, 0
						// movi r13, 0
						// movi r14, 0
						// movi r15, 0
						// movi r16, 0
						// movi r17, 0
						// movi r18, 0
						// movi r19, 0
						// movi r20, 0
						// movi r21, 0
						// movi r22, 0
						// movi r23, 0
						// movi r24, 0
						// movi r25, 0
						// movi r26, 0
						// movi r27, 0
						// movi r28, 0
						// movi r29, 0
						// movi r30, 0
						// movi r31, 0
						// checkMem
						// lfhd r0  // puxa o SO do HD
						// encerraBios
			//-------------------------------------------------------------------------------------
						



			  //            opcode   rd   rs   rt  imediato
			  
					//memoria[32'd0] = {6'b011101,5'd2,5'd0,5'd0,11'd0};//in r2
				/*	memoria[32'd0] = {6'b011010,5'd2,5'd0,5'd0,11'd4};//movi r2,4
					memoria[32'd1] = {6'b011010,5'd0,5'd0,5'd0,11'd1};//movi r0,1
					memoria[32'd2] = {6'b011010,5'd1,5'd0,5'd0,11'd1};//movi r1,1
					memoria[32'd3] = {6'b011001,5'd3,5'd1,5'd1,11'd0};//mov r3,r1
					memoria[32'd4] = {6'b010100,5'd8,5'd1,5'd2,11'd8};//beq r1,r2,8
					memoria[32'd5] = {6'b000100,5'd3,5'd3,5'd2,11'd0};//mult r3,r3,r2
					memoria[32'd6] = {6'b000011,5'd2,5'd2,5'd2,11'd1};//subi r2,r2,1
					memoria[32'd7] = {6'b010001,5'd0,5'd0,5'd0,11'd4};//j linha 4
					memoria[32'd8] = {6'b011000,5'd3,5'd3,5'd3,11'd0};//sw r3,0(r0)
					memoria[32'd9] = {6'b011110,5'd3,5'd3,5'd3,11'd0};//out 0(r0)*/
					
			 instrucao <= memoria[pc];
			 opcode    <= instrucao[31:26];
			 jump      <= instrucao[25:0];
			 OUTrd     <= instrucao[25:21];
			 OUTrs     <= instrucao[20:16];
			 OUTrt     <= instrucao[15:11];
			 imediato  <= instrucao[10:0];
		end

endmodule

