`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
    // import types
    import cpu_types_pkg::*;

    word_t instruction;
    logic ALUsrc, MemWr, MemRead, RegWr, ExtOp, branch, LUI_flag, halt, jump, jumpAL, jumpR, MemtoReg, RegDst;
    aluop_t aluop;

    modport cu (
        input instruction,
        output ALUsrc, MemWr, MemRead, RegWr, RegDst, ExtOp, branch, LUI_flag, halt, MemtoReg, jump, jumpAL, jumpR, aluop
    );

endinterface

`endif