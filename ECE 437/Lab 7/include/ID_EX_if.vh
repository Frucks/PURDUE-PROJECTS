`ifndef ID_EX_IF_VH
`define ID_EX_IF_VH

`include "cpu_types_pkg.vh"

interface ID_EX_if;

    import cpu_types_pkg::*;

    word_t instruction_in, next_PC_in, rdat1_in, rdat2_in, sign_extended_in;
    logic ID_EX_en, flush, ALUsrc_in, MemWr_in, MemRead_in, RegWr_in, LUI_flag_in, halt_in, MemtoReg_in, RegDst_in, jumpAL_in, jumpR_in;
    aluop_t aluop_in;
    regbits_t rs_in, rt_in, rd_in;
    logic stall;

    word_t instruction_out, next_PC_out, rdat1_out, rdat2_out, sign_extended_out;
    logic ALUsrc_out, MemWr_out, MemRead_out, RegWr_out, LUI_flag_out, halt_out, MemtoReg_out, RegDst_out, jumpAL_out, jumpR_out;
    aluop_t aluop_out;
    regbits_t rs_out, rt_out, rd_out;

    logic taken_in, taken_out;

    modport idex (
        input   instruction_in, next_PC_in, rdat1_in, rdat2_in, sign_extended_in, ID_EX_en, flush,
                ALUsrc_in, MemWr_in, MemRead_in, RegWr_in, LUI_flag_in, halt_in,
                MemtoReg_in, RegDst_in, aluop_in, rs_in, rt_in, rd_in, stall, jumpAL_in, jumpR_in, taken_in,
        output  instruction_out, next_PC_out, rdat1_out, rdat2_out, sign_extended_out,
                ALUsrc_out, MemWr_out, MemRead_out, RegWr_out, LUI_flag_out, halt_out,
                MemtoReg_out, RegDst_out, aluop_out, rs_out, rt_out, rd_out, jumpAL_out, jumpR_out, taken_out
    );

endinterface

`endif 