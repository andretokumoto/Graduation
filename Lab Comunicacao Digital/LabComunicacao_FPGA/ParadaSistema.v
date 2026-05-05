module ParadaSistema(clock, pausa, botaoIN, status, data_ready);
  input botaoIN, clock, pausa, data_ready;
  output reg status;
  
  reg [1:0] estadoAtual, estadoFuturo;

  // Lógica de Próximo Estado (Combinacional)
  always @(*) begin
      case(estadoAtual)
          2'b00: begin // Execução
              if(pausa) begin
                  estadoFuturo = 2'b01;
                  status = 1'b1;
              end else begin
                  estadoFuturo = 2'b00;
                  status = 1'b0;
              end
          end
          2'b01: begin // Pausado/Esperando
              if(botaoIN || data_ready) estadoFuturo = 2'b10;
              else begin
                  estadoFuturo = 2'b01;
                  status = 1'b1;
              end
          end
          2'b10: begin // Liberação
              estadoFuturo = 2'b00;
              status = 1'b0;
          end
          default: begin
              estadoFuturo = 2'b00;
              status = 1'b0;
          end
      endcase
  end

  // Lógica de Atualização de Estado (Sequencial - Síncrona)
  always @(posedge clock) begin
      estadoAtual <= estadoFuturo; // Use atribuição não-bloqueante (<=)
  end
endmodule