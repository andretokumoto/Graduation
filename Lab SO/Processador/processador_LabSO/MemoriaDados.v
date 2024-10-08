module MemoriaDados (clk,memControl,enderecoMEM,dadoEscrita,dadoMEM);

input clk,memControl;
input [31:0] enderecoMEM,dadoEscrita;
output reg [31:0] dadoMEM;

reg [31:0] memoria [200:0];

always@(negedge clk)
 begin
 
 if(memControl) memoria[enderecoMEM] = dadoEscrita;
 
 dadoMEM = memoria[enderecoMEM];
 
 end

endmodule




