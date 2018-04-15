module IorDMux(IorD, PC, AluOut, mux_out);

input logic IorD;
input logic [31:0] PC, AluOut;
output logic [31:0] mux_out;

always @ (IorD) begin

case(IorD)
1'b0:mux_out <= PC;
1'b1:mux_out <= AluOut;
endcase 
end
endmodule 