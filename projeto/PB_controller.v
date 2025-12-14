module PB_Controller (
    input clk, reset, push_button,
    input [2:0] switches,
    output reg [2:0] A_out, B_out, OP_out,
    output reg start_op, LEDs_clear
);

reg [2:0] state;
reg pb_reg;
wire pb_edge = push_button & ~pb_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'd0;
        pb_reg <= 1'b0;
        A_out <= 3'd0; B_out <= 3'd0; OP_out <= 3'd0;
        start_op <= 1'b0; LEDs_clear <= 1'b1;
    end else begin
        pb_reg <= push_button;
        
        if (pb_edge) begin
            case (state)
                3'd0: begin // 1º Toque: Limpa
                    A_out <= 3'd0; B_out <= 3'd0; OP_out <= 3'd0;
                    LEDs_clear <= 1'b1; start_op <= 1'b0;
                    state <= 3'd1;
                end
                3'd1: begin // 2º Toque: Carrega A
                    A_out <= switches; LEDs_clear <= 1'b0;
                    state <= 3'd2;
                end
                3'd2: begin // 3º Toque: Carrega B
                    B_out <= switches; state <= 3'd3;
                end
                3'd3: begin // 4º Toque: Carrega OP
                    OP_out <= switches; state <= 3'd4;
                end
                3'd4: begin // 5º Toque: Executa
                    start_op <= 1'b1; state <= 3'd5;
                end
                3'd5: begin // Reinicia ciclo
                    start_op <= 1'b0; state <= 3'd0;
                end
                default: state <= 3'd0;
            endcase
        end else begin
            // Garante que pulsos durem apenas um ciclo
            start_op <= 1'b0;
            if (state != 3'd0) LEDs_clear <= 1'b0;
        end
    end
end
endmodule