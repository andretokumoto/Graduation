module CPU(reset,clock,botaoPlaca,entradaDeDadosIO,unidade,dezena,centena,halt,ledmenu,lednumprocessos,ledprocesso,ledin,uniProc,enRD,enRS,enRT,testeMux,testeImediato,testeSelMux,testeRS,testeOPCODE,testePC,testeUla,testeReg,testedesvio,testeIN,testeStatus,testeSinal,testeout,controlIO,testeJump,testesaidaUNI,testesaidaDez,testesaidaCent,Testeprocesso_atual);

input clock,botaoPlaca,reset;
input [3:0] entradaDeDadosIO;
reg [31:0] concatena;
reg [31:0] resulSomador;
reg [31:0] imediatoExtendido;
reg [31:0] HILOdata;
reg [31:0] dadosEscrita;
reg [31:0] regHI,regLO;
reg [31:0] dadosRegistro;
reg [31:0] pc, pcsomado;
reg [31:0] operando;
wire[3:0] inUnidade,inDezena,inCentena,un,dez,cen;
reg [31:0] processo_atual;

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
wire [31:0] dadosMux6,desvioCorrigido;
wire [10:0] imediato;
wire [1:0] mudaProcesso; //criar na unidade de controle
wire ocorrenciaIO;
wire ledControl,comandoOUT,comandoIN;

wire [31:0] enderecoRelativo;
wire troca_contexto;
wire intrucaoIOContexto,fimprocesso;
wire clk;
wire  [1:0] entradaSaidaControl,encerrarBios;
wire valueULA;
wire  DesvioControl,branchControl,branchTipo,jumpControl,linkControl,memControl,HILOcontrol,escritaRegControl;//sinal 1 bit
wire  [2:0] dadoRegControl;//sinal de 3 bits
wire  [4:0] ulaOP;//sinal 5 bits 
wire [31:0] pc_contexto;
wire InstrucaIO,fimProcesso;
output wire [6:0] unidade,dezena,centena,uniProc;

output wire halt;
output reg ledmenu,lednumprocessos,ledprocesso,ledin;
output reg [31:0]testePC,testeReg,testeImediato,Testeprocesso_atual;
output wire testedesvio;
output wire [1:0] controlIO;
output wire testeStatus,testeSinal;
output wire [31:0] testeIN,testeout,testeUla,testeRS,testeMux;
output wire [3:0] testesaidaUNI,testesaidaDez,testesaidaCent;
output wire  [2:0] testeSelMux;
output wire[4:0] enRD,enRS,enRT;
output wire [25:0] testeJump;
output wire[5:0] testeOPCODE;

parameter Escalonador = 32'd1, IntrucaoIO = 32'd92,PCout = 32'd160;

//divisor de clock
clock_divider(.clock_in(clock),.clock_out(clk));

//ligaçao com pulso botao
// DeBouncebuton db(.clk(clk), .n_reset(reset), .button_in(botaoPlaca),.DB_out(botaoIN));
//monostable mon(.clk(clk),.reset(reset),.trigger(botaoPlaca),.pulse(botaoIN));
  
//ligaçao com memoria de instruçoes
MEMInstrucoes inst(.reset(reset),.pc(pc),.opcode(opcode),.jump(jump),.OUTrs(endRS),.OUTrt(endRT),.OUTrd(endRD),.imediato(imediato),.clock(clock),.biosEmExecucao(biosEmExecucao), .encerrarBios(encerrarBios));

//contador de quantum
ContadorDeQuantum quantum( .clock(clk),.reset(reset),.pc(pc),.InstrucaIO(ocorrenciaIO),.fimProcesso(fimProcesso),.processoAtual(processo_atual),.troca_contexto(troca_contexto),.pc_processo_trocado(pc_contexto),.intrucaoIOContexto(intrucaoIOContexto));

//ligaçao com unidade de controle
UnidadeDeControle uco(.opcode(opcode),.status(status),.ulaOP(ulaOP),.valueULA(valueULA),.DesvioControl(DesvioControl),.jumpControl(jumpControl),.linkControl(linkControl),.escritaRegControl(escritaRegControl),.branchControl(branchControl),.branchTipo(branchTipo),.dadoRegControl(dadoRegControl),.memControl(memControl),.HILOcontrol(HILOcontrol),.entradaSaidaControl(entradaSaidaControl),.mudaProcesso(mudaProcesso),.encerrarBios(encerrarBios),.fimprocesso(fimprocesso),.intrucaoIOContexto(ocorrenciaIO),.ledControl(ledControl),.comandoIN(comandoIN),.comandoOUT(comandoOUT));

//ligaçao com  parada de sistema
ParadaSistema mest(.clock(clk),.pausa(status),.botaoIN(botaoIN),.status(parada));

//ligaçao com banco registradores
BancoRegistradores br(.clk(clk),.escritaRegControl(escritaRegControl),.inRS(endRS),.inRT(endRT),.inRD(endRD),.dados(dadosMux6),.outRS(rs),.outRT(rt),.linkControl(linkControl));

//ligaçao com ULA
ULA alu(.ulaOP(ulaOP),.RS(rs),.RT(operando),.saidaULA(resultadoULA),.saidaHI(HI),.saidaLO(LO));

//ligaçao com unidade de comparaçao
unidadeDeComparacao compara(.branchTipo(branchTipo),.resultadoULA(resultadoULA),.resultadoComparacao(resultComparacao));

