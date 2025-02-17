module Gerenciador_memoria(
    input [31:0] numero_bloco_analisado,
    input [31:0] Bloco_para_analise_ram,
    input [31:0] Bloco_para_analise_hd,
    input clk,
    input reset,
    input [1:0] ControlePuxarDoH,
    input [1:0] VarrerMemoriaHD,
    output reg [31:0] enderecoHD,
    output reg [31:0] dadoLidoHD,
    output [1:0] controleAcessoHD,
    output ControleSalvarInstrucaoNaMemInst,
    output reg [1:0] ControleFimDeLeitura
);

    reg [31:0] blocos_de_memoria [3:0];
    reg [31:0] LinhaASerLida, cabecalhoDoBloco;
    reg [31:0] numero_bloco_analisado_extendido;
    reg [31:0] tamanhoDosBlocos [7:0];
    reg [31:0] contadorLeituraHD;
    reg [31:0] blocoNaVarredura = 32'd0;

    parameter Tamanho_bloco = 32'd200, TamMemoriaHD = 32'd4000;

    always @(numero_bloco_analisado) begin
        cabecalhoDoBloco = numero_bloco_analisado * Tamanho_bloco;
        LinhaASerLida = cabecalhoDoBloco + 32'd1; 
        contadorLeituraHD = LinhaASerLida + tamanhoDosBlocos[numero_bloco_analisado[7:0]];
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            blocoNaVarredura <= 32'd0;
        end
        else if (ControlePuxarDoH == 2'b01) begin
            enderecoHD <= LinhaASerLida;
            dadoLidoHD <= Bloco_para_analise_hd;
            LinhaASerLida <= LinhaASerLida + 32'd1;

            if (LinhaASerLida == contadorLeituraHD) begin
                ControleFimDeLeitura <= 2'b01;
            end
            else begin
                ControleFimDeLeitura <= 2'b00;
            end
        end
    end

    always @(negedge clk) begin
        if (LinhaASerLida == contadorLeituraHD) begin
            ControleFimDeLeitura <= 2'b01;
        end
        else begin
            ControleFimDeLeitura <= 2'b00;
        end
    end

endmodule