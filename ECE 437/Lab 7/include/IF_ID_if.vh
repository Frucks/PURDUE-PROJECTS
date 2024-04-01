`ifndef IF_ID_IF_VH
`define IF_ID_IF_VH

`include "cpu_types_pkg.vh"

interface IF_ID_if;

    import cpu_types_pkg::*;

    word_t instruction_in, next_PC_in, instruction_out, next_PC_out;
    logic IF_ID_en, flush;
    regbits_t rs_in, rt_in, rd_in;
    regbits_t rs_out, rt_out, rd_out;

    logic taken_in, taken_out;


    modport ifid (
        input   instruction_in, next_PC_in, IF_ID_en, flush, rs_in, rt_in, rd_in, taken_in,
        output  instruction_out, next_PC_out, rs_out, rt_out, rd_out, taken_out
    );

endinterface

`endif 