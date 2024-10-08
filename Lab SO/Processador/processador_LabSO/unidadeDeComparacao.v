module unidadeDeComparacao(branchTipo,resultadoULA,resultadoComparacao);

input [31:0] resultadoULA;
input branchTipo;
output reg resultadoComparacao;

always@(resultadoULA)
  begin
    
	 case(branchTipo)
	 
	   1'b0: 
	    begin 
	      if(resultadoULA == 32'd0) 
  		     resultadoComparacao = 1'b1;
	  	 else
		    resultadoComparacao = 1'b0;
	    end  
	
       1'b1: 
	     begin 
	      if(resultadoULA != 32'd0) 
		     resultadoComparacao = 1'b1;
	   	else
		     resultadoComparacao = 1'b0;
	     end 
	
		
	 
	 endcase
 
  end 

endmodule


