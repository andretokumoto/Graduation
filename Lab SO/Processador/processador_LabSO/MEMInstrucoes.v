module MEMInstrucoes(reset,pc,opcode,jump,OUTrs,OUTrt,OUTrd,imediato,clock,entradaDeInstrucao,posicaoParaSalvarInstrucao,controleSalvaInstrucao);

input [31:0] pc,entradaDeInstrucao,posicaoParaSalvarInstrucao;
input clock,reset;
input [2:0] controleSalvaInstrucao;
output reg[5:0] opcode;
output reg[4:0] OUTrs,OUTrt,OUTrd;
output reg[15:0] imediato;
output reg[25:0] jump;

reg [10:0] pcBios;
reg [31:0] Bios[120:0];

reg [31:0] instrucao;
reg [31:0] memoria[200:0];


always@(posedge clock or posedge reset)                           
  begin 
		
		if(reset) pcBios = 11'd0;
		
		//------------Começo da BIOS----------------------------------------------
		
		    // movi r0,0
			 // movi zero para todos os registradores
			 // muda estado de todos os blocos de memoria para livre
			 // lê os programas no hd e cria uma lista (adicionar funcionalidade no gerenciador de memoria
			 // muda o pc do siema para o pc do so e inicia so
			 
			
		
		//----------Fim da BIOS---------------------------------------------------

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

 
 
 
/*always @(pc)
 begin
	  instrucao = memoria[pc]; 
	  
	  opcode    =   instrucao[31:26];
	  jump      =   instrucao[25:0];
	  OUTrd     =   instrucao[25:21];
	  OUTrs     =   instrucao[20:16];
	  OUTrt     =   instrucao[15:11];
	  imediato  =   instrucao[10:0];
	  
 end*/
 
endmodule



