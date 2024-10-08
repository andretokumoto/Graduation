module CPU(reset,clock,botaoPlaca,entradaDeDadosIO,unidade,dezena,centena,halt/*,enRD,enRS,enRT,testeMux,testeImediato,testeSelMux,testeRS,testeOP,testePC,testeUla,testeReg,testepulso,testeIN,testeStatus,testeSinal,testeout,controlIO,testeD*/);

input clock,botaoPlaca,reset;
input [3:0] entradaDeDadosIO;

reg [31:0] concatena;
reg [31:0] resulSomador;
reg [31:0] imediatoExtendido;
reg [31:0] HILOdata;
reg [31:0] dadosEscrita;
reg [31:0] regHI,regLO;
reg [31:0] dadosRegistro;
reg [31:0] PC;
reg [31:0] operando;
wire[3:0] inUnidade,inDezena,inCentena;


wire botaoIN;
wire selecaoMuxDesvio;
wire parada;
wire status;
wire [5:0] opcode;
wire [4:0] endRD,endRS,endRT;
wire [31:0] RS,RT;
wire [31:0] resultadoULA;
wire [31:0] HI,LO; 
wire [31:0] dadoMem;
wire [31:0] dadosDeEntrada;
wire resultComparacao;
wire [31:0] jump;
wire [31:0] dadosMux6;
wire [10:0] imediato;

wire clk;
wire  [1:0] entradaSaidaControl;
wire valueULA;
wire  DesvioControl,branchControl,branchTipo,jumpControl,linkControl,memControl,HILOcontrol,escritaRegControl;//sinal 1 bit
wire  [2:0] dadoRegControl;//sinal de 3 bits
wire  [4:0] ulaOP;//sinal 5 bits 

output wire [6:0] unidade,dezena,centena;
output wire halt;
/*output reg [31:0]testePC;testeReg,testeOP,testeImediato;
output wire testepulso;
output wire [1:0] controlIO;
output wire testeStatus,testeSinal;
output wire [31:0] testeIN,testeout,testeUla,testeRS,testeMux;
output wire [3:0] testeD;
output wire  [2:0] testeSelMux;
output wire[4:0] enRD,enRS,enRT;*/

//divisor de clock
clock_divider(.clock_in(clock),.clock_out(clk));

//ligaçao com pulso botao
monostable mon(.clk(clk),.reset(reset),.trigger(botaoPlaca),.pulse(botaoIN));
  
//ligaçao com memoria de instruçoes
MEMInstrucoes inst(.pc(PC),.opcode(opcode),.jump(jump),.OUTrs(endRS),.OUTrt(endRT),.OUTrd(endRD),.imediato(imediato),.clock(clock));

//ligaçao com unidade de controle
UnidadeDeControle UC(.opcode(opcode),.status(status),.ulaOP(ulaOP),.valueULA(valueULA),.DesvioControl(DesvioControl),.jumpControl(jumpControl),.linkControl(linkControl),.escritaRegControl(escritaRegControl),.branchControl(branchControl),.branchTipo(branchTipo),.dadoRegControl(dadoRegControl),.memControl(memControl),.HILOcontrol(HILOcontrol),.entradaSaidaControl(entradaSaidaControl));

//ligaçao com  parada de sistema
ParadaSistema mest(.clock(clk),.pausa(status),.botaoIN(botaoIN),.status(parada));

//ligaçao com banco registradores
BancoRegistradores BR(.clk(clk),.escritaRegControl(escritaRegControl),.inRS(endRS),.inRT(endRT),.inRD(endRD),.dados(dadosMux6),.outRS(RS),.outRT(RT),.linkControl(linkControl));

//ligaçao com ULA
ULA alu(.ulaOP(ulaOP),.RS(RS),.RT(operando),.saidaULA(resultadoULA),.saidaHI(HI),.saidaLO(LO));

//ligaçao com unidade de comparaçao
unidadeDeComparacao compara(.branchTipo(branchTipo),.resultadoULA(resultadoULA),.resultadoComparacao(resultComparacao));

