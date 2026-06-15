// ============================================================
// Comunicacao_uart.v  –  Receptor UART com saída de 32 bits
//
// Protocolo esperado:
//   O Arduino envia o valor de 16 bits em DOIS bytes consecutivos:
//     1º byte  →  bits [15:8]  (byte alto)
//     2º byte  →  bits [ 7:0]  (byte baixo)
//
// Comportamento:
//   • A saída data_out[31:0] é atualizada SOMENTE após o par
//     completo ser recebido (os 2 bytes).
//   • Durante a recepção do par, qualquer byte adicional que
//     chegue é DESCONSIDERADO (lock enquanto busy).
//   • Os 16 bits superiores de data_out ficam sempre em zero
//     (reservados para uso futuro).
//   • data_valid pulsa por 1 ciclo de clock quando data_out
//     é atualizado com um novo valor.
// ============================================================
module Comunicacao_uart (
    input        clk,          // Clock 50 MHz (DE2-115)
    input        uart_rx,      // Pino RX – conectado ao TX do Arduino
	 input        reset,

    output reg [31:0] data_out,   // Valor de 16 bits recebido (zero-estendido)
    output reg        data_valid  // Pulso de 1 ciclo: novo dado disponível
);

    // =========================================================
    // Sinais internos do receptor UART
    // =========================================================
    wire [7:0] rx_data;
    wire       rx_done;

    // =========================================================
    // Instância do receptor UART (8 bits / byte)
    // =========================================================
    uart_rx #(
        .CLK_FREQ (50000000),
        .BAUD_RATE(9600)
    ) rx_inst (
        .clk      (clk),
        .rx       (uart_rx),
        .data_out (rx_data),
        .done     (rx_done)
    );

    // =========================================================
    // Máquina de estados para montagem dos 16 bits
    //
    //   IDLE (state=0)
    //     └─ rx_done → captura byte alto → vai para WAIT_LOW
    //
    //   WAIT_LOW (state=1)
    //     └─ rx_done → captura byte baixo → atualiza saída → vai para IDLE
    //
    // Durante WAIT_LOW qualquer rx_done EXTRA é ignorado pelo
    // próprio fluxo: só avançamos de estado em rx_done quando
    // estamos no estado correto.
    // =========================================================
    localparam IDLE     = 1'b0;
    localparam WAIT_LOW = 1'b1;

    reg        state    = IDLE;
    reg [7:0]  high_byte = 8'd0;  // Guarda byte alto enquanto espera o baixo

    always @(posedge clk) begin
        // Apaga pulso de valid a cada ciclo (pulso de 1 ciclo)
        data_valid <= 1'b0;
		  
		  
		      if (reset) begin
					  state      <= IDLE;
					  high_byte  <= 8'd0;
					  data_valid <= 1'b0;
					  data_out   <= 32'd0;
				end
		  
		  
				else begin
					  case (state)
							// ---------------------------------------------------
							// IDLE: aguarda o primeiro byte (alto)
							// ---------------------------------------------------
							IDLE: begin
								 if (rx_done) begin
									  high_byte <= rx_data;   // Salva byte alto [15:8]
									  state     <= WAIT_LOW;
								 end
							end

							// ---------------------------------------------------
							// WAIT_LOW: aguarda o segundo byte (baixo)
							// Qualquer byte que chegue aqui é tratado como byte baixo.
							// Bytes extras NÃO chegam aqui porque a máquina de estados
							// do uart_rx leva ~(TICKS_PER_BIT * 10) ciclos por byte,
							// garantindo que os dois bytes do par sejam os únicos
							// processados antes de voltarmos ao IDLE.
							// ---------------------------------------------------
							WAIT_LOW: begin
								 if (rx_done) begin
									  // Monta o valor de 16 bits e zero-estende para 32 bits
									  data_out   <= {16'b0, high_byte, rx_data};
									  data_valid <= 1'b1;     // Pulso: novo dado válido
									  state      <= IDLE;
								 end
							end

							default: state <= IDLE;
					  endcase
				end
    end

endmodule