module PCSourceMux(PCSource, AluS, AluOut, Jump, EPC, mux_out);
input logic [1:0] PCSource;
input logic [31:0] AluS, AluOut, Jump, EPC;
output logic [31:0] mux_out;

always @ (PCSource) begin
case(PCSource)
2'b00:mux_out <= AluS;
2'b01:mux_out <= AluOut;
2'b10:mux_out <= Jump;
2'b11:mux_out <= EPC;
endcase
end
endmodule