//ligacao mux6
mux6 muxRegistro(.dadoRegControl(dadoRegControl),.HiLoData(HILOdata),.resulULA(resultadoULA),.valorRegRS(RS),.dadoMEM(dadoMem),.dadosEntrada(dadosDeEntrada),.imediato(imediatoExtendido),.PC(PC),.DadosRegistro(dadosMux6));

//ligaçao com memoria de dados
//simple_dual_port_ram_single_clock memPrincipal(.data(RT),.read_addr(resultadoULA),.write_addr(resultadoULA),.we(memControl),.clk(clock),.q(dadoMem));
simple_dual_port_ram_dual_clock mem(.data(RT),.read_addr(resultadoULA),.write_addr(resultadoULA),.we(memControl),.read_clock(clock),.write_clock(clk),.q(dadoMem));
	

//ligaçao com entrada e saida
EntradaSaida IO(.botaoIN(botaoIN),.endereco(resultadoULA),.dadosEscrita(dadoMem),.DadosLidos(dadosDeEntrada),.entradaSaidaControl(entradaSaidaControl),.clk(clk),.clock(clock),.entradaDeDados(entradaDeDadosIO),.unidade(inUnidade),.dezena(inDezena),.centena(inCentena));

//ligaçao com display
 displaySete displayUnidade(.entrada(inUnidade),.saidas(unidade));
 displaySete displayDezena(.entrada(inDezena),.saidas(dezena));
 displaySete displayCentena(.entrada(inCentena),.saidas(centena));

assign selecaoMuxDesvio = branchControl & resultComparacao;

assign halt = parada;
/*assign testeSinal = selecaoMuxDesvio;
assign testeStatus = resultComparacao;
assign testeIN = dadosDeEntrada;
assign testeout = dadoMem;
assign controlIO = entradaSaidaControl;
assign testeD = inUnidade;
assign testeUla = resultadoULA;
assign testeSelMux = dadoRegControl;
assign testeRS = RS;
assign enRD = endRD;
assign enRS = endRS;
assign enRT = endRT;
assign testeMux = dadosMux6;*/


//************************************************************************************************************************************************************************************************************
 always@(negedge clk) //valores que vao entrar no mux de seleção da proxima instrução
	 
		 
   begin
		 
	  //testeImediato = imediatoExtendido;	
	   //testeReg = dadosRegistro;
		 
		 if(selecaoMuxDesvio) resulSomador = PC + imediatoExtendido;
		   else  resulSomador = PC + 32'd1;
		 
		 if(jumpControl) concatena = {PC[31:26],RS[25:0]};//concatenacao para o jump registrador
		   else concatena = {PC[31:26],jump};//concatenacao para o jump
			
	end
  

 
 //************************************************************************************************************************************************************************************************************ 
  
 always@(posedge clk or posedge reset)
  begin
       
			//testePC = PC;
			 
	  
		//atualização de pc
		   if(reset) PC=32'd0;
			
			else 
			  begin
			    
				 if(parada) PC = PC;
			
		      	else
			        begin
			
			          if(DesvioControl) PC <= concatena;  //jump
			          else PC = resulSomador;
					
			      end	
			  end		
   

  end
 //****************************************************************************************************************************************************************************************************************** 
 /* always@(negedge clock)//mux de selecao de dados que vao entrar no banco de registradores
  begin
    if (linkControl) dadosRegistro = PC;
	 else dadosRegistro = dadosMux6;
  end*/
  
 //************************************************************************************************************************************************************************************************************* 
  always@(*)//extensor de bits
  begin
  
     if(imediato[10]==1'b0) imediatoExtendido = {21'b000000000000000000000,imediato};
     else imediatoExtendido = {21'b111111111111111111111,imediato};
	 
  
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
  
  always@(*)//seleçao do valor que vai para o mux de seleção para o banco de registradores em mfHI,mfLO
   begin
	

	 if(HILOcontrol) HILOdata = regHI;
	 else  HILOdata = regLO;
	end
  
  
 //************************************************************************************************************************************************************************************************************* 

 always@(*)//selecao de valor que vai para a ula(imediato ou RT)
  begin

     if(valueULA) operando = imediatoExtendido;
	   else operando = RT;
		
		 //testeOP = RT;
		
  end
//******************************************************************************************************************************************************************************************************* 
 
 
  
endmodule