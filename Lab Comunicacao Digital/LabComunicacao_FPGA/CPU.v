module CPU(
    input reset,
    input clock,
    input botaoPlaca,
    input [3:0] entradaDeDadosIO,
	 input entradaUART,
	 output wire saidaUART,
    output wire [6:0] unidade,
    output wire [6:0] dezena,
    output wire [6:0] centena,
    output wire halt,
    output reg ledmenu,
    output reg lednumprocessos,
    output reg ledprocesso,
    output reg ledin,
	 output wire [6:0] unidadePC,
    output wire [6:0] dezenaPC,
    output wire [6:0] centenaPC,
	 output wire sinal_busy,
	 output wire sinal_recebe,
	 output wire teste_recebimento,
	 output wire teste_envio

	 //***********************testes***********************
	/*
	 output wire [6:0] uniProc,
	 output wire testeSinal,
	 output reg [31:0] testePC,
    output wire [4:0] enRD,
    output wire [4:0] enRS,
    output wire [4:0] enRT,
    output wire [31:0] testeDadosMux,
    output reg [31:0] testeImediato,
    output wire [2:0] testeSelMux,
    output wire [31:0] ValorRS,
	 output wire [31:0] ValorRT,
    output wire [5:0] testeOPCODE,
    output wire testeDesvioControl,
	 output wire testeBranchControl,
    output wire testeSelecaoMuxDesvio,
    output wire testeResultComparacao,
    output wire [31:0] testeIN,
    output wire [31:0] testedadoMem,
    output wire [31:0] testeUla,
    output wire [3:0] testesaidaUNI,
    output wire [3:0] testesaidaDez,
    output wire [3:0] testesaidaCent,
    output wire [25:0] testeJump,
    output reg [31:0] Testeprocesso_atual,
	 output reg [31:0] testeoperando,
	 output wire testeMemControl,
	 output wire teste_troca_contexto,
	 output wire teste_sinal_cproc,
	 output wire teste_fim*/
);

    // Declaracoes internas
    reg [31:0] concatena;
    reg [31:0] resulSomador;
    reg [31:0] imediatoExtendido;
    reg [31:0] dadoLidoArduinoExtendido;
    reg [31:0] HILOdata;
    reg [31:0] dadosEscrita;
    reg [31:0] regHI, regLO;
    reg [31:0] dadosRegistro;
    reg [31:0] pc, pcsomado;
    reg [31:0] operando;
    reg [31:0] processo_atual;
	 reg [31:0] buffer_uart;

    wire [3:0] inUnidade, inDezena, inCentena, un, dez, cen;
    wire botaoIN, ButtonNeg;
    wire selecaoMuxDesvio;
    wire parada;
    wire status;
    wire [5:0] opcode;
    wire [4:0] endRD, endRS, endRT;
    wire [31:0] rs, rt;
    wire [31:0] resultadoULA;
    wire [31:0] HI, LO;
    wire [31:0] dadoMem;
    wire [31:0] dadosDeEntrada, DadosLidos;
    wire resultComparacao;
    wire [25:0] jump;
    wire [31:0] dadosMux6, processo_rodando;
    wire [10:0] imediato;
    wire [1:0] mudaProcesso;
    wire ocorrenciaIO;
    wire ledControl, comandoOUT, comandoIN;
    wire [31:0] enderecoRelativo;
    wire troca_contexto;
    wire intrucaoIOContexto, fimprocesso;
    wire clk;
    wire [1:0] entradaSaidaControl, encerrarBios;
    wire valueULA;
    wire DesvioControl, branchControl, branchTipo, jumpControl, linkControl, memControl, HILOcontrol, escritaRegControl;
    wire [1:0] tipoEntrada;
	 wire [2:0] dadoRegControl;
    wire [4:0] ulaOP;
    wire [31:0] pc_contexto;
    wire InstrucaIO, fimProcesso;

    // =========================================================
    // Sinais do transmissor UART
    // =========================================================
    reg  signed [15:0] tx_data = 16'd0;  // 16 bits, com sinal (complemento de dois)
    reg        tx_start       = 1'b0;
    wire       tx_ready;
    reg        tx_ready_prev  = 1'b0;  // dominio: clock 50 MHz

    wire       tx_done;                // pulso de 1 ciclo em clock 50 MHz
    reg        tx_done_stretched;      // esticado ate o clk dividido enxerga-lo

    wire       sinal_enter;
    wire       w_tx_start;

    // Declaracao explicita de 16 bits — recebimento nao precisa de sinal
    wire [15:0] rx_data_byte;
    wire [31:0] rx_data_extendido;

    parameter Escalonador    = 32'd73,
              IntrucaoIO     = 32'd92,
              PCout          = 32'd160,
              EndfimProcesso = 32'd236,
              endSalvaProcesso = 32'd180;
	 parameter in  = 6'b011101,
              out = 6'b011110;

    // divisor de clock
    clock_divider(.clock_in(clock), .clock_out(clk));

    // memoria de instrucoes
    MEMInstrucoes inst(
        .reset(reset), .pc(pc), .opcode(opcode), .jump(jump),
        .OUTrs(endRS), .OUTrt(endRT), .OUTrd(endRD), .imediato(imediato),
        .clock(clock), .biosEmExecucao(biosEmExecucao), .encerrarBios(encerrarBios)
    );

    // contador de quantum
    ContadorDeQuantum quantum(
        .clock(clk), .reset(reset), .pc(pc), .InstrucaIO(ocorrenciaIO),
        .fimProcesso(fimProcesso), .processoAtual(processo_atual), .opcode(opcode),
        .troca_contexto(troca_contexto), .pc_processo_trocado(pc_contexto),
        .intrucaoIOContexto(intrucaoIOContexto)
    );

    // unidade de controle
    UnidadeDeControle uco(
        .opcode(opcode), .status(status), .ulaOP(ulaOP), .valueULA(valueULA),
        .DesvioControl(DesvioControl), .jumpControl(jumpControl), .linkControl(linkControl),
        .escritaRegControl(escritaRegControl), .branchControl(branchControl),
        .branchTipo(branchTipo), .dadoRegControl(dadoRegControl), .memControl(memControl),
        .HILOcontrol(HILOcontrol), .entradaSaidaControl(entradaSaidaControl),
        .mudaProcesso(mudaProcesso), .encerrarBios(encerrarBios), .fimprocesso(fimprocesso),
        .intrucaoIOContexto(ocorrenciaIO), .ledControl(ledControl), .comandoIN(comandoIN),
        .comandoOUT(comandoOUT), .tipoEntrada(tipoEntrada), .w_tx_start(w_tx_start)
    );

    // parada de sistema — opera no clk dividido (correto, nao alterar)
    ParadaSistema mest(
        .clock(clk), .pausa(status), .botaoIN(botaoIN),
        .status(parada), .enter(sinal_enter), .reset(reset)
    );

    // banco de registradores
    BancoRegistradores br(
        .clk(clk), .escritaRegControl(escritaRegControl),
        .inRS(endRS), .inRT(endRT), .inRD(endRD),
        .dados(dadosMux6), .outRS(rs), .outRT(rt), .linkControl(linkControl)
    );

    // ULA
    ULA alu(
        .ulaOP(ulaOP), .RS(rs), .RT(operando),
        .saidaULA(resultadoULA), .saidaHI(HI), .saidaLO(LO)
    );

    // unidade de comparacao
    unidadeDeComparacao compara(
        .branchTipo(branchTipo), .resultadoULA(resultadoULA),
        .resultadoComparacao(resultComparacao)
    );

    // mux6
    mux6 muxRegistro(
        .dadoRegControl(dadoRegControl), .HiLoData(HILOdata),
        .resulULA(resultadoULA), .valorRegRS(rs), .dadoMEM(dadoMem),
        .dadosEntrada(dadosDeEntrada), .imediato(imediatoExtendido),
        .PC(pcsomado), .DadosRegistro(dadosMux6), .pc_contexto(pc_contexto)
    );

    // memoria de dados
    simple_dual_port_ram_dual_clock mem(
        .data(rt), .read_addr(resultadoULA), .write_addr(resultadoULA),
        .we(memControl), .read_clock(clock), .write_clock(clock), .q(dadoMem)
    );

    // UART TX — opera em clock 50 MHz
    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) tx_inst (
        .clk(clock),
        .start(tx_start),
        .data_in(tx_data),
        .tx(saidaUART),
        .ready(tx_ready)
    );

    // UART RX — buffer disponivel continuamente, CPU le quando quiser
    comunicacao_recebimento cr(
        .clk(clock), .rx(entradaUART), .dado(rx_data_byte)
    );

    // entrada e saida
    EntradaSaida IO(
        .botaoIN(botaoIN), .endereco(resultadoULA), .dadosEscrita(rt),
        .DadosLidos(DadosLidos), .entradaSaidaControl(entradaSaidaControl),
        .clk(clk), .clock(clock), .entradaDeDados(entradaDeDadosIO),
        .unidade(inUnidade), .dezena(inDezena), .centena(inCentena)
    );

    // mux selecao entre entrada da placa e UART
    muxEntrada m_in(
        .tipoEntrada(tipoEntrada), .DadosLidos(DadosLidos),
        .dadoLidoArduinoExtendido(rx_data_extendido), .dadosDeEntrada(dadosDeEntrada)
    );

    // debounce
    DeBounce deb(.botaoEntrada(ButtonNeg), .clock(clk), .botaoFiltrado(botaoIN));
    assign ButtonNeg = ~botaoPlaca;

    // displays
    displaySete displayUnidade(.entrada(inUnidade), .saidas(unidade));
    displaySete displayDezena(.entrada(inDezena),   .saidas(dezena));
    displaySete displayCentena(.entrada(inCentena), .saidas(centena));

    Display_PC dpc(
        .pc_atual(DadosLidos), .unidadePC(unidadePC),
        .dezenaPC(dezenaPC), .centenaPC(centenaPC)
    );

    // =========================================================
    // Cruzamento de dominio de clock para sinal_enter do TX
    //
    // tx_done   : pulso de 1 ciclo em clock 50 MHz — invisivel ao clk dividido
    // tx_done_stretched : sobe ao detectar tx_done (dominio 50 MHz),
    //             desce na proxima borda alta do clk dividido.
    //             Assim ParadaSistema (clk lento) sempre enxerga o pulso.
    // =========================================================
    assign tx_done = tx_ready & ~tx_ready_prev;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            tx_ready_prev    <= 1'b0;
            tx_done_stretched <= 1'b0;
            tx_start         <= 1'b0;
            tx_data          <= 16'd0;
        end else begin
            tx_ready_prev <= tx_ready;
            tx_start      <= 1'b0;  // pulso: desce a cada ciclo por padrao

            // Carrega dado e dispara TX (16 bits, preserva o sinal de rt)
            if (w_tx_start && tx_ready) begin
                tx_data  <= rt[15:0];
                tx_start <= 1'b1;
            end

            // Seta ao detectar fim da transmissao
            if (tx_done)
                tx_done_stretched <= 1'b1;
            // Limpa quando clk dividido esta alto (borda de saida ja ocorreu)
            else if (clk)
                tx_done_stretched <= 1'b0;
        end
    end

    // sinal_enter liberado ao ParadaSistema apos TX concluido
    assign sinal_enter = comandoOUT & tx_done_stretched;

    // =========================================================
    // Calculo de resulSomador e concatena — negedge clk dividido
    // =========================================================
    assign selecaoMuxDesvio = branchControl & resultComparacao;

    always @(negedge clk) begin
        if (selecaoMuxDesvio) resulSomador <= pc + imediatoExtendido;
        else                  resulSomador <= pcsomado;

        if (jumpControl) concatena <= {pc[31:26], rs[25:0]};
        else             concatena <= {pc[31:26], jump};
    end

    // =========================================================
    // Atualizacao do PC — posedge clk dividido
    // =========================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'd0;
        end else begin
            if (troca_contexto == 1'b1)   pc <= endSalvaProcesso;
            else if (fimprocesso == 1'b1) pc <= EndfimProcesso;
            else begin
                if (parada)          pc <= pc;
                else begin
                    if (DesvioControl) pc <= concatena;
                    else               pc <= resulSomador;
                end
            end
        end
    end

    // =========================================================
    // Combinacional: pcsomado e leds de processo
    // =========================================================
    always @(pc) begin
        pcsomado = pc + 32'd1;

        if (opcode == in) ledin = 1'b1;
        else              ledin = 1'b0;

        if (pc == 32'd41) begin
            ledmenu         = 1'b1;
            lednumprocessos = 1'b0;
            processo_atual  = 32'd0;
            ledprocesso     = 1'b0;
            ledin           = 1'b0;
        end else if (pc == 32'd56) begin
            lednumprocessos = 1'b1;
            ledmenu         = 1'b0;
            processo_atual  = 32'd0;
            ledprocesso     = 1'b0;
            ledin           = 1'b0;
        end else begin
            ledmenu         = 1'b0;
            lednumprocessos = 1'b0;
            ledprocesso     = 1'b1;

            if      (pc < 32'd300)  processo_atual = 32'd0;
            else if (pc < 32'd600)  processo_atual = 32'd1;
            else if (pc < 32'd900)  processo_atual = 32'd2;
            else if (pc < 32'd1200) processo_atual = 32'd3;
            else if (pc < 32'd1500) processo_atual = 32'd4;
            else if (pc < 32'd1800) processo_atual = 32'd5;
            else if (pc < 32'd2100) processo_atual = 32'd6;
            else if (pc < 32'd2400) processo_atual = 32'd7;
            else if (pc < 32'd2700) processo_atual = 32'd8;
            else if (pc < 32'd3000) processo_atual = 32'd9;
            else if (pc < 32'd3300) processo_atual = 32'd10;
        end
    end

    always @(imediato) begin
        imediatoExtendido = {21'b0, imediato};
    end

    always @(HI, LO) begin
        if ((ulaOP == 5'b00010) | (ulaOP == 5'b00011)) begin
            regHI = HI;
            regLO = LO;
        end
    end

    always @(HILOcontrol) begin
        if (HILOcontrol) HILOdata = regHI;
        else             HILOdata = regLO;
    end

    always @(imediatoExtendido, rt) begin
        if (valueULA) operando = imediatoExtendido;
        else          operando = rt;
    end

    // Saidas de teste e monitoramento
    assign sinal_recebe      = comandoIN;
    assign teste_recebimento = entradaUART;
    assign teste_envio       = saidaUART;
    assign halt              = parada;
    assign rx_data_extendido = {16'b0, rx_data_byte};

endmodule