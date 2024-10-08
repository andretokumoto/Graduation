module muxDesvio(selecaoMux,imediato,desvio);

input selecaoMux;
input[31:0] imediato;
output reg[31:0] desvio;

always@(imediato)
  begin
     if(selecaoMux) desvio = imediato;
	    else desvio=32'd1;
  end

endmodule