module BCD(binario,unidade,dezena,centena,controlesaida);

input [31:0] binario;
input [1:0] controlesaida;
output reg [3:0] unidade,dezena,centena;

integer i;

  always@(binario)
    begin
		 if(controlesaida==2'b01)
			begin
				 unidade = 4'd0;
				 dezena = 4'd0;
				 centena = 4'd0;
			  
				 for(i=31; i >=0 ; i=i-1)
					begin 
					  
					  if(centena >= 5)
						  centena = centena+3;
						  
					  if(dezena >= 5)
						  dezena = dezena+3;
						  
					  if(unidade >= 5)
						  unidade = unidade+3;
						  
					  centena = centena << 1;
					  centena[0] = dezena[3];
					  dezena = dezena << 1;	
					  dezena[0] = unidade[3];
					  unidade = unidade << 1;
					  unidade[0] = binario[i];	  
					end			  
			end
	 end


endmodule 