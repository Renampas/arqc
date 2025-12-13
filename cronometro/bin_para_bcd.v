module bin_para_bcd (
    input [9:0] bin,      // Entrada: Valor de 0 a 999
    output [3:0] u,       // Saída: Unidade (0-9)
    output [3:0] d,       // Saída: Dezena (0-9)
    output [3:0] c        // Saída: Centena (0-9)
);
    
    // Centena
    assign c = bin / 100;
    
    // Dezena: (bin - (centena * 100)) / 10
    assign d = (bin % 100) / 10;
    
    // Unidade: O resto da divisão por 10
    assign u = bin % 10; 
    
endmodule
