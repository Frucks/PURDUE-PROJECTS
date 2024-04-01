`ifndef BRANCH_PREDICTOR_IF_VH
`define BRANCH_PREDICTOR_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface branch_predictor_if;
  // import types
  import cpu_types_pkg::*;

  logic good, bad, take;

  // alu ports
  modport bp (
    input   good, bad,
    output  take
  );
endinterface

`endif
