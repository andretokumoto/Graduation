module correcaoDesvio(

	input [31:0] desvioOriginal,
	input processo_atual,
	output reg [31:0] desvioCorrigido

);
	parameter TAM_BLOCO = 32'd300;
	
	reg [31:0] valorCorrecao;

	always@(processo_atual)
		begin
			valorCorrecao = TAM_BLOCO*processo_atual;//calcula novo valor de pc de desvio
		end

	always@(desvioOriginal)
		begin
				desvioCorrigido = desvioOriginal+valorCorrecao;
		end


endmodule