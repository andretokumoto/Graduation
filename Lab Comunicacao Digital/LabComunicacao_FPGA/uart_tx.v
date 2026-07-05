module uart_tx #(parameter CLK_FREQ = 50000000, parameter BAUD_RATE = 9600) (
    input       clk,
    input       start,
    input [7:0] data_in,
    output reg  tx,
    output reg  ready
);

localparam TICKS_PER_BIT = CLK_FREQ / BAUD_RATE;
reg [15:0] tick_count = 0;
reg [2:0]  bit_index  = 0;
reg [1:0]  state      = 0;
reg [7:0]  data_reg   = 0;

initial tx = 1; // Linha UART em repouso fica em HIGH

always @(posedge clk) begin
    case (state)
        0: begin // IDLE
            ready <= 1;
            tx <= 1;
            if (start) begin
                data_reg <= data_in;
                ready <= 0;
                state <= 1;
            end
        end
        1: begin // START BIT
            tx <= 0;
            if (tick_count == TICKS_PER_BIT - 1) begin
                tick_count <= 0;
                state <= 2;
            end else tick_count <= tick_count + 1;
        end
        2: begin // DATA BITS
            tx <= data_reg[bit_index];
            if (tick_count == TICKS_PER_BIT - 1) begin
                tick_count <= 0;
                if (bit_index == 7) begin
                    bit_index <= 0;
                    state <= 3;
                end else bit_index <= bit_index + 1;
            end else tick_count <= tick_count + 1;
        end
        3: begin // STOP BIT
            tx <= 1;
            if (tick_count == TICKS_PER_BIT - 1) begin
                tick_count <= 0;
                state <= 0;
            end else tick_count <= tick_count + 1;
        end
    endcase
end
endmodule