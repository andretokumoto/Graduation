module tratamentoBotao(botaoPlaca,clock,pulso);

  input botaoPlaca,clock;
  output reg pulso;

  reg[1:0] estadoAtual,estadoFuturo;
  reg[4:0] contAuta,contBaixa;


  always@(posedge botaoPlaca)
   begin
	  
	  case(estadoAtual)
	  
	    2'b00://botao off
		   begin
			   
				 if(botaoPlaca)//talvez tirar
				  begin
				    pulso = 1'b1;
	             estadoFuturo = 2'b01;
				  end
				   
			end
			
		2'b01://botao alta
		   begin
			   
				
				   
			end
	
		2'b10://botao baixa
		   begin
			   
				
				   
			end
	   endcase		
	
	end
  
  
endmodule