// tb_cronometro.v
`include "cron.v" 
`timescale 1ns/10ps

module tb_cronometro;

    // --- 1. Sinais do Testbench (Inputs do Módulo Principal) ---
    reg clk;
    reg rst_n;
    reg play_pause;
    
    wire [9:0] q; 
    
    // Sinal do divisor de clock para visualização
    wire tick_1s; 

    // O módulo cron contém a instância do divisor,
    // mas o divisor_1hz também precisa ser definido no arquivo principal.
    
    parameter CLK_PERIOD = 20; // 20ns -> 50MHz

    // --- 2. Instanciação do Módulo Sob Teste ---
    // Você precisa adicionar as saídas do divisor se quiser vê-las no GTKWave
    cron DUT (
        .clk(clk),
        .rst_n(rst_n),
        .play_pause(play_pause),
        .q(q),
        .tick_1s(tick_1s) // Adicionando o tick de 1s para visualização
    );
    
    // --- 3. Geração do Clock ---
    always 
        #(CLK_PERIOD / 2) clk = ~clk;

    // --- 4. Geração do Arquivo de Dump (VCD) ---
    initial begin
        $dumpfile("cron.vcd");
        // Registra todos os sinais no módulo tb_cronometro e seus sub-módulos
        $dumpvars(0, tb_cronometro);
    end

    // --- 5. Sequência de Teste (Estímulos) ---
    initial begin
        // Valores iniciais
        clk = 1'b0;
        rst_n = 1'b0; // Ativa o Reset
        play_pause = 1'b0;

        #100; // Espera durante o Reset
        
        play_pause = 1'b1;
        #100
        
        rst_n = 1'b0; // Libera o Reset e Reseta o contador
        #50; 
        rst_n = 1'b1;
        
        // Inicia a contagem
        play_pause = 1'b1;
        #100
        
        
        // Simulação por 10 segundos
        // 1 segundo = 1,000,000,000 nanosegundos (1 Bilhão)
        // 10 segundos = 10,000,000,000 nanosegundos (10 Bilhões)
        #10000000; 
        
        // Pausa a contagem
        play_pause = 1'b0;
        
        #1000; // Pausa por um breve momento para ver o valor final
        
        // Fim da simulação
        $finish;
    end

endmodule