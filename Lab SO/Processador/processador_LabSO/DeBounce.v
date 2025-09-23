module DeBounce(
    input clk,
    input reset,
    input button_in,
    output reg button_out
);

    // Parâmetros para ajuste fácil
    localparam DEBOUNCE_TIME = 20'd500000; // ~50ms @ 10MHz

    // Sinais internos
    reg [19:0] counter;
    reg button_filtered;
    reg button_sync_1;
    reg button_sync_2;

    // Sincronizador de entrada para evitar metaestabilidade
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            button_sync_1 <= 1'b0;
            button_sync_2 <= 1'b0;
        end else begin
            button_sync_1 <= button_in;
            button_sync_2 <= button_sync_1;
        end
    end

    // Lógica principal do debounce
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 20'd0;
            button_filtered <= 1'b0;
            button_out <= 1'b0;
        end else begin
            // Se o sinal de entrada for diferente do sinal filtrado
            if (button_sync_2 != button_filtered) begin
                if (counter == DEBOUNCE_TIME) begin
                    button_filtered <= button_sync_2; // Atualiza o sinal filtrado
                    button_out <= button_sync_2;      // Atualiza a saída
                    counter <= 20'd0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end else begin
                counter <= 20'd0; // Sinal estável, reseta o contador
            end
        end
    end

endmodule
