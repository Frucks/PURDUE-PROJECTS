/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  always_comb begin
    ccif.ramREN = 0;
    ccif.ramWEN = 0;
    ccif.dload = ccif.ramload;
    ccif.ramaddr = ccif.daddr;
    ccif.ramstore = ccif.dstore;
    ccif.iload = ccif.ramload;
    if (ccif.dREN) begin
      ccif.ramREN = 1;
      ccif.ramaddr = ccif.daddr;
      ccif.dload = ccif.ramload;
    end
    else if (ccif.dWEN) begin
      ccif.ramWEN = 1;
      ccif.ramaddr = ccif.daddr;
      ccif.ramstore = ccif.dstore;
    end
    else if (ccif.iREN) begin
      ccif.ramREN = 1;
      ccif.ramaddr = ccif.iaddr;
      ccif.iload = ccif.ramload;
    end
    else begin
      ccif.ramREN = 0;
      ccif.ramWEN = 0;
      ccif.dload = ccif.ramload;
      ccif.ramaddr = ccif.daddr;
      ccif.ramstore = ccif.dstore;
      ccif.iload = ccif.ramload;
    end
  end

  always_comb begin
    ccif.iwait = 1;
    ccif.dwait = 1;
    if (ccif.ramstate == ACCESS) begin
      if (ccif.dREN || ccif.dWEN) begin
        ccif.dwait = 0;
      end
      else if (ccif.iREN) begin
        ccif.iwait = 0;
      end
    end
  end

  // assign ccif.iload = ccif.ramload;
  // assign ccif.dload = ccif.ramload;
  // assign ccif.ramstore = ccif.dstore;
  // assign ccif.ramaddr = (!(ccif.dREN || ccif.dWEN) && ccif.iREN) ? ccif.iaddr : ccif.daddr;
  // assign ccif.ramREN = (ccif.dREN) ? 1 : ((ccif.dWEN) ? 0 : ((ccif.iREN) ? 1 : 0));
  // assign ccif.ramWEN = (ccif.dREN) ? 0 : ((ccif.dWEN) ? 1 : 0);
  // assign ccif.iwait = !((ccif.ramstate == ACCESS) && !(ccif.dREN || ccif.dWEN) && (ccif.iREN));
  // assign ccif.dwait = !((ccif.ramstate == ACCESS) && (ccif.dREN || ccif.dWEN));

endmodule
