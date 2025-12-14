`include "ula_3bit.v" 
`include "PB_controller.v" 
`include "bcd.v" 
module Sistema_ULA (
    input clk, reset, push_button,
    input [2:0] switches,
    output reg [5:0] FINAL_RESULT,
    output reg FINAL_LED_ZERO, FINAL_LED_NEG, FINAL_LED_OVERFLOW
);

wire [2:0] A_w, B_w, OP_w;
wire start_w, clear_w;
wire [5:0] res_w;
wire zero_w, neg_w, ovf_w;

PB_Controller ctrl (
    .clk(clk), .reset(reset), .push_button(push_button), .switches(switches),
    .A_out(A_w), .B_out(B_w), .OP_out(OP_w),
    .start_op(start_w), .LEDs_clear(clear_w)
);

ULA_3BIT ula (
    .A(A_w), .B(B_w), .OP(OP_w),
    .RESULT(res_w), .LED_ZERO(zero_w), .LED_NEG(neg_w), .LED_OVERFLOW(ovf_w)
);

always @(posedge clk or posedge reset) begin
    if (reset || clear_w) begin
        FINAL_RESULT <= 6'b0;
        {FINAL_LED_ZERO, FINAL_LED_NEG, FINAL_LED_OVERFLOW} <= 3'b0;
    end else if (start_w) begin
        FINAL_RESULT <= res_w;
        FINAL_LED_ZERO <= zero_w;
        FINAL_LED_NEG <= neg_w;
        FINAL_LED_OVERFLOW <= ovf_w;
    end
end

// SINAIS DE SAÍDA DO DISPLAY 
output [6:0] Segments_A, Segments_B, Segments_Dezenas, Segments_Unidades;

// Lógica de Conversão BCD 
wire [3:0] Unidades_BCD;
wire [3:0] Dezenas_BCD;

// Os operandos A e B já estão disponíveis (A_controller, B_controller)
// Eles são 3 bits, então basta estender para 4 bits BCD (4'd0 a 4'd7)
wire [3:0] A_BCD = {1'b0, A_controller}; 
wire [3:0] B_BCD = {1'b0, B_controller};

// Conversão para o Resultado Final (FINAL_RESULT é de 6 bits)
assign Unidades_BCD = FINAL_RESULT % 10;
assign Dezenas_BCD  = FINAL_RESULT / 10;


// INSTANCIAÇÃO DOS DECODIFICADORES 

// Decodificador para A
bcd_para_7seg dec_A ( .bcd_in(A_BCD), .segments(Segments_A) );

// Decodificador para B
bcd_para_7seg dec_B ( .bcd_in(B_BCD), .segments(Segments_B) );

// Decodificador para Unidades do Resultado
bcd_para_7seg dec_Unid ( .bcd_in(Unidades_BCD), .segments(Segments_Unidades) );

// Decodificador para Dezenas do Resultado
bcd_para_7seg dec_Dez ( .bcd_in(Dezenas_BCD), .segments(Segments_Dezenas) );
endmodule
