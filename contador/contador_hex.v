// Contador Hexadecimal de 0 a F
module contador_hex (
    input clk,            // Clock
    input rst_n,          // Reset Assíncrono, ATIVO BAIXO (rst_n de 'not')
    input dir,      // 0: Contagem incremental; 1: Contagem decremental
    
    output reg [3:0] q    // Saída do Contador (4 bits)
);
   // O registrador de contagem já está implícito em 'q' (reg)

   // Lógica do Contador (Reset Assíncrono, Ativo Baixo)
    always @(posedge clk, negedge rst_n) begin
        
        if (rst_n == 1'b0) begin
            // Reset: zera o contador
            q <= 4'b0000;
        end 
        else begin // Síncrono com CLK
            
            if (dir == 1'b1) begin
                // Decrementar (Contagem para baixo) - Cicla de 0 para F
                q <= q - 1;
            end 
            
            else begin
                // Incrementar (Contagem para cima)
                if (q == 4'hF) begin
                    // Se q é F, mantém o valor (Parada)
                    q <= q; 
                end else begin
                    // Contagem normal (0 -> F)
                    q <= q + 1;
                end
            end
        end
    end

endmodule