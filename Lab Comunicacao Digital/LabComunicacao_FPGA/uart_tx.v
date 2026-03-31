module uart_tx #(parameter CLKS_PER_BIT = 5208)(

    input clk,
    input reset,

    input [7:0] data_in,
    input data_valid,

    output reg tx,
    output reg busy

);

// ===============================
// ESTADOS
// ===============================

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;

reg [1:0] state;

reg [12:0] clk_count;
reg [2:0] bit_index;

reg [7:0] tx_data;

// ===============================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        state <= IDLE;
        tx <= 1;
        busy <= 0;

        clk_count <= 0;
        bit_index <= 0;

    end
    else begin

        case (state)

        // =========================

        IDLE: begin

            tx <= 1;
            busy <= 0;

            if (data_valid) begin

                busy <= 1;
                tx_data <= data_in;

                clk_count <= 0;

                state <= START;

            end

        end

        // =========================

        START: begin

            tx <= 0;

            if (clk_count < CLKS_PER_BIT-1)

                clk_count <= clk_count + 1;

            else begin

                clk_count <= 0;
                bit_index <= 0;

                state <= DATA;

            end

        end

        // =========================

        DATA: begin

            tx <= tx_data[bit_index];

            if (clk_count < CLKS_PER_BIT-1)

                clk_count <= clk_count + 1;

            else begin

                clk_count <= 0;

                if (bit_index < 7)

                    bit_index <= bit_index + 1;

                else

                    state <= STOP;

            end

        end

        // =========================

        STOP: begin

            tx <= 1;

            if (clk_count < CLKS_PER_BIT-1)

                clk_count <= clk_count + 1;

            else begin

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