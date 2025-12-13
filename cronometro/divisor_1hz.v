module divisor_1hz (
    input clk,      // Clock de 50MHz da placa
    input rst_n,    // Reset
    output reg tick // Pulso que fica '1' apenas por um ciclo de clock a cada segundo
);

    // Parâmetro para 50 MHz 
    parameter FREQ_CLK = 5; 

    // Registrador grande o suficiente para armazenar 50 milhões (precisa de 26 bits)
    reg [25:0] contagem;

    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0) begin
            contagem <= 0;
            tick <= 0;
        end 
        else begin
            if (contagem == FREQ_CLK - 1) begin
                // Atingiu 1 segundo
                contagem <= 0;
                tick <= 1'b1; // Gera o pulso de habilitação
            end 
            else begin
                contagem <= contagem + 1;
                tick <= 1'b0; // Mantém 0 no restante do tempo
            end
        end
    end

endmodule

