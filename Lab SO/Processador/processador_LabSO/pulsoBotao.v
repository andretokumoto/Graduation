module pulsoBotao(botaoplaca,clk,reset,pulso);

input botaoplaca,clk,reset;
output wire pulso;

wire pulsoDebauce;

//DeBounce db(.clk(clk),.reset(reset),.button_in(botaoplaca),.DB_out(pulsoDebauce));

monostable mon(.clk(clk),.reset(reset),.trigger(pulsoDebauce),.pulse(pulso));


endmodule