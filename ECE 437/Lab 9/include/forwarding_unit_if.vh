`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  import cpu_types_pkg::*;
  
  regbits_t ex_dest, mem_dest, id_rs, id_rt;
  logic ex_regWrite, mem_regWrite;
  word_t forwarded_A, forwarded_B;
  word_t wdat, port_out_out, rdat1_out, rdat2_out;

  modport fu (
    input ex_dest, mem_dest, id_rs, id_rt, ex_regWrite, mem_regWrite, wdat, port_out_out, rdat1_out, rdat2_out,
    output forwarded_A, forwarded_B
  );
endinterface

`endif