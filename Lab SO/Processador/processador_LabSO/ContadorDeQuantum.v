module ContadorDeQuantum(
  input clock,
  input reset,
  input [31:0]  pc,
  input InstrucaIO,
  input fimProcesso,
  input processoAtual,
  output reg troca_contexto, // Sinal de troca de contexto
  output reg [31:0] pc_processo_trocado,//salva o pc do processo interrompido
  output reg intrucaoIOContexto//sinal para dar salto em intrução de io
);

 parameter quantum = 32'd5; 
 reg [31:0] contador=32'd0;
 
 always@(negedge clock || reset)
	begin
		
		if(reset || fimProcesso==1'd1)begin
			contador=32'd0;
			troca_contexto = 1'b0;
			intrucaoIOContexto = 1'b0;
		end
		
		
		else if(/*processoAtual != 32'd0*/ pc > 32'd300)//não faz a contagem do SO
			begin
				
					if(contador>=quantum) //quantum atingido 
						begin
							pc_processo_trocado = pc+32'd1; //salva pc do processo atual + 1
							troca_contexto = 1'b1;//da sinal para o sistema realizar a troca de contexto
							contador = 32'd0;//zera o contador
						end

					else if(InstrucaIO)//intruçao de entrada/saida
						begin
							pc_processo_trocado = pc+32'd1; //salva pc do processo atual + 1
							intrucaoIOContexto = 1'b1;
						end
					
					else
						begin
							troca_contexto = 1'b0;//para pc atualizar normalmente
							intrucaoIOContexto = 1'b0;
							contador = contador + 32'd1;
						end
						
			end
		else 
			begin
				troca_contexto = 1'b0;//para pc atualizar normalmente
				intrucaoIOContexto = 1'b0;
			end
		
	end
 
endmodule