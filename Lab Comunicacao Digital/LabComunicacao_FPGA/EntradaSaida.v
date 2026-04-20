module EntradaSaida(
    input clk,
    input reset,
    
    // Sinais do MIPS
    input [31:0] endereco,
    input [31:0] dadosEscrita,
    input [1:0] entradaSaidaControl, // [0]=Write, [1]=Read
    
    // Interface Física
    input [3:0] entradaDeDados,
    output [3:0] unidade, dezena, centena,
    
    // Interface UART
    input [7:0] uart_rx_data,
    input uart_rx_ready,
    output reg uart_tx_start,
    input uart_tx_busy,
    
    // SAÍDAS PARA O MULTIPLEXADOR EXTERNO
    output reg [31:0] reg_placa,
    output reg [31:0] reg_uart_rx,
    output [31:0] reg_uart_status
);

    reg flag_uart_nova;

    // 1. Lógica dos Displays (BCD)
    BCD bcd(
        .binario(dadosEscrita), 
        .unidade(unidade), 
        .dezena(dezena), 
        .centena(centena), 
        .controlesaida(entradaSaidaControl[0]) // Ativa no MemWrite
    );

    // 2. Registrador da Placa (Switches)
    always @(posedge clk) begin
        reg_placa <= {28'b0, entradaDeDados};
    end

    // 3. Registrador UART RX (Arduino -> MIPS)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_uart_rx <= 32'b0;
            flag_uart_nova <= 1'b0;
        end else begin
            if (uart_rx_ready) begin
                reg_uart_rx <= {24'b0, uart_rx_data};
                flag_uart_nova <= 1'b1;
            end
            // Limpa a flag quando o MIPS lê o endereço da UART
            else if (entradaSaidaControl[1] && endereco == 32'h00000020) begin
                flag_uart_nova <= 1'b0;
            end
        end
    end

    // 4. Registrador de Status (Para o SO consultar)
    // Bit 0: Dado disponível para leitura | Bit 1: Transmissor ocupado
    assign reg_uart_status = {30'b0, uart_tx_busy, flag_uart_nova};

    // 5. Lógica de Disparo do Transmissor (MIPS -> Arduino)
    always @(posedge clk) begin
        // Se o MIPS escrever no endereço da UART, dispara o envio
        if (entradaSaidaControl[0] && endereco == 32'h00000020)
            uart_tx_start <= 1'b1;
        else
            uart_tx_start <= 1'b0;
    end

endmodule