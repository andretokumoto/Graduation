module UnidadeDeControle(opcode,status,ulaOP,valueULA,DesvioControl,jumpControl,linkControl,escritaRegControl,branchControl,branchTipo,dadoRegControl,memControl,HILOcontrol,entradaSaidaControl,mudaProcesso,encerrarBios,);

input [5:0] opcode;
output reg DesvioControl,HILOcontrol,branchControl,branchTipo,jumpControl,escritaRegControl,valueULA,linkControl,memControl;//sinal 1 bit
output reg status = 0;
output reg  [1:0] entradaSaidaControl,encerrarBios;//sinal 2 bits
output reg  [2:0] dadoRegControl;//sinal de 3 bits
output reg  [4:0] ulaOP;//sinal 5 bits 
output reg mudaProcesso,fimprocesso,intrucaoIOContexto;



//opcode de cada operaçao
parameter add=6'b000000,addi=6'b000001,sub=6'b000010,subi=6'b000011,mult=6'b000100,multi=6'b000101,div=6'b000110,divi=6'b000111,rdiv=6'b001000;
parameter OR=6'b001001,AND=6'b001010,NOT=6'b001011,XOR=6'b001100,NOR=6'b001101,NAND=6'b001110,XNOR=6'b001111,LT=6'b010000;
parameter jump=6'b010001,jumpR=6'b010010,jal=6'b010011,beq=6'b010100,bne=6'b010101,blt=6'b010110;
parameter lw=6'b010111,sw=6'b011000;
parameter mov=6'b011001,movi=6'b011010,mfhi=6'b011011,mflo=6'b011100;
parameter in=6'b011101,out=6'b011110,fim=6'b011111,pause=6'b100000,spc = 6'b100110;
//op de SO
parameter scpc = 6'b100001, scrg=6'b100010, cproc = 6'b100011;


                               
always@(opcode)
 begin
 
   case(opcode)
	
	 add:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00000;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
    
	 addi:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00000;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
		
	 sub:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00001;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
		
	 subi:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00001;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
	 
	 
	 mult:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
	 
	 multi:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
	 
	div:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00011;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	

	 divi:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00011;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end	
	
   rdiv:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00100;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 	
	 
	OR:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00101;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 	 
		
	AND:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00110;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	

    NOT:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b00111;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	

    XOR:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b01000;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	

    NOR:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b01001;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	

     NAND:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b01010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	

     XNOR:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b01011;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 	
	
     LT:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b001;
		  ulaOP = 5'b01110;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
		
	 jump:
	   begin
		
		  DesvioControl = 1'b1;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 	
		
	  jumpR:
	   begin
		
		  DesvioControl = 1'b1;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b1;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	
    jal:
	   begin
		
		  DesvioControl = 1'b1;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b1;
		  memControl= 1'b0;
		  dadoRegControl = 3'b110;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end	
	 
	

   beq:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b1;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  ulaOP = 5'b00001;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
 

    bne:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b1;
		  branchTipo= 1'b1;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  ulaOP = 5'b00001;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end
 
 
     blt:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b1;
		  branchTipo= 1'b1;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;	  
		  entradaSaidaControl = 2'b00;
		  ulaOP = 5'b01110; 
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end

   
    lw:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b011;
		  ulaOP = 5'b00010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
		
	 sw:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b1;
		  entradaSaidaControl = 2'b00;
		  ulaOP = 5'b00010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
	
    spc:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b1;
		  memControl= 1'b0;
		  dadoRegControl = 3'b110;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end  
	
	 mov:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 	

		
	 movi:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  dadoRegControl = 3'b101;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 	
		
	 mfhi:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  HILOcontrol = 1'b1;
		  dadoRegControl = 3'b000;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
   
	mflo:
	   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b00;
		  HILOcontrol = 1'b0;
		  dadoRegControl = 3'b000;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 
  
  in:
   begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b1;
		  valueULA= 1'b0;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b10;
		  dadoRegControl = 3'b100;
		  status=1'b1;
		  ulaOP = 5'b00010;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 

  out:
    begin
		
		  DesvioControl = 1'b0;
		  branchControl = 1'b0;
		  branchTipo= 1'b0;
		  jumpControl= 1'b0;
		  escritaRegControl= 1'b0;
		  valueULA= 1'b1;
		  linkControl = 1'b0;
		  memControl= 1'b0;
		  entradaSaidaControl = 2'b01;
		  dadoRegControl = 3'b000;
		  ulaOP = 5'b00010;
		  status=1'b0;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
		end 


   pause:
     begin
	     escritaRegControl= 1'b0;
	     jumpControl= 1'b0;
	     DesvioControl = 1'b0;
		  branchControl = 1'b0;
	     memControl= 1'b0;
	     entradaSaidaControl = 2'b00;
		  status=1'b1;
		  mudaProcesso = 1'b0;
		  fimprocesso	= 1'b0;
		  intrucaoIOContexto = 1'b0;
		  encerrarBios = 2'b00;
		  
	  end 
		
		
 endcase


 end	
 
		
endmodule
