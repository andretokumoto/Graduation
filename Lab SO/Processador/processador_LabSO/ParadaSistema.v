module ParadaSistema(clock,pausa,botaoIN,status);
  
  input botaoIN,clock;
  input pausa;
  output reg status;
  
  reg [1:0] estadoAtual,estadoFuturo;
  
  always@(pausa)
    begin
	 
	     case(estadoAtual)
		  
		   2'b00://sistema em execuçao
			 begin
			   
				if(pausa)//intruçao para pausa
				  begin
				    estadoFuturo = 2'b01;
					 status = 1'b1;
				  end
				  
				else //mantem estado
			     begin
				     estadoFuturo = 2'b00;
					  status = 1'b0;
				  end 
			 end
			 
			2'b01://sistema pausado
		     begin
			  
			    if(pausa)//mantem estado
				  begin
				    estadoFuturo = 2'b01;
					 status = 1'b1;
				  end
			    
				 else
				   begin
					  estadoFuturo = 2'b00;
					  status = 1'b1;
					end
			 
			  end 
			  
			 2'b10://executa com a instruçao de pausa
			   begin
			      estadoFuturo = 2'b00;
		         status = 1'b0;
	         end	
		  
		  endcase
	 end

	 
	 always@(posedge botaoIN or posedge clock)
	  begin
	      if(botaoIN) estadoAtual = 2'b10;
			else estadoAtual = estadoFuturo;
	  end
	 
	 
	 
	 
endmodule 