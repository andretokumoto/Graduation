module PC(
  input [31:0] pc_atual,
  input [5:0] opcode,
  output reg [31:0] processo_atual,
  output reg ledmenu,
  output reg lednumprocessos,
  output reg ledprocesso,
  output reg ledin

);
  parameter in=6'b011101,out=6'b011110;

  always@(opcode)
    begin
	 
	    if(opcode == in) 
			begin
				ledin = 1'b1;
				
				if(pc_atual < 32'd300)       processo_atual = 32'd0;
				
				if(pc_atual == 32'd41)  ledmenu = 1'b1;
				
				if(pc_atual == 32'd56)  lednumprocessos = 1'b1;
				
				else
					begin
						
						ledprocesso = 1'b1;
						
						if(pc_atual < 32'd600)  processo_atual = 32'd1;
						else if(pc_atual < 32'd900)  processo_atual = 32'd2;
						else if(pc_atual < 32'd1200) processo_atual = 32'd3;
						else if(pc_atual < 32'd1500) processo_atual = 32'd4;
						else if(pc_atual < 32'd1800) processo_atual = 32'd5;
						else if(pc_atual < 32'd2100) processo_atual = 32'd6;
						else if(pc_atual < 32'd2400) processo_atual = 32'd7;
						else if(pc_atual < 32'd2700) processo_atual = 32'd8;
						else if(pc_atual < 32'd3000) processo_atual = 32'd9;
						else if(pc_atual < 32'd3300) processo_atual = 32'd10;
					end
			end
			
		else if (opcode == out) 
			begin
			
				if(pc_atual < 32'd300)       processo_atual = 32'd0;
				
				else
					begin
						
						ledprocesso = 1'b1;
						
						if(pc_atual < 32'd600)  processo_atual = 32'd1;
						else if(pc_atual < 32'd900)  processo_atual = 32'd2;
						else if(pc_atual < 32'd1200) processo_atual = 32'd3;
						else if(pc_atual < 32'd1500) processo_atual = 32'd4;
						else if(pc_atual < 32'd1800) processo_atual = 32'd5;
						else if(pc_atual < 32'd2100) processo_atual = 32'd6;
						else if(pc_atual < 32'd2400) processo_atual = 32'd7;
						else if(pc_atual < 32'd2700) processo_atual = 32'd8;
						else if(pc_atual < 32'd3000) processo_atual = 32'd9;
						else if(pc_atual < 32'd3300) processo_atual = 32'd10;
					end
			end
		
		else
			begin
			  ledmenu = 1'b0;
			  lednumprocessos= 1'b0;
			  ledprocesso= 1'b0;
			  ledin= 1'b0;
			end
	
	 end

endmodule