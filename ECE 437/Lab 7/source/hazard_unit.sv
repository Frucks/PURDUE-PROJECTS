`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"

module hazard_unit (
  hazard_unit_if.hu huif
);

  // import types
  import cpu_types_pkg::*;

  assign huif.stall = (huif.id_memRead && ((huif.id_rt == huif.if_rs) || (huif.id_rt == huif.if_rt))) ? 1 : 0;

endmodule