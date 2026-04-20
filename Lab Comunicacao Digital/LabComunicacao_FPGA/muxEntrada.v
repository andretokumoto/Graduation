module muxEntrada(tipoEntrada,DadosLidos,dadoLidoArduinoExtendido,dadosDeEntrada );

input [1:0] tipoEntrada;
input [31:0] DadosLidos,dadoLidoArduinoExtendido;
output reg [31:0] dadosDeEntrada;


always @(*)
begin

case(tipoEntrada)

2'b01:dadosDeEntrada=DadosLidos;
2'b10:dadosDeEntrada=dadoLidoArduinoExtendido;
default : dadosDeEntrada = 32'd0;


endcase

end

endmodule