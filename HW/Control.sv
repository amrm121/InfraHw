module Control(Clk, Reset, OP, PCWrite, IorD, Funct, wr, MemtoReg, IRWrite, PCSource, AluOp, AluSrcB, AluSrcA, AluOutWrite, RegWrite, RegDst, State, MDRWrite, AWrite, BWrite);

	input logic Clk, Reset;
	input logic [5:0] OP, Funct;
	
	output logic [2:0] AluOp;
	output logic [1:0] PCSource, AluSrcB;
	output logic PCWrite, IorD, wr, MemtoReg, IRWrite, RegDst, AluSrcA, AluOutWrite, RegWrite, MDRWrite, AWrite, BWrite;
	output logic [5:0] State;
	
	
	logic [5:0] st, StateA;
    
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
	parameter ADD = 16;
	parameter AND = 17;
	parameter SUB = 18;
	parameter XOR = 19;
	parameter BREAK = 20;
	parameter NOP = 21;
	
	
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
	end
    
    
	
always @ (posedge Clk) begin
	
    State <= st;
    
    case(st)
		
		RESET: begin 
		
		PCWrite = 1'b0;
		IorD = 1'b0;
		wr = 1'b0;
		MemtoReg = 1'b0;
		RegDst = 1'b0;
		PCSource = 2'b00;
		AluOp = 3'b000;
		IRWrite = 1'b0;
		RegDst = 1'b0;
		AluSrcA = 1'b0;
		AluSrcB = 2'b00;
		AluOutWrite = 1'b0;
		RegWrite = 1'b0;
		MDRWrite = 1'b0;
		AWrite = 1'b0;
		BWrite = 1'b0;
		
		st <= INSTR_FETCH;
		end
		
		INSTR_FETCH: begin
		
			IorD = 1'b0;
			wr = 1'b0;
		
		st <= IDLE;
		end
		
		IDLE: begin
		
			AluSrcA = 1'b0;
			AluSrcB = 2'b01;
			AluOp = 3'b001;
			PCWrite = 1'b1;
			PCSource = 2'b00;
		
		st <= IDLE_MEMORY;
		end
		
		IDLE_MEMORY: begin
			IRWrite = 1'b1;
			st <= INSTR_DECODE;
		end
		
		INSTR_DECODE: begin
			PCWrite = 1'b0;
			IRWrite = 1'b0;
			AluSrcA = 1'b0;
			AluSrcB = 2'b01;
			RegWrite = 1'b0;
			AluOp = 3'b001;
			AWrite = 1'b1;
			BWrite = 1'b1;
			case(OP)	
			OP_R: begin
				case(Funct)
				6'h20: begin
				st <= ADD;
				end
				6'h24: begin
				st <= AND;
				end
				6'h22: begin
				st <= SUB;
				end
				6'h26: begin
				st <= XOR;
				end
				6'hd: begin
				st <= BREAK;
				end
			endcase
			end
			BEQ: begin
				st <= BEQ;
			end
			ADD: begin
				st <= INSTR_FETCH;
			end
			SUB: begin
				st <= INSTR_FETCH;
			end
			AND: begin
				st <= INSTR_FETCH;
			end
			
			default: begin
				st <= OP_NFOUND;
			end
		endcase
		end
		
	endcase
end	
endmodule
