module DebounceSimples (
    input  botaoEntrada,  // Sinal de entrada do botão (com ruído)
    input  clock,         // Sinal de clock do sistema
    output reg botaoFiltrado // Sinal de saída do botão (filtrado)
);

// --- Configuração ---
// Ajuste COUNTER_MAX de acordo com a frequência do seu clock.
// Exemplo: 16 bits para 65535 ciclos (~1.3ms em 50MHz).
parameter COUNTER_WIDTH = 16;
parameter COUNTER_MAX = 16'hFFFF; 

// --- Sinais Internos ---
logic [COUNTER_WIDTH-1:0] contador;

// Note que 'botaoFiltrado' é implicitamente um registrador (reg/logic) 
// por ser atribuído dentro do bloco 'always'.

// --- Lógica Principal ---
always @(posedge clock) begin
    
    // Se a entrada é diferente do estado filtrado atual (botaoFiltrado),
    // o sinal mudou ou está com ruído.
    if (botaoEntrada != botaoFiltrado) begin
        
        // 1. Contagem
        if (contador < COUNTER_MAX) begin
            // Incrementa o contador para ver se a mudança é estável
            contador <= contador + 1;
        end 
        
        // 2. Transição Concluída
        else begin
            // Se o contador atingiu o máximo, a mudança é válida.
            botaoFiltrado <= botaoEntrada; // Atualiza a saída
            contador <= 0;                // Reinicia o contador para a próxima transição
        end
        
    end 
    
    // 3. Sinal Estável (Sem Mudança)
    else begin
        // Se a entrada for igual à saída filtrada, o estado é estável.
        // Reinicia o contador para zero, esperando a próxima borda.
        contador <= 0;
    end
end

endmodule