module AluBMux(AluSrcB, B, SignE, SL2, mux_out);
input logic [1:0] AluSrcB;
input logic [31:0] B, SignE, SL2;
output logic [31:0] mux_out;


always @ (AluSrcB) begin
case(AluSrcB)
2'b00:mux_out <= B;
2'b01:mux_out <= 32'd4;
2'b10:mux_out <= SignE;
2'b11:mux_out <= SL2;
endcase
end
endmodule
