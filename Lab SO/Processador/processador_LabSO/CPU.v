module CPU(reset,clock,botaoPlaca/*,entradaDeDadosIO,unidade,dezena,centena*/,halt,enRD,enRS,enRT,testeMux,testeImediato,testeSelMux,testeRS,testeOP,testePC,testeUla,testeReg,testedesvio,testeIN,testeStatus,testeSinal,testeout,controlIO,testeJump,testesaidaUNI,testesaidaDez,testesaidaCent);

input clock,botaoPlaca,reset;
//input [3:0] entradaDeDadosIO;
reg [31:0] concatena;
reg [31:0] resulSomador;
reg [31:0] imediatoExtendido;
reg [31:0] HILOdata;
reg [31:0] dadosEscrita;
reg [31:0] regHI,regLO;
reg [31:0] dadosRegistro;
reg [31:0] pc, pcsomado;
reg [31:0] operando;
wire[3:0] inUnidade,inDezena,inCentena;


wire botaoIN;
wire selecaoMuxDesvio;
wire parada;
wire status;
wire [5:0] opcode;
wire [4:0] endRD,endRS,endRT;
wire [31:0] rs,rt;
wire [31:0] resultadoULA;
wire [31:0] HI,LO; 
wire [31:0] dadoMem;
wire [31:0] dadosDeEntrada;
wire resultComparacao;
wire [25:0] jump;
wire [31:0] dadosMux6;
wire [10:0] imediato;


wire [1:0] troca_contexto;
wire clk;
wire  [1:0] entradaSaidaControl;
wire valueULA;
wire  DesvioControl,branchControl,branchTipo,jumpControl,linkControl,memControl,HILOcontrol,escritaRegControl;//sinal 1 bit
wire  [2:0] dadoRegControl;//sinal de 3 bits
wire  [4:0] ulaOP;//sinal 5 bits 

//output wire [6:0] unidade,dezena,centena;
output wire halt;
output reg [31:0]testePC,testeReg,testeOP,testeImediato;
output wire testedesvio;
output wire [1:0] controlIO;
output wire testeStatus,testeSinal;
output wire [31:0] testeIN,testeout,testeUla,testeRS,testeMux;
output wire [3:0] testesaidaUNI,testesaidaDez,testesaidaCent;
output wire  [2:0] testeSelMux;
output wire[4:0] enRD,enRS,enRT;
output wire [25:0] testeJump;

parameter Escalonador = 32'd0;

//divisor de clock
clock_divider(.clock_in(clock),.clock_out(clk));

//ligaçao com pulso botao
monostable mon(.clk(clk),.reset(reset),.trigger(botaoPlaca),.pulse(botaoIN));
  
//ligaçao com memoria de instruçoes
MEMInstrucoes inst(.reset(reset),.pc(pc),.opcode(opcode),.jump(jump),.OUTrs(endRS),.OUTrt(endRT),.OUTrd(endRD),.imediato(imediato),.clock(clock));

//ligaçao com unidade de controle
UnidadeDeControle uco(.opcode(opcode),.status(status),.ulaOP(ulaOP),.valueULA(valueULA),.DesvioControl(DesvioControl),.jumpControl(jumpControl),.linkControl(linkControl),.escritaRegControl(escritaRegControl),.branchControl(branchControl),.branchTipo(branchTipo),.dadoRegControl(dadoRegControl),.memControl(memControl),.HILOcontrol(HILOcontrol),.entradaSaidaControl(entradaSaidaControl));

//ligaçao com  parada de sistema
ParadaSistema mest(.clock(clk),.pausa(status),.botaoIN(botaoIN),.status(parada));

//ligaçao com banco registradores
BancoRegistradores br(.clk(clk),.escritaRegControl(escritaRegControl),.inRS(endRS),.inRT(endRT),.inRD(endRD),.dados(dadosMux6),.outRS(rs),.outRT(rt),.linkControl(linkControl));

//ligaçao com ULA
ULA alu(.ulaOP(ulaOP),.RS(rs),.RT(operando),.saidaULA(resultadoULA),.saidaHI(HI),.saidaLO(LO));

//ligaçao com unidade de comparaçao
unidadeDeComparacao compara(.branchTipo(branchTipo),.resultadoULA(resultadoULA),.resultadoComparacao(resultComparacao));

//ligacao mux6
mux6 muxRegistro(.dadoRegControl(dadoRegControl),.HiLoData(HILOdata),.resulULA(resultadoULA),.valorRegRS(rs),.dadoMEM(dadoMem),.dadosEntrada(dadosDeEntrada),.imediato(imediatoExtendido),.PC(pcsomado),.DadosRegistro(dadosMux6));

