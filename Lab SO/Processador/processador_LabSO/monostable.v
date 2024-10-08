module monostable(
        input clk,
        input reset,
        input trigger,
        output reg pulse = 1
);

        parameter PULSE_WIDTH = 5'd1;

        reg [4:0] count = 0;

        wire count_rst = reset | (count == PULSE_WIDTH);

        always @ (posedge trigger, posedge count_rst)
		    begin
			 
                if (count_rst) 
					   begin
                      pulse <= 1'b0;
                  end 
						
					 else 
					    begin
                       if(trigger) pulse <= 1'b1;
                  end
						
         end

        always @ (posedge clk, posedge count_rst) 
		    begin
			 
                if(count_rst) 
					   begin
                       count <= 0;
                  end 
						
					 else 
					   begin
						
                      if(pulse) count <= count + 1'b1;            
                        
                 end
          end
			 
endmodule