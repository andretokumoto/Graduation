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
			// jr r21 // retorna o pocessamento do processo
			//------------------------------fim mudança de contexto---------------------------




		end


	always@(negedge clk)
	 begin
	 
	   if (we)
			hd[write_addr] <= data;
			
	 end
	


endmodule



