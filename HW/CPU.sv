module CPU (Clock, rst, MemData, Address, WriteDataMem, WriteRegister, WriteDataReg, MDR, Alu, AluOut, PC, Reg_Desloc, wr, RegWrite, IRWrite, EPC, mul_Module, Estado);

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
//wr-BIT que controla se o dado é lido ou escrito na memoria
//RegWrite-BIT que controla escrita/leitura no banco de reg
//IRWrite-BIT controla escrita no reg insruções
//EPC-valor no reg EPC
//mul_Module-modulo da multiplicacao
//Estado-numero do estado que a ControlUnit se encontra

output logic [31:0] MemData, Address, WriteDataMem, WriteDataReg, MDR, Alu, AluOut, PC, Reg_Desloc, EPC, mul_Module, WriteRegister;
output logic wr, RegWrite, IRWrite;
output logic [5:0] Estado;

logic [5:0] Opc;
logic [4:0] I25_21, I20_16;
logic [15:0] I15_0;
logic [1:0] pcsr, alub;
logic [2:0] aluop;
logic [31:0] iordm, Areg, Breg, Areg_out, Breg_out, ALUAin, ALUBin, PCin;
logic pcwrt, iord, mread, func, WRr, mreg, irwr, alua, rgwrt, rgdst, st, aluoutwr, mdrwt, bwrt, awrt;


Control control(.Clk(Clock), 
				.Reset(rst), 
				.OP(Opc), 
				.PCWrite(pcwrt), 
				.IorD(iord),  
				.Funct(I15_0[5-0]), 
				.wr(WRr),
				.MemtoReg(mreg), 
				.IRWrite(irwr), 
				.PCSource(pcsr),
				.AluOp(aluop),
				.AluSrcB(alub),
				.AluSrcA(alua),
				.RegWrite(rgwrt),
				.RegDst(rgdst),
				.State(Estado),
				.AluOutWrite(aluoutwr),
				.MDRWrite(mdrwt),
				.AWrite(awrt),
				.BWrite(bwrt));

//Multiplexes
IorDMux iordmux(.IorD(iord),
				.PC(PC),
				.AluOut(AluOut),
				.mux_out(Address));
			 
RegDstMux rdmux(.RegDst(rgdst),
				.I20_16(I20_16),
				.I15_11(I15_0[15:11]),
				.wrtRegMux_out(WriteRegister));

MDRMux mdrmux(.MemtoReg(mreg),
			  .MDR(MDR),
			  .AluOut(AluOut),
		   	  .MDRMux_out(WriteDataReg));

AluAMux ramux(.AluSrcA(alua),
			  .A(AReg_out),
			  .PC(PC),
			  .mux_out(ALUAin));

AluBMux rbmux(.AluSrcB(alub),
			  .B(BReg_out),
			  .SignE(),
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
				.Wr(WRr),
				.Datain(Breg_out),
				.Dataout(MemData));
				

				
Instr_Reg 	IR(.Clk(Clock),
			   .Reset(rst),
			   .Load_ir(irwr),
			   .Entrada(MemData),
			   .Instr31_26(Opc),
			   .Instr25_21(I25_21),
			   .Instr20_16(I20_16),
			   .Instr15_0(I15_0));
			   
Banco_Reg 	BRE(.Clk(Clock),
			   .Reset(rst),
			   .RegWrite(rgwrt),
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
			
			   

			   




endmodule
