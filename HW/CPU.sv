module CPU (Clock, rst, MemData, Address, WriteDataMem, WriteRegister, WriteDataReg, MDR, Alu, AluOut, I25_21, I20_16, RegWrite, PC, Reg_Desloc, iord, wr, IRWrite, EPC, mul_Module, Estado, Areg, Breg, Areg_out, Breg_out, aluop);

input logic Clock;
input logic rst;

//MemData-saida memoria 
//Address-end escrita/leit(apos iord mux) 
//WriteDataMem-valor a ser escrito na memoria 
//WriteRegister-numero do reg a ser escrito o dado
//WriteDataReg-dado a ser escrito no reg
//MDR-valor MDR
//Alu-valor que sai da ALU
//AluOut-valor da saida do reg AluOut
//PC-valor presente no PC
//Reg_Desloc-valor no reg deslocamento
//wr-BIT que controla se o dado � lido ou escrito na memoria
//RegWrite-BIT que controla escrita/leitura no banco de reg
//IRWrite-BIT controla escrita no reg insru��es
//EPC-valor no reg EPC
//mul_Module-modulo da multiplicacao
//Estado-numero do estado que a ControlUnit se encontra

output logic [31:0] MemData, 
					Address, 
					WriteDataMem, 
					WriteDataReg, 
					MDR, 
					Alu, 
					AluOut, 
					PC, 
					Reg_Desloc, 
					EPC, 
					mul_Module, 
					WriteRegister,
					Areg, 
					Breg, 
					Areg_out, 
					Breg_out;
output logic wr, 
		     RegWrite, 
		     IRWrite,
			 iord;
		     
output logic [5:0] Estado;

output logic [4:0] I25_21, 
				   I20_16;

logic [5:0] Opc;

logic [15:0] I15_0;
logic [1:0] pcsr, alub;
output logic [2:0] aluop;
logic [31:0] iordm, ALUAin, ALUBin, PCin, signExtended;
logic pcwrt, mread, func, mreg, alua, rgdst, st, aluoutwr, mdrwt;


Control control(.Clk(Clock), 
				.Reset(rst), 
				.OP(Opc), 
				.PCWrite(pcwrt), 
				.IorD(iord),  
				.Funct({I15_0[5:0]}), 
				.wr(wr),
				.MemtoReg(mreg), 
				.IRWrite_C(IRWrite), 
				.PCSource(pcsr),
				.AluOp(aluop),
				.AluSrcB(alub),
				.AluSrcA(alua),
				.RegWrite_C(RegWrite),
				.RegDst(rgdst),
				.State(Estado),
				.AluOutWrite(aluoutwr),
				.MDRWrite(mdrwt),
				.AWrite(AWrite),
				.BWrite(BWrite));

//Multiplexes
IorDMux iordmux(.IorD(iord),
				.PC(PC),
				.AluOut(AluOut),
				.mux_out(Address));
			 
RegDstMux rdmux(.RegDst(rgdst),
				.I20_16(I20_16),
				.I15_11({I15_0[15:11]}),
				.wrtRegMux_out(WriteRegister));

MDRMux mdrmux(.MemtoReg(mreg),
			  .MDR(MDR),
			  .AluOut(AluOut),
		   	  .MDRMux_out(WriteDataReg));

AluAMux ramux(.AluSrcA(alua),
			  .A(Areg_out),
			  .PC(PC),
			  .mux_out(ALUAin));

AluBMux rbmux(.AluSrcB(alub),
			  .B(Breg_out),
			  .SignE(signExtended),
			  .SL2(),
			  .mux_out(ALUBin));
			  
PCSourceMux pcmux(.PCSource(pcsr),
				  .AluS(Alu),
				  .AluOut(AluOut),
				  .Jump(),
				  .EPC(EPC),
				  .mux_out(PCin));
				


//Regs
Registrador   A(.Clk(Clock),
				.Entrada(Areg),
				.Saida(Areg_out),
				.Reset(rst),
				.Load(AWrite));

Registrador   B(.Clk(Clock),
				.Entrada(Breg),
				.Saida(Breg_out),
				.Reset(rst),
				.Load(BWrite));
				
Registrador PCR(.Clk(Clock), 
				.Entrada(PCin),
				.Saida(PC), 
				.Reset(rst), 
				.Load(pcwrt));

Registrador RMDR(.Clk(Clock), 
				.Entrada(MemData), 
				.Saida(MDR), 
				.Reset(rst), 
				.Load(mdrwt));

Registrador AluOutR(.Clk(Clock),
					.Entrada(Alu),
					.Saida(AluOut),
					.Reset(rst),
					.Load(aluoutwr));
				
				
				
//Read 0 . Write 1		
Memoria 	MEM(.Address(Address),
				.Clock(Clock),
				.Wr(wr),
				.Datain(),
				.Dataout(MemData));
				

				
Instr_Reg 	IR(.Clk(Clock),
			   .Reset(rst),
			   .Load_ir(IRWrite),
			   .Entrada(MemData),
			   .Instr31_26(Opc),
			   .Instr25_21(I25_21),
			   .Instr20_16(I20_16),
			   .Instr15_0(I15_0));
			   
Banco_Reg 	BRE(.Clk(Clock),
			   .Reset(rst),
			   .RegWrite(RegWrite),
			   .ReadReg1(I25_21),
			   .ReadReg2(I20_16),
			   .WriteReg(WriteRegister),
			   .WriteData(WriteDataReg),
			   .ReadData1(Areg),
			   .ReadData2(Breg));
			   
			   
Ula32		 ALU(.A(ALUAin),
				 .B(ALUBin),
				 .Seletor(aluop),
				 .S(Alu),
				 .Overflow(),
				 .Negativo(),
				 .z(),
				 .Igual(),
				 .Maior(),
				 .Menor());

SignExtend signExtend (.A(I15_0),
					   .Out(signExtended));
			   
endmodule
