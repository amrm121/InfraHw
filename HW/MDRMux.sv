module MDRMux(MemtoReg, MDR, AluOut, MDRMux_out);
input logic MemtoReg;
input logic [31:0] MDR, AluOut;
output logic [31:0] MDRMux_out;

always @ (MemtoReg) begin
case(MemtoReg)
1'b0:MDRMux_out <= AluOut;
1'b1:MDRMux_out <= MDR;
endcase
end
endmodule
