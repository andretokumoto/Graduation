module BancoRegistradores(clk,escritaRegControl,inRS,inRT,inRD,dados,outRS,outRT,linkControl);

input clk,escritaRegControl,linkControl;
input [4:0] inRS,inRT,inRD;
input [31:0] dados;
output wire[31:0]  outRS,outRT;

reg [31:0] bancoDeRegistradores[31:0];


  
	assign outRS = bancoDeRegistradores[inRS];
	assign outRT = bancoDeRegistradores[inRT]; 
	 

/*

registradores reservados para o SO

r20 até r25:
	RS1   :  "5'b10100"
	RS2   :  "5'b10101"
	RS3   :  "5'b10110"
	RS4   :  "5'b10111"
	RS5   :  "5'b11000"
	RS6   :  "5'b11001"
	

registradores especiais:

	RSP   :  "5'b11010"
	RBP   :  "5'b11011"
	RA    :  "5'b11100"
	RRET  :  "5'b11111"
*/


 always@(negedge clk)//toda descida de clock
 begin
   
   bancoDeRegistradores[4'd0] = 32'd0; // registrador Zero tem por padrão valor zero

   if(escritaRegControl) bancoDeRegistradores[inRD] = dados;
	
 end
 

endmodule

