module uart_rx #(parameter CLKS_PER_BIT = 5208)(

    input clk,
    input reset,

    input rx,

    output reg [7:0] data_out,
    output reg data_ready

);

// ===============================

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;

reg [1:0] state;

reg [12:0] clk_count;
reg [2:0] bit_index;

reg [7:0] rx_shift;

// ===============================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        state <= IDLE;

        clk_count <= 0;
        bit_index <= 0;

        data_ready <= 0;

    end
    else begin

        case (state)

        // =========================

        IDLE: begin

            data_ready <= 0;

            if (rx == 0) begin

                clk_count <= 0;

                state <= START;

            end

        end

        // =========================

        START: begin

            if (clk_count == (CLKS_PER_BIT/2)) begin

                clk_count <= 0;
                bit_index <= 0;

                state <= DATA;

            end
            else

                clk_count <= clk_count + 1;

        end

        // =========================

        DATA: begin

            if (clk_count < CLKS_PER_BIT-1)

                clk_count <= clk_count + 1;

            else begin

                clk_count <= 0;

                rx_shift[bit_index] <= rx;

                if (bit_index < 7)

                    bit_index <= bit_index + 1;

                else

                    state <= STOP;

            end

        end

        // =========================

        STOP: begin

            if (clk_count < CLKS_PER_BIT-1)

                clk_count <= clk_count + 1;

            else begin

                data_out <= rx_shift;
                data_ready <= 1;

                state <= IDLE;

            end

        end

        // =========================

        default:

            state <= IDLE;

        endcase

    end

end

endmodule