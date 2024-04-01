`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

module control_unit (
    control_unit_if.cu cuif
);

import cpu_types_pkg::*;

opcode_t opcode;
funct_t func;

always_comb begin
    cuif.ALUsrc = 0;
	cuif.MemRead = 0;
    cuif.MemWr = 0;
    cuif.MemtoReg = 0;
    cuif.RegWr = 0;
    cuif.RegDst = 0;
	cuif.ExtOp = 0;
    cuif.branch = 0;
	cuif.jump = 0;
	cuif.jumpAL = 0;
	cuif.jumpR = 0;
	cuif.LUI_flag = 0;
    cuif.halt = 0;
    cuif.aluop = ALU_AND;
	casez (opcode)
		//J TYPE
		J: begin cuif.jump = 1; end
		JAL: begin cuif.jump = 1; cuif.jumpAL = 1; cuif.RegWr = 1; cuif.aluop = ALU_OR; end
		//I TYPE
		BEQ: begin cuif.branch = 1; cuif.aluop = ALU_SUB; end
		BNE: begin cuif.branch = 1; cuif.aluop = ALU_SUB; end
		ADDI: begin cuif.ALUsrc = 1; cuif.aluop = ALU_ADD; cuif.RegWr = 1; end // changed
		ADDIU: begin cuif.ALUsrc = 1; cuif.aluop = ALU_ADD; cuif.RegWr = 1; end
		SLTI: begin cuif.ALUsrc = 1; cuif.aluop = ALU_SLT; cuif.RegWr = 1; end
		SLTIU: begin cuif.ALUsrc = 1; cuif.aluop = ALU_SLTU; cuif.RegWr = 1; end
		ANDI: begin cuif.ALUsrc = 1; cuif.aluop = ALU_AND; cuif.RegWr = 1; cuif.ExtOp = 1; end
		ORI: begin cuif.ALUsrc = 1; cuif.aluop = ALU_OR; cuif.RegWr = 1; cuif.ExtOp = 1; end
		XORI: begin cuif.ALUsrc = 1; cuif.aluop = ALU_XOR; cuif.RegWr = 1; cuif.ExtOp = 1; end
		LUI: begin cuif.ALUsrc = 1; cuif.aluop = ALU_SLL; cuif.RegWr = 1; cuif.LUI_flag = 1; end
		LW: begin cuif.ALUsrc = 1; cuif.aluop = ALU_ADD; cuif.RegWr = 1; cuif.MemRead = 1; cuif.MemtoReg = 1; end
		SW: begin cuif.ALUsrc = 1; cuif.aluop = ALU_ADD; cuif.MemWr = 1; end
		//R TYPE
		RTYPE: begin
			cuif.RegDst = 1;
			cuif.RegWr = 1;
			casez (func)
				SLLV: cuif.aluop = ALU_SLL;
				SRLV: cuif.aluop = ALU_SRL;
				JR: begin cuif.jumpR = 1; cuif.RegWr = 0; cuif.aluop = ALU_OR; end
				ADD,
				ADDU: cuif.aluop = ALU_ADD;
				SUB,
				SUBU: cuif.aluop = ALU_SUB;
				AND: cuif.aluop = ALU_AND;
				OR: cuif.aluop = ALU_OR;
				XOR: cuif.aluop = ALU_XOR;
				NOR: cuif.aluop = ALU_NOR;
				SLT: cuif.aluop = ALU_SLT;
				SLTU: cuif.aluop = ALU_SLTU;
				default: begin cuif.aluop = ALU_AND; cuif.RegWr = 0; end
			endcase
		end
		//OTHER
		HALT: begin cuif.halt = 1; end
		default: begin cuif.branch = 0; cuif.jump = 0; cuif.jumpAL = 0; cuif.jumpR = 0; cuif.ALUsrc = 0; cuif.RegWr = 0; cuif.RegDst = 0; cuif.MemRead = 0; cuif.MemWr = 0; cuif.MemtoReg = 0; cuif.aluop = ALU_AND; cuif.LUI_flag = 0; cuif.ExtOp = 0; cuif.halt = 0; end
	endcase
end

assign opcode = opcode_t'(cuif.instruction[31:26]);
assign func = funct_t'(cuif.instruction[5:0]); 

endmodule