//ligaçao com memoria de dados
//simple_dual_port_ram_single_clock memPrincipal(.data(RT),.read_addr(resultadoULA),.write_addr(resultadoULA),.we(memControl),.clk(clock),.q(dadoMem));
simple_dual_port_ram_dual_clock mem(.data(rt),.read_addr(resultadoULA),.write_addr(resultadoULA),.we(memControl),.read_clock(clock),.write_clock(/*clk*/clock),.q(dadoMem));
	


//ligaçao com entrada e saida
EntradaSaida IO(.botaoIN(botaoIN),.endereco(resultadoULA),.dadosEscrita(dadoMem),.DadosLidos(dadosDeEntrada),.entradaSaidaControl(entradaSaidaControl),.clk(clk),.clock(clock),.entradaDeDados(entradaDeDadosIO),.unidade(inUnidade),.dezena(inDezena),.centena(inCentena));

//ligaçao com display
 /*displaySete displayUnidade(.entrada(inUnidade),.saidas(unidade));
 displaySete displayDezena(.entrada(inDezena),.saidas(dezena));
 displaySete displayCentena(.entrada(inCentena),.saidas(centena));*/
   
assign selecaoMuxDesvio = branchControl & resultComparacao;

assign halt = parada;
assign testeStatus = resultComparacao;
assign testeIN = dadosDeEntrada;
assign testeout = dadoMem;
assign controlIO = entradaSaidaControl;
assign testeJump = jump;
assign testeUla = resultadoULA;
assign testeSelMux = dadoRegControl;
assign testeRS = rs;
assign enRD = endRD;
assign enRS = endRS;
assign enRT = endRT;
assign testeMux = dadosMux6;
assign testeSinal = clk;
//assign clk = clock;//
assign botaoIN = botaoPlaca;
assign testesaidaUNI = inUnidade;
assign testesaidaDez = inDezena;
assign testesaidaCent = inCentena;
assign testedesvio = DesvioControl;


//************************************************************************************************************************************************************************************************************
 always@(negedge clk) //valores que vao entrar no mux de seleção da proxima instrução
	 
		 
   begin
		 
	    testeImediato = imediatoExtendido;	
	    testeReg = dadosRegistro;
		 
		 if(selecaoMuxDesvio) resulSomador <= {pc[31:11],imediato};
		   else  resulSomador <= pc + 32'd1;
		 
		 if(jumpControl) concatena <= {pc[31:26],rs[25:0]};//concatenacao para o jump registrador
		   else concatena <= {pc[31:11],imediato};//concatenacao para o jump
			
	end
  

 
 //************************************************************************************************************************************************************************************************************ 
  
 always@(posedge clk or posedge reset)
  begin
       	 
			testePC = pc;
		//atualização de pc
		   if(reset) pc<=32'd0;
			
			else if(troca_contexto == 2'b11) pc<= Escalonador; // desvia para o escalonador
			
			else 
			  begin
			    
				 if(parada) pc <= pc;
			
		      	else
			        begin
			
			          if(DesvioControl) pc <= concatena;  //jump
			          else pc <= resulSomador;
					
			      end	
			  end

  end
 //****************************************************************************************************************************************************************************************************************** 
  always@(pc)
	begin
		pcsomado = pc + 32'd1;
	end

  
 //************************************************************************************************************************************************************************************************************* 
  always@(imediato)//extensor de bits
  begin
  
    imediatoExtendido = {21'b000000000000000000000,imediato};
    
  end
  
//*************************************************************************************************************************************************************************************************************
  
  //gerenciamento do banco reservado de Hi e LO
  always@(HI,LO)//salva dados no banco de hi e lo sempre que houver as operações de divisao e multiplicação 
  begin
     if((ulaOP==5'b00010) | (ulaOP==5'b00011))
	    begin
          regHI = HI;
		    regLO = LO;	
		 end	 
  end
  
 //************************************************************************************************************************************************************************************************************* 
  
  always@(HILOcontrol)//seleçao do valor que vai para o mux de seleção para o banco de registradores em mfHI,mfLO
   begin
	

	 if(HILOcontrol) HILOdata = regHI;
	 else  HILOdata = regLO;
	end
  
  
 //************************************************************************************************************************************************************************************************************* 

 always@(imediatoExtendido,rt)//selecao de valor que vai para a ula(imediato ou RT)
  begin

     if(valueULA) operando = imediatoExtendido;
	   else operando = rt;
		
		 //testeOP = RT;
		
  end
//******************************************************************************************************************************************************************************************************* 
 
 
  
endmodule