module Gerenciador_memoria(
    input [3:0] bloco_para_alteracao,
    input [1:0] tipo_alteracao, // 00: nada, 01: criar, 10: deletar, 11: alterar nome
    input [31:0] Bloco_para_analise_ram, // Dados do bloco na RAM
    input [31:0] Bloco_para_analise_hd,  // Dados do bloco no HD
    input clk,
    input reset,
    output reg [31:0] cabecalho_bloco_para_salvar_na_memoriaRAM, // Bloco para salvar na RAM

    // testes
    output reg [3:0] teste_cursor_memoria,
    output reg [3:0] teste_bloco_livre,
    output reg [30:0] teste_nome_bloco,
    output reg [31:0] teste_blocos_de_memoria,
    output reg testeEntrou
);

    reg [3:0] cursor_memoria;
    reg [3:0] bloco_livre;
    reg [30:0] nome_bloco;
    reg [31:0] blocos_de_memoria [3:0]; // Vetor de 16 blocos de memória

    parameter criar = 2'b01, deletar = 2'b10, alterar_nome = 2'b11;

	 //percorre as posições
	 
	 
	 always @(negedge clk)
		begin
			
		  if (reset) begin
            bloco_livre <= 4'b0000;
            cursor_memoria = 4'b0000;
        end 
			
			else if(cursor_memoria == 4'b1111) cursor_memoria = 4'b0000;
			
			else
				begin
					if(blocos_de_memoria[cursor_memoria][31] == 1'b0) //bloco livre
						begin
							bloco_livre <= cursor_memoria;
							teste_bloco_livre = bloco_livre;
						end
						
					else begin 
						cursor_memoria = cursor_memoria+1'd1;
						end
					
				end
				teste_cursor_memoria = cursor_memoria;
		
		end
	 
	 
    // Reset síncrono/assíncrono
    always @(posedge clk ) begin
        //testeEntrou = 1'b1;
        

            nome_bloco <= Bloco_para_analise_hd[30:0]; // Nome do bloco do HD
            teste_nome_bloco = nome_bloco;

            case (tipo_alteracao) // altera o estado e ou parâmetros de um bloco
                criar: begin
					 
					         blocos_de_memoria[bloco_livre] <= {1'b1, nome_bloco};
                        cabecalho_bloco_para_salvar_na_memoriaRAM <= blocos_de_memoria[bloco_livre];
                    /*if (blocos_de_memoria[bloco_livre][31] == 1'b0) begin
                        blocos_de_memoria[bloco_livre] <= {1'b1, nome_bloco};
                        cabecalho_bloco_para_salvar_na_memoriaRAM <= blocos_de_memoria[bloco_livre];
                    end 
                    else begin
                        // Processo de busca por bloco livre
                        for (cursor_memoria = 16; cursor_memoria > 0; cursor_memoria = cursor_memoria - 1) begin
                            if (blocos_de_memoria[cursor_memoria][31] == 1'b0) begin
                                bloco_livre <= cursor_memoria;
										  teste_bloco_livre = bloco_livre;										  
                            end
                            blocos_de_memoria[bloco_livre] <= {1'b1, nome_bloco};
                            cabecalho_bloco_para_salvar_na_memoriaRAM <= blocos_de_memoria[bloco_livre];
                        end
                    end*/
                end

                deletar: begin
                    blocos_de_memoria[bloco_para_alteracao] <= {1'b0, blocos_de_memoria[bloco_para_alteracao][30:0]};
                    cabecalho_bloco_para_salvar_na_memoriaRAM <= blocos_de_memoria[bloco_para_alteracao];
                end

                alterar_nome: begin
                    blocos_de_memoria[bloco_para_alteracao] <= {1'b1, nome_bloco};
                    cabecalho_bloco_para_salvar_na_memoriaRAM <= blocos_de_memoria[bloco_para_alteracao];
                end

                default: begin
                    // Sem operação
                end
            endcase
				        
							teste_blocos_de_memoria = blocos_de_memoria[bloco_para_alteracao];
        end
        // SÓ FIZ A PARTE DE ALTERAÇÃO DO BLOCO, FALTA FAZER A COMUNICAÇÃO DAS MEMÓRIAS RAM E HD
        // FALTA A LIGAÇÃO COM O RESTO DO SISTEMA
    
endmodule
