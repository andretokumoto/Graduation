module ContadorDeQuantum(
  input clock,
  input reset,
  input [31:0]  pc,
  input InstrucaIO,
  input fimProcesso,
  input processoAtual,
  input [5:0] opcode,
  output reg troca_contexto, // Sinal de troca de contexto
  output reg [31:0] pc_processo_trocado,//salva o pc do processo interrompido
  output reg intrucaoIOContexto//sinal para dar salto em intrução de io
);

 parameter quantum = 32'd5;
 parameter jump=6'b010001,jumpR=6'b010010,beq=6'b010100,in=6'b011101,out=6'b011110;
 
 reg [31:0] contador=32'd0;
 
 always@(negedge clock || reset)
	begin
		
		if(reset || fimProcesso==1'd1)begin
			contador=32'd0;
			troca_contexto = 1'b0;
			intrucaoIOContexto = 1'b0;
		end
		
		
		
		else if(pc > 32'd300)//não faz a contagem do SO
			begin
				
					if (opcode == jump || opcode == jumpR || opcode == beq || opcode == in || opcode == out) 
						begin
							 contador = contador+1;
						end
						
					else if(contador>=quantum) //quantum atingido 
						begin
							pc_processo_trocado = pc+32'd1; //salva pc do processo atual + 1
							troca_contexto = 1'b1;//da sinal para o sistema realizar a troca de contexto
							contador = 32'd0;//zera o contador
						end

					else if(InstrucaIO)//intruçao de entrada/saida
						begin
							contador = 32'd0;
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
