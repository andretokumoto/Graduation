module Display_PC(
  input [31:0] pc_atual,
  output wire [6:0] unidadePC,
  output wire [6:0] dezenaPC,
  output wire [6:0] centenaPC

);	
	displaySete displayUnidade(.entrada(unidade),.saidas(unidadePC));
   displaySete displayDezena(.entrada(dezena),.saidas(dezenaPC));
   displaySete displayCentena(.entrada(centena),.saidas(centenaPC));
	
   wire [1:0] controlesaida;
	wire [3:0] unidade,dezena,centena;
	  
	assign controlesaida=2'b01;
	  
	BCD bcd(.binario(pc_atual),.unidade(unidade),.dezena(dezena),.centena(centena),.controlesaida(controlesaida));
	
	

	
endmodule