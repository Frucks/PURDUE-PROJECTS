`ifndef MEM_WB_IF_VH
`define MEM_WB_IF_VH

`include "cpu_types_pkg.vh"

interface MEM_WB_if;

    import cpu_types_pkg::*;

    word_t instruction_in, next_PC_in, port_out_in, dmemload_in;
    logic MEM_WB_en, RegWr_in, halt_in, MemtoReg_in;
    logic [4:0] dest_reg_in;

    word_t instruction_out, next_PC_out, port_out_out, dmemload_out;
    logic RegWr_out, halt_out, MemtoReg_out;
    logic [4:0] dest_reg_out;

    modport memwb (
        input   instruction_in, next_PC_in, port_out_in, dmemload_in,
                MEM_WB_en, RegWr_in, halt_in, MemtoReg_in, dest_reg_in,
        output  instruction_out, next_PC_out, port_out_out, dmemload_out,
                RegWr_out, halt_out, MemtoReg_out, dest_reg_out
    );

endinterface

`endif 