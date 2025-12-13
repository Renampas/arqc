// Display de 7 segmentos
`include "bcd_para_7seg.v"
`include "bin_para_bcd.v"

module display_main (
    // (Entradas de clock, reset e play_pause permanecem as mesmas)
    input clk,            
    input rst_n,          
    input play_pause,     
    
    // Saídas para os Displays de 7 Segmentos
    output [6:0] seg_centenas,  // Centenas (C)
    output [6:0] seg_dezenas,   // Dezenas (D)
    output [6:0] seg_unidades   // Unidades (U)
);

    // Sinais internos para o valor do contador e para os dígitos BCD
    reg [9:0] contador_valor;
    wire [3:0] bcd_c, bcd_d, bcd_u;

    // --- Instâncias e Conexões ---

    // 1. Divisor de Clock (como definido anteriormente)
    wire tick_1s;
    divisor_1hz div_inst (
        .clk(clk), .rst_n(rst_n), .tick(tick_1s)
    );
    
    // 2. Lógica do Contador (usa contador_valor)
    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0) begin
            contador_valor <= 10'd0;
        end 
        else if (play_pause == 1'b1 && tick_1s == 1'b1) begin
            if (contador_valor >= 10'd999) 
                contador_valor <= 10'd0;
            else 
                contador_valor <= contador_valor + 1;
        end
    end

    // 3. Conversão Binário para BCD (Centenas, Dezenas, Unidades)
    bin_para_bcd bcd_inst (
        .bin(contador_valor),
        .c(bcd_c), // BCD da Centena
        .d(bcd_d), // BCD da Dezena
        .u(bcd_u)  // BCD da Unidade
    );

    // 4. Decodificador BCD para 7 Segmentos (3 instâncias)
    
    // Unidade
    bcd_para_7seg dec_u (
        .bcd(bcd_u),
        .display(seg_unidades)
    );
    
    // Dezena
    bcd_para_7seg dec_d (
        .bcd(bcd_d),
        .display(seg_dezenas)
    );
    
    // Centena
    bcd_para_7seg dec_c (
        .bcd(bcd_c),
        .display(seg_centenas)
    );

endmodule