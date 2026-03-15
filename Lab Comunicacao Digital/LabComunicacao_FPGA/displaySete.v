module displaySete(entrada,saidas);
 
 output reg [6:0] saidas;
 input[3:0] entrada;
 reg  [6:0] segmentos;

 always @(entrada)
  begin
   case(entrada)
    4'b0000: segmentos=7'b0000001;
    4'b0001: segmentos=7'b1001111;
    4'b0010: segmentos=7'b0010010;
    4'b0011: segmentos=7'b0000110;
    4'b0100: segmentos=7'b1001100;
    4'b0101: segmentos=7'b0100100;
    4'b0110: segmentos=7'b0100000;
    4'b0111: segmentos=7'b0001111;
    4'b1000: segmentos=7'b0000000;
    4'b1001: segmentos=7'b0000100;
	default: segmentos = 7'b1111111;
   endcase 
  
    {saidas} = segmentos;
	
  end
endmodule