//ligacao mux6
mux6 muxRegistro(.dadoRegControl(dadoRegControl),.HiLoData(HILOdata),.resulULA(resultadoULA),.valorRegRS(rs),.dadoMEM(dadoMem),.dadosEntrada(dadosDeEntrada),.imediato(imediatoExtendido),.PC(pcsomado),.DadosRegistro(dadosMux6),.pc_contexto(pc_contexto));

//correção de endereço para memoria
EnderecoRelativo er(.numeroProcesso(processo_atual),.resultadoULA(resultadoULA),.enderecoRelativo(enderecoRelativo));

//correçao desvio
correcaoDesvio desvio( .desvioOriginal(imediatoExtendido),.processo_atual(processo_atual),.desvioCorrigido(desvioCorrigido) );


//ligaçao com memoria de dados
//simple_dual_port_ram_single_clock memPrincipal(.data(RT),.read_addr(resultadoULA),.write_addr(resultadoULA),.we(memControl),.clk(clock),.q(dadoMem));
simple_dual_port_ram_dual_clock mem(.data(rt),.read_addr(enderecoRelativo),.write_addr(enderecoRelativo),.we(memControl),.read_clock(clock),.write_clock(/*clk*/clock),.q(dadoMem));
	
//ligaçao com entrada e saida
EntradaSaida IO(.botaoIN(botaoIN),.endereco(resultadoULA),.dadosEscrita(dadoMem),.DadosLidos(dadosDeEntrada),.entradaSaidaControl(entradaSaidaControl),.clk(clk),.clock(clock),.entradaDeDados(entradaDeDadosIO),.unidade(inUnidade),.dezena(inDezena),.centena(inCentena));

//ligaçao com display
 displaySete displayUnidade(.entrada(inUnidade),.saidas(unidade));
 displaySete displayDezena(.entrada(inDezena),.saidas(dezena));
 displaySete displayCentena(.entrada(inCentena),.saidas(centena));
  
 BCD bcd(.binario(processo_atual),.unidade(un),.dezena(dez),.centena(cen),.controlesaida(entradaSaidaControl)); 
 displaySete displayprocessouni(.entrada(un),.saidas(uniProc));

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
assign testeOPCODE = opcode;


//************************************************************************************************************************************************************************************************************
 always@(negedge clk) //valores que vao entrar no mux de seleção da proxima instrução
	 
		 
   begin
		 
	    //testeImediato = desvioCorrigido;	
	   // testeReg = dadosRegistro;
		 
		 if(selecaoMuxDesvio) resulSomador <= pc + imediatoExtendido; //branch
		   else  resulSomador <= pcsomado; //atualização normal de PC
		 
		 if(jumpControl) concatena <= {pc[31:26],rs[25:0]};//concatenacao para o jump registrador
		   else concatena <= {pc[31:26],desvioCorrigido[25:0]};//concatenacao para o jump
			
	end
  

 
 //************************************************************************************************************************************************************************************************************ 
  
 always@(posedge clk or posedge reset)
  begin
       	 
			
		//atualização de pc
		
		
		
		   if(reset) pc<=32'd0;
			
			else if(encerrarBios==1'b1) pc<=32'd0;
			
			else if(troca_contexto == 1'b1) pc<= Escalonador; // desvia para o escalonador
			
			else if(intrucaoIOContexto == 1'b1) pc <= InstrucaIO; //desvia para IO

			else if (comandoOUT == 1'b1) pc <= PCout;//output de dados
			else 
			  begin
			    
				 if(parada) pc <= pc;
			
		      	else
			        begin
			
			          if(DesvioControl) pc <= concatena;  //jump
			          else pc <= resulSomador;
					
			      end	
			  end
				testePC = pc;
  end
 //****************************************************************************************************************************************************************************************************************** 
  always@(pc)
	begin
		pcsomado = pc + 32'd1;
	end

 //****************************************************************************************************************************************************************************************************************** 

 always@(mudaProcesso)
	begin
		if(mudaProcesso==1'b1) 
			begin
				processo_atual = imediatoExtendido;
				Testeprocesso_atual = processo_atual;
			end
	end
 //************************************************************************************************************************************************************************************************************* 
  always@(imediato)//extensor de bits
  begin
  
    imediatoExtendido = {21'b000000000000000000000,imediato};
	 testeImediato = imediatoExtendido;
    
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


always@(posedge clk || ledControl)
	begin
		if (reset)
			begin
				ledmenu = 1'b0;
				lednumprocessos = 1'b0;
				ledprocesso = 1'b0;
				ledin = 1'b0;
			end
		else if(ledControl)
			begin
				 if (imediato == 11'd1) ledmenu = 1'b1;
				 else if (imediato == 11'd2) ledmenu = 1'b0;
				 else if (imediato == 11'd3) ledin = 1'b1;
				 else if (imediato == 11'd4) ledin = 1'b0;
				 else if (imediato == 11'd5) lednumprocessos = 1'b1;
				 else if (imediato == 11'd6) lednumprocessos = 1'b0;
				 else if (imediato == 11'd7) ledprocesso = 1'b1;
				 else if (imediato == 11'd8) ledprocesso = 1'b0;
			end
	end


//***********************************************************************
 always@(imediatoExtendido,rt)//selecao de valor que vai para a ula(imediato ou RT)
  begin

     if(valueULA) operando = imediatoExtendido;
	   else operando = rt;
		
		 //testeOP = RT;
		
  end
//******************************************************************************************************************************************************************************************************* 
 
 
  
endmodule