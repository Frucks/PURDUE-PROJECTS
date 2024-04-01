/*
  Eric Villasenor
  evillase@gmail.com

  register file interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     negative, overflow, zero;
  aluop_t   aluop;
  word_t    port_a, port_b, port_out;

  // alu ports
  modport alu (
    input   port_a, port_b, aluop,
    output  port_out, negative, overflow, zero
  );
  // alu tb
  modport tb (
    input  port_out, negative, overflow, zero,
    output   port_a, port_b, aluop
  );
endinterface

`endif //REGISTER_FILE_IF_VH
