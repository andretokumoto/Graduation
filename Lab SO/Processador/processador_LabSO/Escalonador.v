module Escalonador(
    input clock,
    input reset,
	 input [31:0] novo_processo,
	 input controle_novo_processo,
    output reg [31:0] processo_atual, // Número do processo atual
    output reg troca_contexto // Sinal de troca de contexto
);

    
    parameter quantum = 32'd20; 

    reg [31:0] processos [4:0]; // Lista de processos 
    reg [3:0] indice_processo_atual = 4'd0; //processo atual
    reg [31:0] contador = 32'd0; 
	 reg [3:0] num_processos;


	 always@(posedge controle_novo_processo)
		begin
			
			processos[num_processos] = novo_processo;
			num_processos = num_processos + 4'd1;
			
		end
	 
  
    always @(posedge clock or posedge reset) begin
			
			//resetando escalonador
        if (reset) begin
            contador <= 32'd0;
            indice_processo_atual <= 4'd0;
            processo_atual <= 32'd0; 
            troca_contexto <= 1'b0; 
				num_processos <= 4'd0;
        end
        else begin
            
            contador <= contador + 32'd1;

            // quantum foi atingido
            if (contador >= quantum) begin
       
                contador <= 32'd0;

                // Alterna processo
                if (indice_processo_atual < num_processos - 1) 
						begin
                    indice_processo_atual <= indice_processo_atual + 4'd1;
						end
						
                else 
						begin
                    indice_processo_atual <= 4'd0; // Volta para o primeiro processo
						end

                // atualiza processo atual
                processo_atual <= processos[indice_processo_atual];

                // sinal de troca de contexto
                troca_contexto <= 1'b1;
            end
            else begin
                // troca de contexto desativado
                troca_contexto <= 1'b0;
            end
        end
    end

endmodule