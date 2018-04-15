module SignExtend(A, Out);
	input [15:0] A; //16bits entry
	output [31:0] Out; //32bits output

assign Out = {16'b0000000000000000, A};

endmodule
