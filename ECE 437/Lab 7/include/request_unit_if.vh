`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface request_unit_if;

    import cpu_types_pkg::*;

    logic dWEN, dREN, dhit, ihit, imemREN, dmemREN, dmemWEN, PCEN;

    modport ru (
        input dWEN, dREN, dhit, ihit,
        output imemREN, dmemREN, dmemWEN
    );

    modport tb (
        input imemREN, dmemREN, dmemWEN,
        output dWEN, dREN, dhit, ihit
    );

endinterface

`endif
