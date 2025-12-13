// Testbench para o Contador Up/Down com teste de Parada em F e Reset
`include "contador_hex.v" 
`timescale 1ns/1ns

module contador_hex_tb;

    // Sinais 
    reg clk;
    reg rst_n;          // Reset Ativo Baixo
    reg dir;      // 0: UP
    wire [3:0] q;

    // Instanciação do DUT (Device Under Test)
    contador_hex DUT (
        .clk (clk),
        .rst_n (rst_n),      
        .dir (dir),
        .q (q)
    );

    // Geração do Clock (Período de 200ns)
    initial begin
        clk = 1'b0;
        forever #100 clk = ~clk; 
    end

    // Geração do Estímulo
    initial begin
        $dumpfile("contador_hex.vcd");
        $dumpvars(0, contador_hex_tb);
        
        // --- 1. RESET INICIAL (Zera para sair do estado 'x') ---
        rst_n = 1'b0; // Reset Ativo Baixo
        dir = 1'b0; // Contagem UP
        #50; 
        rst_n = 1'b1; // Desativa o Reset
        
        // --- 2. CONTAGEM ATÉ F E PARADA ---
        // 16 ciclos (15*200ns + 100ns de margem) = 3100 ns
        // Garante que ele chegue em F e tente incrementar
        #3100; 
        
        #800; // Mantém em F por 4 ciclos de clock

        // --- 3. APLICAÇÃO DO RESET MANUAL ---
        rst_n = 1'b0; // Ativa Reset (Deve zerar o contador imediatamente)
        #50; 
        rst_n = 1'b1; // Desativa o Reset
        
        // --- 4. VERIFICAÇÃO DO REINÍCIO (0, 1, 2) ---
        #600; // 3 ciclos de contagem (deve ir 0, 1, 2)
        dir = 1'b1; // Contagem DOWN
         #600;
        $finish; 
    end

    // Monitoramento
    initial $monitor("Tempo=%4d | RST_n=%b | Dir=%b | Q=%h", $time, rst_n, dir, q);

endmodule