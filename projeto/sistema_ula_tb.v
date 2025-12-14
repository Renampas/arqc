`timescale 1ns/1ps
`include "sistema_ula.v" 
module Sistema_ULA_tb;
    // Sinais de Entrada
    reg clk;
    reg reset;
    reg push_button;
    reg [2:0] switches;

    // Sinais de Saída
    wire [5:0] FINAL_RESULT;
    wire FINAL_LED_ZERO;
    wire FINAL_LED_NEG;
    wire FINAL_LED_OVERFLOW;

    parameter CLK_PERIOD = 10;

    // Instanciação do Sistema
    Sistema_ULA dut (
        .clk(clk),
        .reset(reset),
        .push_button(push_button),
        .switches(switches),
        .FINAL_RESULT(FINAL_RESULT),
        .FINAL_LED_ZERO(FINAL_LED_ZERO),
        .FINAL_LED_NEG(FINAL_LED_NEG),
        .FINAL_LED_OVERFLOW(FINAL_LED_OVERFLOW)
    );

    // Geração do Clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Tarefa para simular um toque no botão (evita race conditions)
    task simulate_button_press;
        begin
            @(negedge clk);
            push_button = 1;
            #(CLK_PERIOD * 2);
            @(negedge clk);
            push_button = 0;
            #(CLK_PERIOD * 2);
        end
    endtask

    // Tarefa para executar o fluxo completo de uma operação (6 toques)
    task run_full_op(input [2:0] val_a, input [2:0] val_b, input [2:0] op_code);
        begin
            // 1º Toque: Limpa
            simulate_button_press();
            // 2º Toque: Carrega A
            switches = val_a;
            simulate_button_press();
            // 3º Toque: Carrega B
            switches = val_b;
            simulate_button_press();
            // 4º Toque: Carrega OP
            switches = op_code;
            simulate_button_press();
            // 5º Toque: Executa e apresenta
            simulate_button_press();
            #10; // Pequeno delay para visualização
            // 6º Toque: Volta o contador para o Estado 0 (Pronto para o próximo teste)
            simulate_button_press();
        end
    endtask

    // Sequência de Testes
    initial begin
        $dumpfile("simulacao_ula.vcd");
        $dumpvars(0, Sistema_ULA_tb);

        // Inicialização do Sistema
        reset = 1; push_button = 0; switches = 0;
        #(CLK_PERIOD * 2);
        reset = 0;
        $display("--- Inicio dos Testes da ULA ---");

        // --- OPERAÇÕES ARITMÉTICAS ---

        // 1. Adição: 3 + 2 = 5 (000101)
        $display("Teste 1: Adicao 3 + 2");
        run_full_op(3'd3, 3'd2, 3'b000); // OP 000
        $display("Resultado: %d | Zero: %b | Neg: %b | Ovf: %b", FINAL_RESULT, FINAL_LED_ZERO, FINAL_LED_NEG, FINAL_LED_OVERFLOW);

        // 2. Subtração Positiva: 5 - 3 = 2 (000010)
        $display("Teste 2: Subtracao 5 - 3");
        run_full_op(3'd5, 3'd3, 3'b001); // OP 001
        $display("Resultado: %d | Zero: %b | Neg: %b | Ovf: %b", FINAL_RESULT, FINAL_LED_ZERO, FINAL_LED_NEG, FINAL_LED_OVERFLOW);

        // 3. Subtração Negativa: 1 - 4 = -3 (LED_NEG deve acender)
        $display("Teste 3: Subtracao 1 - 4 (Negativo)");
        run_full_op(3'd1, 3'd4, 3'b001);
        $display("Resultado: %b | Negativo: %b", FINAL_RESULT, FINAL_LED_NEG);

        // 4. Multiplicação: 7 * 7 = 49 (110001)
        $display("Teste 4: Multiplicacao 7 * 7");
        run_full_op(3'd7, 3'd7, 3'b010); // OP 010
        $display("Resultado: %d", FINAL_RESULT);

        // 5. Divisão: 6 / 2 = 3 (000011)
        $display("Teste 5: Divisao 6 / 2");
        run_full_op(3'd6, 3'd2, 3'b011); // OP 011
        $display("Resultado: %d", FINAL_RESULT);

        // 6. Divisão por Zero: 5 / 0 (LED_OVERFLOW deve acender)
        $display("Teste 6: Divisao por Zero 5 / 0");
        run_full_op(3'd5, 3'd0, 3'b011);
        $display("Overflow: %b", FINAL_LED_OVERFLOW);

        // --- OPERAÇÕES LÓGICAS ---

        // 7. AND: 6 (110) & 3 (011) = 2 (010)
        $display("Teste 7: Logica AND (110 & 011)");
        run_full_op(3'b110, 3'b011, 3'b100); // OP 100
        $display("Resultado: %b", FINAL_RESULT[2:0]);

        // 8. OR: 4 (100) | 2 (010) = 6 (110)
        $display("Teste 8: Logica OR (100 | 010)");
        run_full_op(3'b100, 3'b010, 3'b101); // OP 101
        $display("Resultado: %b", FINAL_RESULT[2:0]);

        // 9. XOR: 7 (111) ^ 3 (011) = 4 (100)
        $display("Teste 9: Logica XOR (111 ^ 011)");
        run_full_op(3'b111, 3'b011, 3'b110); // OP 110
        $display("Resultado: %b", FINAL_RESULT[2:0]);

        // 10. Reservado/Zero: OP 111 (Resultado deve ser 0)
        $display("Teste 10: Reservado OP 111");
        run_full_op(3'd7, 3'd7, 3'b111); // OP 111
        $display("Resultado: %d | LED_ZERO: %b", FINAL_RESULT, FINAL_LED_ZERO);

        #100;
        $display("--- Fim da Simulacao ---");
        $finish;
    end
endmodule