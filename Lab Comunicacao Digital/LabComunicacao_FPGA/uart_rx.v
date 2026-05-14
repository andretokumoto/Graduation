module uart_rx #(parameter CLK_FREQ = 50000000, parameter BAUD_RATE = 9600) (
    input        clk,
    input        rx,
    output reg [7:0] data_out,
    output reg       done
);

localparam TICKS_PER_BIT = CLK_FREQ / BAUD_RATE;
reg [15:0] tick_count = 0;
reg [2:0]  bit_index  = 0;
reg [1:0]  state      = 0;

always @(posedge clk) begin
    case (state)
        0: begin // IDLE: Aguarda o bit de start (RX indo para 0)
            done <= 0;
            tick_count <= 0;
            if (rx == 0) state <= 1;
        end
        1: begin // START BIT: Espera até a metade do bit para garantir estabilidade
            if (tick_count == (TICKS_PER_BIT / 2)) begin
                tick_count <= 0;
                state <= 2;
            end else tick_count <= tick_count + 1;
        end
        2: begin // DATA BITS: Lê os 8 bits
            if (tick_count == TICKS_PER_BIT - 1) begin
                tick_count <= 0;
                data_out[bit_index] <= rx;
                if (bit_index == 7) begin
                    bit_index <= 0;
                    state <= 3;
                end else bit_index <= bit_index + 1;
            end else tick_count <= tick_count + 1;
        end
        3: begin // STOP BIT: Aguarda o fim do bit de parada
            if (tick_count == TICKS_PER_BIT - 1) begin
                done <= 1;
                state <= 0;
            end else tick_count <= tick_count + 1;
        end
    endcase
end
endmodule