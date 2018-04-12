module CPU (Clock, Reset, Estado, SaidaPC, SaidaA, SaidaB, SaidaALU, Reg1, Reg2, entrada, funct, EntradaMem, SaidaMem);

input Clock;
input Reset;

output wire [5:0] Estado;
output wire [31:0] SaidaPC;
output wire [31:0] SaidaA;  
output wire [31:0] SaidaB;
output wire [31:0] SaidaALU;
output wire [31:0] Reg1;
output wire [31:0] Reg2;
output wire [31:0] entrada;
output wire [5:0] funct;
output wire [31:0] EntradaMem;
output wire [31:0] SaidaMem;

wire PCWrite;
wire IorD;
wire MemRead;
wire MemWrite;
wire RegWrite;
wire MemtoReg;
wire RegDst;
wire IRWrite;
wire AluSrcA;
wire AWrite;
wire BWrite;
wire ResetPC;
wire ResetA;
wire ResetB;
wire EPCWrite;
wire ResetEPC;
wire CauseWrite; //error wire
wire IntCause; //
wire [1:0] AluSrcB;
wire [5:0] WOP;
wire [4:0] WRS;
wire [4:0] WRT;
wire [15:0] WIMMED;
wire [31:0] WRD;
wire [31:0] WPC;
wire [31:0] WA;
wire [31:0] WAI;
wire [31:0] WB;
wire [31:0] WBI;
wire [31:0] WMemIn;
wire [31:0] WMemOut;
wire [31:0] WALU;
wire [31:0] WSL2;
wire [4:0] W31_26;
wire [4:0] W25_21;
wire [4:0] W20_16;
wire [4:0] W15_0;

	

Control control (Clock, Reset, WOP, W31_26, PCWrite, IorD, MemRead. MemWrite, MemtoReg, IRWrite, 

Registrador RA (Clock, ResetA, AWrite, WAI, WA);
Registrador RB (Clock, ResetB, BWrite, WBI, WB);

endmodule
