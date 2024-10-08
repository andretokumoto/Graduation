module PC(clock,reset,atualPC,somador,jump,desviocontrol);
  
  input [31:0] somador,jump;
  input desviocontrol,clock,reset;
  output reg[31:0] atualPC;

  always@(posedge clock or posedge reset)
    begin
	 
	    if(reset) atualPC = 32'd0;
		 
		 else
		   begin
			
			   if(desviocontrol) atualPC = jump;
				else atualPC = somador;
			
			end
	
	 end

endmodule