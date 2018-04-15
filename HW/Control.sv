module Control(Clk, 
			   Reset, 
			   OP, 
			   PCWrite, 
			   IorD, 
			   Funct, 
			   wr, 
			   MemtoReg, 
			   IRWrite_C, 
			   PCSource, 
			   AluOp, 
			   AluSrcB, 
			   AluSrcA, 
			   AluOutWrite, 
			   RegWrite_C, 
			   RegDst, 
			   State, 
			   MDRWrite, 
			   AWrite, 
			   BWrite);

	input logic Clk, Reset;
	input logic [5:0] OP, Funct;
	
	output logic [2:0] AluOp;
	output logic [1:0] PCSource, AluSrcB;
	output logic PCWrite, 
				 IorD, 
				 wr, 
				 MemtoReg, 
				 IRWrite_C, 
				 RegDst, 
				 AluSrcA, 
				 AluOutWrite, 
				 RegWrite_C, 
				 MDRWrite, 
				 AWrite, 
				 BWrite;
	output logic [5:0] State;
	
	
	logic [5:0] st, StateA;
    
    //Estados de Escrita da Decodificação
    parameter A_AND_B_WRITE_ADD = 5;
    parameter A_AND_B_WRITE_SUB = 6;
    parameter A_AND_B_WRITE_AND = 7;
    parameter A_AND_B_WRITE_XOR = 8;
    parameter A_AND_B_WRITE_LW = 9;
    parameter A_AND_B_WRITE_SW = 10;
    parameter A_AND_B_WRITE_BEQ = 11;
    parameter A_AND_B_WRITE_BNE = 12;
    parameter A_AND_B_WRITE_LUI = 13;
    
    //Estado de Reset 
	parameter RESET = 0;
	
	//Estado de Espera
	parameter WAIT_1 = 50;
	parameter WAIT_2 = 51;
	parameter WAIT_3 = 52;
	
	//
	parameter MEMORY_ACCESS = 1;
	parameter MEMORY_ACCESS_LOAD_INSTR = 26;
	parameter MDR_WRITE_LOAD_INSTR = 27;
	parameter REGISTER_WRITE_LOAD_INSTR = 28;
	parameter INCREMENT_PC = 2;

	parameter INSTR_WRITE = 3;
	parameter INSTR_DECODE = 4;
	parameter A_AND_B_WRITE = 5;
	parameter ALU_OUT_WRITE_R_TYPE = 23;
	parameter ALU_OUT_WRITE_LOAD = 25;
	parameter REGISTER_WRITE_RTYPE = 24;
	parameter PC_WRT = 6;
	parameter STOP_PC = 7;
	parameter MEM_WRITE = 8;
	parameter OP_NFOUND = 9;	
	parameter RTYPE = 10;
	parameter BEQ = 11;
	parameter BNE = 12;
	parameter LW = 13;
	parameter SW = 14;
	parameter LUI = 15;
	parameter J = 16;
	parameter ADD = 17;
	parameter AND = 18;
	parameter SUB = 19;
	parameter XOR = 20;
	parameter BREAK = 21;
	parameter NOP = 22;
	
	
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
		IRWrite_C = 1'b0;
		RegDst = 1'b0;
		AluSrcA = 1'b0;
		AluSrcB = 2'b00;
		AluOutWrite = 1'b0;
		RegWrite_C = 1'b0;
		MDRWrite = 1'b0;
		AWrite = 1'b0;
		BWrite = 1'b0;
		
		st <= MEMORY_ACCESS;
		end
		
		MEMORY_ACCESS: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			PCSource = 2'b00;
			AluOp = 3'b000;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
		
		st <= INCREMENT_PC;
		end
		
		INCREMENT_PC: begin
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
			AluSrcA = 1'b0;
			AluSrcB = 2'b01;
			AluOp = 3'b001;
			PCWrite = 1'b1;
			PCSource = 2'b00;
		
			st <= WAIT1;
		end
		
		WAIT1: begin
			PCWrite = 1'b0;
			st <= INSTR_WRITE;
		end
		
		INSTR_WRITE: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b1;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			AluOp = 3'b000;
			PCSource = 2'b00;
			st <= INSTR_DECODE;
		end
		
		INSTR_DECODE: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			AluOp = 3'b000;
			PCSource = 2'b00;
			
			case(OP)	
				OP_R: begin
					case(Funct)
						6'h20: begin //ADD
							st <= A_AND_B_WRITE;
						end
						6'h24: begin //AND
							st <= A_AND_B_WRITE;
						end
						6'h22: begin //SUB
							st <= A_AND_B_WRITE;
						end
						6'h26: begin //XOR
							st <= A_AND_B_WRITE;
						end
						6'hd: begin //BREAK
							st <= BREAK;
						end
					endcase
				end
				OP_BEQ: begin
					st <= A_AND_B_WRITE;
				end
				OP_BNE: begin
					st <= A_AND_B_WRITE;
				end
				OP_LW: begin
					st <= A_AND_B_WRITE;
				end
				OP_SW: begin
					st <= A_AND_B_WRITE;
				end
				OP_LUI: begin
					st <= A_AND_B_WRITE;
				end
				//OP_J: begin
					//st <= BIT_EXTENSION;
				//end
			endcase
		end			
			
		A_AND_B_WRITE: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;	
			IorD = 1'b0;
			wr = 1'b0;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			AluOp = 3'b000;
			PCSource = 2'b00;
			AWrite = 1'b1;
			BWrite = 1'b1;
			
			case(OP)	
				OP_R: begin
					case(Funct)
						6'h20: begin //ADD
							st <= ADD;
						end
						6'h24: begin //AND
							st <= MEMORY_ACCESS;
						end
						6'h22: begin //SUB
							st <= MEMORY_ACCESS;
						end
						6'h26: begin //XOR
							st <= MEMORY_ACCESS;
						end
						default: begin
							st <= MEMORY_ACCESS;
						end
					endcase
				end
				OP_LW: begin
					PCWrite = 1'b0;
					MemtoReg = 1'b0;
					RegDst = 1'b0;
					IRWrite_C = 1'b0;
					RegDst = 1'b0;
					AluOutWrite = 1'b0;
					RegWrite_C = 1'b0;
					MDRWrite = 1'b0;	
					IorD = 1'b0;
					wr = 1'b0;
					AluSrcA = 1'b1;
					AluSrcB = 2'b10;
					AluOp = 3'b001;
					PCSource = 2'b00;
					AWrite = 1'b0;
					BWrite = 1'b0;
					st <= ALU_OUT_WRITE_LOAD;
				end
			endcase
		end
		
		ADD: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
			PCSource = 2'b00;
			
			AluOp = 3'b001;
			AluSrcA = 1'b1;
			AluSrcB = 2'b00;
			st <= ALU_OUT_WRITE_R_TYPE;
		end

	//Estados de Escrita em ALUOut
		ALU_OUT_WRITE_LOAD: begin
			AluOutWrite = 1'b1;
			st <= MEMORY_ACCESS_LOAD_INSTR;
		end
		
		ALU_OUT_WRITE_R_TYPE: begin
			AluOutWrite = 1'b1;
			st <= REGISTER_WRITE_RTYPE;
		end
		
		MEMORY_ACCESS_LOAD_INSTR: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b1;
			wr = 1'b0;
			PCSource = 2'b00;	
			AluOp = 3'b000;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			
			st <= WAIT_2;
		end
		
		WAIT_2: begin
			st <= WAIT_3;
		end
		
		WAIT_3: begin
			st <= MDR_WRITE_LOAD_INSTR;
		end
		
		MDR_WRITE_LOAD_INSTR: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b0;
			MDRWrite = 1'b1;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
			PCSource = 2'b00;	
			AluOp = 3'b000;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			
			st <= REGISTER_WRITE_LOAD_INSTR;
		end
			
	
	//Estados de Escrita no Banco de Registradores	
		REGISTER_WRITE_RTYPE: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b0;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b1;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b1;
			MDRWrite = 1'b0;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b0;
			wr = 1'b0;
			PCSource = 2'b00;
			AluOp = 3'b000;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			
			st <= MEMORY_ACCESS;
			//default: begin
			//	st <= OP_NFOUND;
			//end
		end
		
		REGISTER_WRITE_LOAD_INSTR: begin
			PCWrite = 1'b0;
			MemtoReg = 1'b1;
			RegDst = 1'b0;
			IRWrite_C = 1'b0;
			RegDst = 1'b0;
			AluOutWrite = 1'b0;
			RegWrite_C = 1'b1;
			MDRWrite = 1'b1;
			AWrite = 1'b0;
			BWrite = 1'b0;		
			IorD = 1'b1;
			wr = 1'b0;
			PCSource = 2'b00;
			AluOp = 3'b000;
			AluSrcA = 1'b0;
			AluSrcB = 2'b00;
			st <= MEMORY_ACCESS;
		end
	endcase
end
endmodule
