// Decodificador BCD
module bcd_para_7seg (
    input [3:0] bcd,         // Entrada: BCD (0 a 9)
    output reg [6:0] display // Saída: 7 segmentos (a-g)
);

// A ordem dos bits é: [a, b, c, d, e, f, g]

    always @(*) begin
        case (bcd)
            // Segmentos: a b c d e f g
            4'd0: display = 7'b0111111; // 0
            4'd1: display = 7'b0000110; // 1
            4'd2: display = 7'b1011011; // 2
            4'd3: display = 7'b1001111; // 3 
            4'd4: display = 7'b1100110; // 4
            4'd5: display = 7'b1101101; // 5
            4'd6: display = 7'b1111101; // 6
            4'd7: display = 7'b0000111; // 7
            4'd8: display = 7'b1111111; // 8
            4'd9: display = 7'b1101111; // 9
            // Se a entrada for maior que 9, exibir "E" de erro 
            default: segments = 7'b0001110; // E
        endcase
    end

endmodule
            