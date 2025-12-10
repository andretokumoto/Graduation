module DeBounce (
    input  botaoEntrada,  // Sinal de entrada do botão (com ruído)
    input  clock,         // Sinal de clock do sistema
    output reg botaoFiltrado // Sinal de saída do botão (filtrado)
);

// Sinais internos (registradores) para as saídas dos Flip-Flops (FF1, FF2, FF3)
// Estes representam os estados internos do registrador de deslocamento de 3 estágios.
reg FF1_out; 
reg FF2_out;
reg FF3_out;

// --- Lógica Sequencial (Flip-Flops) ---
// O bloco 'always @(posedge clock)' define o comportamento sequencial 
// do registrador de deslocamento.

always @(posedge clock) begin
    // Estágio 1 (FF1): Captura a entrada do botão e armazena em FF1_out
    FF1_out <= botaoEntrada; 
    
    // Estágio 2 (FF2): Desloca o valor de FF1_out para FF2_out
    FF2_out <= FF1_out;
    
    // Estágio 3 (FF3): Desloca o valor de FF2_out para FF3_out
    FF3_out <= FF2_out;
end

// --- Lógica Combinacional (Porta AND) ---
// O bloco 'always @(*)' define a lógica combinacional (a porta AND)
// que opera com as saídas dos Flip-Flops.

always @(*) begin
    // O sinal filtrado é a AND lógica das saídas dos três Flip-Flops.
    // Isso garante que a entrada só será considerada estável se for a mesma (alta) 
    // por pelo menos 3 ciclos de clock consecutivos (FF1, FF2 e FF3 sendo '1').
    botaoFiltrado = FF1_out & FF2_out & (~FF3_out);
end

endmodule