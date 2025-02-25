module ULA(ulaOP,RS,RT,saidaULA,saidaHI,saidaLO);

input [31:0] RS,RT;
input  [4:0]ulaOP;

output reg[31:0] saidaULA,saidaHI,saidaLO;

parameter soma=5'b00000,subtracao=5'b00001,multiplicacao=5'b00010,divisao=5'b00011,restoDivisao=5'b00100,OPor=5'b00101,OPand=5'b00110,OPnot=5'b00111;
parameter OPxor=5'b01000,OPnor=5'b01001,OPnand=5'b01010,OPxnor=5'b01011,maior=5'b01110, seguidor = 5'b11111;

always@(*)
begin
  case(ulaOP)

    soma: saidaULA = RS + RT;
	 
	 subtracao : saidaULA = RS - RT;
	 
	  multiplicacao: 
	  begin
	   {saidaHI,saidaLO} = RS * RT;
		 saidaULA = saidaLO;
	  end
	 
	 divisao : saidaULA = RS / RT;
	 
	 restoDivisao : saidaULA = RS % RT; 
	 
	 OPor : saidaULA = RS || RT;
	 
	 OPand : saidaULA = RS && RT;
	 
	 OPnot : saidaULA =  ~RS;
	 
	 OPxor : saidaULA = RS ^ RT;
	 
	 OPnor : saidaULA = ~(RS || RT); 
	 
	 OPnand : saidaULA = ~(RS && RT);
	 
    OPxnor : saidaULA = ~(RS ^ RT);
	 
	 seguidor : saidaULA = RT; //apenas retorna valor
	 
	 maior :
	   begin
		   if(RS > RT) saidaULA = 32'd1;
			else saidaULA = 32'd0;
		end
  endcase 
end

endmodule 
