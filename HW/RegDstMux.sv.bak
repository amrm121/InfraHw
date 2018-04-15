module RegDstMux(RegDst, I20_16, I15_11, wrtRegMux_out);
input logic RegDst;
input logic [4:0] I20_16, I15_11;
output logic [4:0] wrtRegMux_out;

always @ (RegDst) begin
case(RegDst)
1'b0:wrtRegMux_out <= I20_16;
1'b1:wrtRegMux_out <= I15_11;
endcase
end
endmodule 
