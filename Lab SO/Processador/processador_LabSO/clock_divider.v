/*module clock_divider(clock_in,clock_out);
  input clock_in; // input clock on FPGA
  output clock_out; // output clock after dividing the input clock by divisor
  
reg[27:0] counter=28'd0;
//parameter DIVISOR = 28'd60000;
parameter DIVISOR = 28'd5;
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
end
assign clock_out = (counter<DIVISOR/2)?1'b0:1'b1;
endmodule*/

module clock_divider(
    input wire clock_in,  // Sinal de entrada (clock da FPGA)
    output reg clock_out  // Sinal de saída (clock dividido)
);
    parameter DIVISOR = /*28'd5000000*/28'd3;  // Parâmetro para o divisor de frequência
    
    reg [27:0] counter = 28'd0;  // Registrador para contagem do clock
    
    always @(posedge clock_in) begin
        // Incrementa o contador
        counter <= counter + 28'd1;
        
        // Reinicia o contador e alterna o clock_out ao atingir o divisor
        if (counter >= (DIVISOR - 1)) begin
            counter <= 28'd0;          // Reinicia o contador
            clock_out <= ~clock_out;   // Alterna o clock de saída
        end
    end
endmodule
