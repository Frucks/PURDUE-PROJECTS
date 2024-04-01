`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  import cpu_types_pkg::*;
  
  regbits_t ex_dest, mem_dest, id_rs, id_rt;
  logic ex_regWrite, mem_regWrite;
  logic [1:0] forwardA, forwardB;

  modport fu (
    input ex_dest, mem_dest, id_rs, id_rt, ex_regWrite, mem_regWrite,
    output forwardA, forwardB
  );
endinterface

`endif