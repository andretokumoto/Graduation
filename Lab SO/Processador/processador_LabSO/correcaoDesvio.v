module correcaoDesvio(

	input [10:0] desvioOriginal,
	input valorCorrecao,
	output reg [10:0] desvioCorrigido

);

	

	always@(desvioOriginal)
		begin
				desvioCorrigido = desvioOriginal+valorCorrecao;
		end


endmodule