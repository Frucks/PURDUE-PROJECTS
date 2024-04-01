`include "ID_EX_if.vh"
`include "cpu_types_pkg.vh"

module ID_EX (
	input logic CLK, nRST, 
	ID_EX_if.idex idif
);

	import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST) begin
        if(~nRST) begin
            idif.instruction_out <= '0;
            idif.sign_extended_out <= '0;
            idif.next_PC_out <= '0;
            idif.rdat1_out <= '0;
            idif.rdat2_out <= '0;
            idif.ALUsrc_out <= 0;
            idif.MemWr_out <= 0;
            idif.MemRead_out <= 0;
            idif.RegWr_out <= 0;
            idif.LUI_flag_out <= 0;
            idif.MemtoReg_out <= '0;
            idif.RegDst_out <= '0;
            idif.aluop_out <= ALU_SLL; 
            idif.halt_out <= 0;
            idif.rs_out <= '0;
            idif.rt_out <= '0;
            idif.rd_out <= '0;
            idif.jumpAL_out <= 0;
            idif.jumpR_out <= 0;
            idif.taken_out <= 0;
        end else if(idif.flush) begin 
            idif.instruction_out <= '0;
            idif.sign_extended_out <= '0;
            idif.next_PC_out <= '0;
            idif.rdat1_out <= '0;
            idif.rdat2_out <= '0;
            idif.ALUsrc_out <= 0;
            idif.MemWr_out <= 0;
            idif.MemRead_out <= 0;
            idif.RegWr_out <= 0;
            idif.LUI_flag_out <= 0;
            idif.MemtoReg_out <= '0;
            idif.RegDst_out <= '0;
            idif.aluop_out <= ALU_SLL; 
            idif.halt_out <= 0;
            idif.rs_out <= '0;
            idif.rt_out <= '0;
            idif.rd_out <= '0;
            idif.jumpAL_out <= 0;
            idif.jumpR_out <= 0;
            idif.taken_out <= 0;
        end else if(idif.ID_EX_en) begin 
            if (idif.stall) begin
                idif.instruction_out <= '0;
                idif.sign_extended_out <= '0;
                idif.next_PC_out <= '0;
                idif.rdat1_out <= '0;
                idif.rdat2_out <= '0;
                idif.ALUsrc_out <= 0;
                idif.MemWr_out <= 0;
                idif.MemRead_out <= 0;
                idif.RegWr_out <= 0;
                idif.LUI_flag_out <= 0;
                idif.MemtoReg_out <= '0;
                idif.RegDst_out <= '0;
                idif.aluop_out <= ALU_SLL; 
                idif.halt_out <= 0;
                idif.rs_out <= '0;
                idif.rt_out <= '0;
                idif.rd_out <= '0;
                idif.jumpAL_out <= 0;
                idif.jumpR_out <= 0;
                idif.taken_out <= 0;
            end
            else begin
                idif.instruction_out <= idif.instruction_in;
                idif.sign_extended_out <= idif.sign_extended_in;
                idif.next_PC_out <= idif.next_PC_in;
                idif.rdat1_out <= idif.rdat1_in;
                idif.rdat2_out <= idif.rdat2_in;
                idif.ALUsrc_out <= idif.ALUsrc_in;
                idif.MemWr_out <= idif.MemWr_in;
                idif.MemRead_out <= idif.MemRead_in;
                idif.RegWr_out <= idif.RegWr_in;
                idif.LUI_flag_out <= idif.LUI_flag_in;
                idif.MemtoReg_out <= idif.MemtoReg_in;
                idif.RegDst_out <= idif.RegDst_in;
                idif.aluop_out <= idif.aluop_in; 
                idif.halt_out <= idif.halt_in;
                idif.rs_out <= idif.rs_in;
                idif.rt_out <= idif.rt_in;
                idif.rd_out <= idif.rd_in;
                idif.jumpAL_out <= idif.jumpAL_in;
                idif.jumpR_out <= idif.jumpR_in;
                idif.taken_out <= idif.taken_in;
            end
        end
    end

endmodule
