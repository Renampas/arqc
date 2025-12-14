module ULA_3BIT (
    input [2:0] A,          
    input [2:0] B,          
    input [2:0] OP,         
    output reg [5:0] RESULT, 
    output reg LED_ZERO,    
    output reg LED_NEG,     
    output reg LED_OVERFLOW 
);

reg [5:0] res_temp;

always @(*) begin
    // Valores padrão
    res_temp = 6'b0;
    LED_OVERFLOW = 1'b0;
    LED_NEG = 1'b0;

    case (OP)
        3'b000: begin // Adição
            res_temp = A + B;
            LED_OVERFLOW = res_temp[3]; 
            LED_NEG = res_temp[2];      
        end
        3'b001: begin // Subtração
            res_temp = A - B;
            if (A < B) LED_NEG = 1'b1;  // Resultado negativo
        end
        3'b010: begin // Multiplicação
            res_temp = A * B;
        end
        3'b011: begin // Divisão
            if (B == 3'b000) begin
                res_temp = 6'b0;
                LED_OVERFLOW = 1'b1; // Erro: Divisão por zero
            end else begin
                res_temp = A / B;
            end
        end
        3'b100: res_temp = {3'b0, A & B};
        3'b101: res_temp = {3'b0, A | B};
        3'b110: res_temp = {3'b0, A ^ B};
        3'b111: res_temp = 6'b0; // Reservado
        default: res_temp = 6'b0;
    endcase

    RESULT = res_temp;
    LED_ZERO = (res_temp == 6'b0);
end
endmodule