module DeBounce(
    input clk,
    input reset,
    input button_in,
    output reg DB_out
);

    // Parameters
    parameter COUNTER_MAX = 20_000_000; // Ajuste para o tempo de debounce (exemplo: 20ms para 50MHz)

    // Internal signals
    reg [31:0] counter;
    reg button_sync1, button_sync2;
    reg button_stable;

    // Synchronize the button input to the clock domain
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            button_sync1 <= 0;
            button_sync2 <= 0;
        end else begin
            button_sync1 <= button_in;
            button_sync2 <= button_sync1;
        end
    end

    // Debounce logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            button_stable <= 0;
        end else begin
            if (button_sync2 != button_stable) begin
                // Button state changed, start counter
                counter <= counter + 1;
                if (counter >= COUNTER_MAX) begin
                    button_stable <= button_sync2;
                    counter <= 0; // Reset counter after stabilizing
                end
            end else begin
                counter <= 0; // Reset counter if no change
            end
        end
    end

    // Output the stable button state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            DB_out <= 0;
        end else begin
            DB_out <= button_stable;
        end
    end

endmodule
