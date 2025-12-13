module bcd_para_7seg (
    input [3:0] bcd,         // Entrada: BCD (0 a 9)
    output reg [6:0] display // Saída: 7 segmentos (a-g)
);

    // Assumindo que:
    // 1. O display é Anodo Comum (Common Anode - 0 = aceso, 1 = apagado)
    // 2. A ordem dos bits é: [a, b, c, d, e, f, g]

    always @(*) begin
        case (bcd)
            // Digito: b c d e f g
            // Segmentos: a b c d e f g
            4'd0: display = 7'b1000000; // 0
            4'd1: display = 7'b1111001; // 1
            4'd2: display = 7'b0100100; // 2
            4'd3: display = 7'b0110000; // 3
            4'd4: display = 7'b0011001; // 4
            4'd5: display = 7'b0010010; // 5
            4'd6: display = 7'b0000010; // 6
            4'd7: display = 7'b1111000; // 7
            4'd8: display = 7'b0000000; // 8
            4'd9: display = 7'b0010000; // 9
            default: display = 7'b1111111; // Apagado
        endcase
    end

endmodule
