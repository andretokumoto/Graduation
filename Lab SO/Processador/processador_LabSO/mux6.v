module mux6(dadoRegControl,HiLoData,resulULA,valorRegRS,dadoMEM,dadosEntrada,imediato,PC,DadosRegistro,pc_contexto);

input [2:0] dadoRegControl;
input [31:0] HiLoData,resulULA,valorRegRS,dadoMEM,dadosEntrada,imediato,PC,pc_contexto;
output reg [31:0] DadosRegistro;


always @(*)
begin

case(dadoRegControl)

3'b000:DadosRegistro=HiLoData;
3'b001:DadosRegistro=resulULA;
3'b010:DadosRegistro=valorRegRS;
3'b011:DadosRegistro=dadoMEM;
3'b100:DadosRegistro=dadosEntrada;
3'b101:DadosRegistro=imediato;
3'b110:DadosRegistro=PC;
3'b111:DadosRegistro=pc_contexto;

endcase

end

endmodule