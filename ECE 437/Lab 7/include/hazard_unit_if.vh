`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  import cpu_types_pkg::*;
  
  regbits_t id_rt, if_rs, if_rt;
  logic id_memRead, stall;


  modport hu (
    input id_rt, id_memRead, if_rs, if_rt,
    output stall
  );
endinterface

`endif