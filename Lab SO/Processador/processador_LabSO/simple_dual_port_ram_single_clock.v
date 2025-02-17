// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// single read/write clock

module simple_dual_port_ram_single_clock
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] hd[2**ADDR_WIDTH-1:0];

	always @ (*)
	begin
	
			q <= hd[read_addr];

	end
	
	//programas salvos
	always@(negedge clk)
		begin
			
			//Sistema Operacional
			hd[32'd0] = {1'b1,31'd0}; //nome do processo (SO)
			//jump menu
			//------------------------------------mudança contexto-----------
			//-----------salva contexto--------
			//scpc r20 -- salva o contexto do pc
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

			//----------------------verifica blocos do hd que estão em uso------------------------
			//movi r20 , 1
			//movi r23, 0
			//movi r24, 10
			//lhd r21 , rzero, 0
			//começo loop
			//lhd r22 , r20, 200
			//blt r22,r21, +4
			//sw r20, r23, 0
			//addi r23, 1
			//addi r20 , 1
			//subi r25, r24 ,r20
			//beq rzero, r25 , +2
			//jump começo loop
			//jump menu 
			// ----------------------- fim da verificação --------------------------------

			//--------------------gerenciamento de diretórios---------------------------------------------------

			//--------criar diretório ----------------------------------------

			// --- achar uma posição livre --------
			//movi r20 , 1
			//lhd r21 , rzero, 0
			//começo loop
			//lhd r22 , r20, 200
			//blt r22 , r21 , + 3 //achou uma posição livre
			//addi r20,r20,1
			//jump começo loop
			// --- criar diretório ----
			//in r23
			// add r23,r23,r21 // marca como bloco em uso
			//shd r23 , r20, 200 //salva o nome do novo diretório
			// jump menu

			//--------------editar diretório--------------------------
			//lhd r21 , rzero, 0
			//in r23 //bloco a ser alterado
			//lhd r22 , r23, 200
			//blt r22,r21, + 4 //bloco não esta em uso
			//in r24 //novo nome
			//add r24, r24,r21
			//shd r24 , r23, 200 // salva novo nome
			// jump menu

			//---------------deletar diretorio-------------
			//lhd r21 , rzero, 0
			//in r20
			//lhd r22 , r20, 200
			//sub r22 , r22, r22
			//shd r22, r20 , 200
			//jump menu

			// ------------------------ fim do gerenciador de diretórios ---------------------------------

			//--------------------------gerenciamento de processos---------------------------------------------

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


	always@(negedge clk)
	 begin
	 
	   if (we)
			hd[write_addr] <= data;
			
	 end
	


endmodule



