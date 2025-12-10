module EntradaSaida(botaoIN,endereco,dadosEscrita,DadosLidos,entradaSaidaControl,clk,clock,entradaDeDados,unidade,dezena,centena);

input [31:0] endereco,dadosEscrita;
input [3:0]  entradaDeDados;
input [1:0]  entradaSaidaControl;
input clk,clock,botaoIN;

reg [31:0] saidaDeDados;
//reg controlesaida;
//wire saidaDeDados;
output wire [3:0] unidade,dezena,centena;

output reg [31:0] DadosLidos;


BCD bcd(.binario(saidaDeDados/*dadosEscrita*/),.unidade(unidade),.dezena(dezena),.centena(centena),.controlesaida(entradaSaidaControl));

 
 always@(*)//saida
  begin
  
   if(entradaSaidaControl==2'b01)  saidaDeDados = dadosEscrita;
	
  end
  

  
  always@(posedge clk)//entrada
   begin 
	  if(entradaSaidaControl==2'b10) DadosLidos = {28'b0000000000000000000000000000,entradaDeDados};
	end

endmodule 