module comunicacao_recebimento (
    input      clk,          // Clock de 50MHz
    input      rx,           // Entrada UART RX
    output reg [7:0] dado   // Última palavra de 8 bits recebida (disponível continuamente)
);

    wire [7:0] rx_data;
    wire rx_done;

    // Recepção UART
    uart_rx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) rx_inst (
        .clk(clk),
        .rx(rx),
        .data_out(rx_data),
        .done(rx_done)
    );

    // Armazena o último byte recebido — a CPU lê quando quiser
    always @(posedge clk) begin
        if (rx_done)
            dado <= rx_data;
    end

endmodule