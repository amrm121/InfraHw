module Control(clk, Reset, OP, Funct, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, CauseWrite, IntCause, EPCWrite, PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst, AWrite, BWrite, StateAux, ResetPC, ResetA, ResetB, ResetEPC);

	input clk;
	input Reset;
	input [5:0] OP;
	input [5:0] Funct;
	

	output reg [0:5] StateAux; //estado auxiliar
	output reg PCWrite;
	output reg IorD;
	output reg MemRead; 
	output reg MemWrite;
	output reg MemtoReg; //regwrite
	output reg IRWrite; 
	output reg CauseWrite;
	output reg IntCause;
	output reg EPCWrite;
	output reg AWrite;
	output reg BWrite;
	output reg [1:0] PCSource;
	output reg [2:0] ALUOp;
	output reg ALUSrcA;
	output reg ALUSrcB;
	output reg RegWrite;
	output reg RegDst;
	output reg ResetPC;
	output reg ResetA;
	output reg ResetB;
	output reg ResetEPC;
	
	
	reg[5:0] st;
	reg ct;
	
	//regwrite
    parameter N_LOAD = 1'b0;
    parameter LOAD = 1'b1;
    parameter CLEAR = 1'b1;
    parameter N_CLEAR = 1'b0;
    
    //mem read/write
    parameter READ = 1'b0;
    parameter WRITE = 1'b1;
    
    //IorD
    parameter ID_PC = 1'b0;
    parameter ID_ALUOUT = 1'b1;
    
    //ALUSrcA
    parameter SA_PC = 1'b0; //PC
    parameter SA_A = 1'b1;
    
    //ALUSrcB
    parameter SB_4 = 2'b00; //PC+4
    parameter SB_B = 2'b01;
    parameter SB_SL2 = 2'b10; 
    parameter SB_SE = 2'b11;
    
    //Estados
	parameter RESET = 0;
	parameter INSTR_FETCH = 1;
	parameter IDLE = 2;
	parameter INSTR_DECODE = 3;
	parameter PC_WRT = 4;
	parameter STOP_PC = 5;
	parameter MEM_WRITE = 6;
	parameter IDLE_MEMORY = 7;
	parameter OP_NFOUND = 8;
	parameter RTYPE = 9;
	parameter BEQ = 10;
	parameter BNE = 11;
	parameter LW = 12;
	parameter SW = 13;
	parameter LUI = 14;
	parameter J = 15;
	
	//ALU
	parameter ALU_LOAD = 0;
	parameter ALU_ADD = 1;
	parameter ALU_SUB = 2;
	parameter ALU_AND = 3;
	parameter ALU_I = 4;
	parameter ALU_NOT = 5;
	parameter ALU_XOR = 6;
	parameter ALU_EQ = 7;
	
	//OPCODES
	parameter OP_R = 6'h0;
	parameter OP_BEQ = 6'h4;
	parameter OP_BNE = 6'h5;
	parameter OP_LW = 6'h23;
	parameter OP_SW = 6'h2b;
	parameter OP_LUI = 6'hf;
    parameter OP_J = 6'h2;
    
    initial begin
		st <= RESET;
	end;
	
always @ (negedge clk) begin
    StateAux <= st;
    
    case(st)
    
		RESET: begin 
		
		ResetPC <= CLEAR;
		ResetA <= CLEAR;
		ResetB <= CLEAR;
		ResetEPC <= CLEAR;
		RegWrite <= LOAD;
		st <= INSTR_FETCH;
		end
		
		INSTR_FETCH: begin
		
		RegWrite <= N_LOAD;
		ResetPC <= N_CLEAR;
		ResetA <= N_CLEAR;
		ResetB <= N_CLEAR;
		ResetEPC <= N_CLEAR;
		
		MemRead <= READ;
		ALUSrcA <= SA_PC;
		ALUSrcB <= SB_4;
		ALUOp <= ALU_ADD;
		PCWrite <= LOAD;
		IorD <= ID_PC;
		
		st <= IDLE;
		end
		
		IDLE: begin
		
		IRWrite <= LOAD;
		PCWrite <= N_LOAD;
		
		st <= ISNTR_DECODE;
		end
		
		INSTR_DECODE: begin
		
		IRWrite <= N_LOAD;
		ALUSrcA <= SA_PC;
		ALUSrcB <= SB_SL2;
		RegWrite <= N_LOAD;
		ALUOp <= ALU_ADD;
		AWrite <= LOAD;
		BWrite <= LOAD;
		case(OP)
			OP_BEQ: begin
				state <= BEQ;
			end
			
			OP_R: begin
				case(Funct)
				6'h20: begin
					state <= ADD;
				end
				6'h24 begin
					state <= AND;
				end
				6'h22 begin
					state <= SUB;
				end
				6'h26 begin
					state <= XOR;
				end
				6'hd begin
					state <= BREAK;
				end
				6'h0 begin
					state <= NOP;
				end
			endcase
			end
			
			default: begin
				state <= OP_NFOUND;
			end
			endcase
			
		end
		
end
endmodule
