`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface program_counter_if;
  import cpu_types_pkg::*;

  word_t PC, new_PC, next_PC;
  logic PCEN;

  modport pc (
	  input PCEN, new_PC,
	  output PC, next_PC
  );

  modport tb (
	  input PC, next_PC,
	  output PCEN, new_PC
  );

endinterface

`endif