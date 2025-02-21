module correcaoDesvio(

	input [10:0] desvioOriginal,
	input processo_atual,
	output reg [10:0] desvioCorrigido

);
	TAM_BLOCO = 32'd200;
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