module Gerenciador_memoria(

    input [31:0] numero_bloco_analisado,
    //input [1:0] tipo_alteracao, // 00: nada, 01: criar, 10: deletar, 11: alterar nome
    input [31:0] Bloco_para_analise_ram, // Dados do bloco na RAM
    input [31:0] Bloco_para_analise_hd,  // Dados do bloco no HD
    input clk,
    input reset,
	 input [1:0] ControlePuxarDoH,
	 input [1:0] VarrerMemoriaHD,
	 
	 
	 output reg[31:0] enderecoHD, 
	 output reg[31:0] dadoLidoHD, //dado que ira para a memoria de instruçoes
	 output [1:0] controleAcessoHD,//sinal que define se um dado do hd vai ou não ser lido
	 output ControleSalvarInstrucaoNaMemInst,
	 output reg[1:0] ControleFimDeLeitura;
    //output reg [31:0] cabecalho_bloco_para_salvar_na_memoriaRAM, // Bloco para salvar na RAM

    // testes
    //output reg [3:0] teste_cursor_memoria,
    //output reg [3:0] teste_bloco_livre,
   // output reg [30:0] teste_nome_bloco,
    //output reg [31:0] teste_blocos_de_memoria,
    //output reg testeEntrou
);

   // reg [3:0] cursor_memoria;
   // reg [3:0] bloco_livre;
  //  reg [30:0] nome_bloco;
      reg [31:0] blocos_de_memoria [3:0]; // Vetor de 16 blocos de memória
		reg [31:0] LinhaASerLida, cabecalhoDoBloco;
		reg [31:0] numero_bloco_analisado_extendido;
		reg [31:0] tamanhoDosBlocos [7:0];
		reg [31:0] contadorLeituraHD;
		reg [31:0] blocoNaVarredura = 32'd0;

  //  parameter criar = 2'b01, deletar = 2'b10, alterar_nome = 2'b11;
		parameter Tamanho_bloco = 32'b200,TamMemoriaHD = 32'd4000;
	 //percorre as posições
	
	
	always@(numero_bloco_analisado)
		begin
			cabecalhoDoBloco = numero_bloco_analisado * Tamanho_bloco;
			LinhaASerLida = cabecalhoDoBloco + 31'd1;//pega a primeira linha após o cabeçalho
			contadorLeituraHD = LinhaASerLida + tamanhoDosBlocos[numero_bloco_analisado[7:0]];
		end
	
	 
	 always@(posedge clk or posedge reset)
		begin
			
			//if(reset) blocoNaVarredura = 32'd0;
			
			if(ControlePuxarDoHD==2'b01)//instrução para puxar um programa do hd , mada o endereço para acessar o dado da memoria
				begin
					
					enderecoHD = LinhaASerLida;
					dadoLidoHD = Bloco_para_analise_hd;
					LinhaASerLida = LinhaASerLida + 31'd1;
					
					
					if(LinhaASerLida == contadorLeituraHD) ControleFimDeLeitura = 2'b01;
					else ControleFimDeLeitura = 2'b00;
					
				end
				
			if(VarrerMemoriaHD==2'b01) 
				begin
				
				 
				
				end
			
			
		end
	 

	 
	  always@(negedge clk)
		begin
				if(LinhaASerLida == contadorLeituraHD) ControleFimDeLeitura = 2'b01;
				else ControleFimDeLeitura = 2'b00;
		end 
    
endmodule
