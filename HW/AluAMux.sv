module AluAMux(AluSrcA, A, PC, mux_out);
input logic AluSrcA;
input logic [31:0] PC, A;
output logic [31:0] mux_out;

always @ (AluSrcA) begin
case(AluSrcA)
1'b0:mux_out <= PC;
1'b1:mux_out <= A;
endcase
end
endmodule
