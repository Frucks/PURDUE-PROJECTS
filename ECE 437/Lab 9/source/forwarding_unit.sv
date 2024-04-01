`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"

module forwarding_unit (
  forwarding_unit_if.fu fuif
);

  import cpu_types_pkg::*;

  assign fuif.forwarded_A = (fuif.ex_regWrite && (fuif.ex_dest) && (fuif.ex_dest == fuif.id_rs)) ? fuif.port_out_out : ((fuif.mem_regWrite && (fuif.mem_dest) && (fuif.mem_dest == fuif.id_rs)) ? fuif.wdat : fuif.rdat1_out);
  assign fuif.forwarded_B = (fuif.ex_regWrite && (fuif.ex_dest) && (fuif.ex_dest == fuif.id_rt)) ? fuif.port_out_out : ((fuif.mem_regWrite && (fuif.mem_dest) && (fuif.mem_dest == fuif.id_rt)) ? fuif.wdat : fuif.rdat2_out);

endmodule