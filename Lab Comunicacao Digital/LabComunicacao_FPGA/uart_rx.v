// ============================================================
// uart_rx.v  –  Receptor UART padrão de 8 bits
// Parâmetros configuráveis: CLK_FREQ e BAUD_RATE
// Saída: data_out[7:0] e pulso done (1 ciclo) ao fim de cada byte
// ============================================================
module uart_rx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
) (
    input            clk,
    input            rx,
    output reg [7:0] data_out,
    output reg       done
);

localparam TICKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [15:0] tick_count = 0;
reg [2:0]  bit_index  = 0;
reg [1:0]  state      = 0;

always @(posedge clk) begin
    case (state)
        // -------------------------------------------------------
        // IDLE: aguarda borda de descida (start bit)
        // -------------------------------------------------------
        0: begin
            done       <= 0;
            tick_count <= 0;
            if (rx == 0)
                state <= 1;
        end

        // -------------------------------------------------------
        // START BIT: amostra no meio do bit para garantir estabilidade
        // -------------------------------------------------------
        1: begin
            if (tick_count == (TICKS_PER_BIT / 2) - 1) begin
                tick_count <= 0;
                state      <= 2;
            end else
                tick_count <= tick_count + 1;
        end

        // -------------------------------------------------------
        // DATA BITS: lê 8 bits (LSB primeiro)
        // -------------------------------------------------------
        2: begin
            if (tick_count == TICKS_PER_BIT - 1) begin
                tick_count          <= 0;
                data_out[bit_index] <= rx;
                if (bit_index == 7) begin
                    bit_index <= 0;
                    state     <= 3;
                end else
                    bit_index <= bit_index + 1;
            end else
                tick_count <= tick_count + 1;
        end

        // -------------------------------------------------------
        // STOP BIT: aguarda fim e pulsa done
        // -------------------------------------------------------
        3: begin
            if (tick_count == TICKS_PER_BIT - 1) begin
                done  <= 1;
                state <= 0;
            end else
                tick_count <= tick_count + 1;
        end
    endcase
end

endmodule