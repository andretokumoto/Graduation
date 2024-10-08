module BancoRegistradores(clk,escritaRegControl,inRS,inRT,inRD,dados,outRS,outRT,linkControl);

input clk,escritaRegControl,linkControl;
input [4:0] inRS,inRT,inRD;
input [31:0] dados;
output wire[31:0]  outRS,outRT;

reg [31:0] bancoDeRegistradores[31:0];


  
	assign outRS = bancoDeRegistradores[inRS];
	assign outRT = bancoDeRegistradores[inRT]; 
	 


 always@(negedge clk)//toda descida de clock
 begin
   
   if(escritaRegControl) bancoDeRegistradores[inRD] = dados;
	
 end
 

endmodule

