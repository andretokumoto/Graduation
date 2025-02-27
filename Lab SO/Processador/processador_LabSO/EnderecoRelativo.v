module EnderecoRelativo(

	input [31:0] numeroProcesso,
	input [31:0] resultadoULA,
	output reg[31:0] enderecoRelativo
);
	reg [31:0] desvio;
	parameter TamBloco = 32'd300;
	
	always@(numeroProcesso)
		begin
			desvio = numeroProcesso*TamBloco;
		end

	always@(resultadoULA)
		begin
			enderecoRelativo = resultadoULA + desvio;
		end

endmodule