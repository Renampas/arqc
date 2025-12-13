// Cronômetro 0-999
`include "divisor_1hz.v" 
module cron (
    input clk,            // Clock do sistema (50MHz)
    input rst_n,          // Reset Assíncrono (Ativo Baixo)
    input play_pause,     // 1: Conta; 0: Pausa
    
    output reg [9:0] q,    // Saída da contagem (0 a 999)
    output wire tick_1s   // Fio para o pulso de 1Hz do divisor
);


    // 1. DIVISOR DE CLOCK
    divisor_1hz div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick_1s) // O pulso de 1s é conectado ao fio tick_1s
    );

    // 2. LÓGICA DO CONTADOR (Só avança se tick_1s for '1' e play_pause for '1')
    always @(posedge clk, negedge rst_n) begin
        
        if (rst_n == 1'b0) begin
            q <= 10'd0;
        end 
        else begin 
            // A contagem é habilitada pelo pulso de 1Hz E pelo sinal de play
            if (play_pause == 1'b1 && tick_1s == 1'b1) begin
                
                if (q >= 10'd999) begin
                    q <= 10'd0; 
                end 
                else begin
                    q <= q + 1;
                end
            end
            // se não houver tick ou se play_pause for 0, q mantém o valor (Pausa)
        end
    end

endmodule
