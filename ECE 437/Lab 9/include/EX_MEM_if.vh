`ifndef EX_MEM_IF_VH
`define EX_MEM_IF_VH

`include "cpu_types_pkg.vh"

interface EX_MEM_if;

    import cpu_types_pkg::*;

    word_t instruction_in, sign_extended_in, next_PC_in, rdat2_in, port_out_in;
    logic flush, EX_MEM_en, zero_in, MemWr_in, MemRead_in, RegWr_in, halt_in, dhit, MemtoReg_in, jumpR_in;
    logic [4:0] dest_reg_in;

    word_t instruction_out, sign_extended_out, next_PC_out, rdat2_out, port_out_out;
    logic zero_out, MemWr_out, MemRead_out, RegWr_out, halt_out, MemtoReg_out, jumpR_out;
    logic [4:0] dest_reg_out;

    logic taken_in, taken_out;

    modport exmem (
        input   instruction_in, sign_extended_in, next_PC_in, rdat2_in, port_out_in,
                flush, EX_MEM_en, zero_in, MemWr_in, MemRead_in, RegWr_in, halt_in, MemtoReg_in, dest_reg_in, dhit, jumpR_in, taken_in,
        output  instruction_out, sign_extended_out, next_PC_out, rdat2_out, port_out_out,
                zero_out, MemWr_out, MemRead_out, RegWr_out, halt_out, MemtoReg_out, dest_reg_out, jumpR_out, taken_out
    );

endinterface

`endif 