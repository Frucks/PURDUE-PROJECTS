`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"

module forwarding_unit (
  forwarding_unit_if.fu fuif
);

    import cpu_types_pkg::*;

    assign fuif.forwardA = (fuif.ex_regWrite && (fuif.ex_dest != 0) && (fuif.ex_dest == fuif.id_rs)) ? 2'b10 : ((fuif.mem_regWrite && (fuif.mem_dest != 0) && (fuif.mem_dest == fuif.id_rs)) ? 2'b01 : 2'b00);
    assign fuif.forwardB = (fuif.ex_regWrite && (fuif.ex_dest != 0) && (fuif.ex_dest == fuif.id_rt)) ? 2'b10 : ((fuif.mem_regWrite && (fuif.mem_dest != 0) && (fuif.mem_dest == fuif.id_rt)) ? 2'b01 : 2'b00);

endmodule
