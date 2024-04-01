`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;

  // interface delcaration
  hazard_unit_if huif ();
// test program setup
  test PROG ();

`ifndef MAPPED
  hazard_unit DUT(huif);
`else
  hazard_unit DUT(
    .\huif.ex_dest (huif.ex_dest),
    .\huif.mem_dest (huif.mem_dest),
    .\huif.id_rs (huif.id_rs),
    .\huif.id_rt (huif.id_rt),
    .\huif.ex_regWrite (huif.ex_regWrite),
    .\huif.mem_regWrite (huif.mem_regWrite),
    .\huif.id_memRead (huif.id_memRead),
    .\huif.PCsrc (huif.PCsrc),
    .\huif.if_rs (huif.if_rs),
    .\huif.if_rt (huif.if_rt),
    .\huif.stall (huif.stall),
    .\huif.flush (huif.flush),
    .\huif.forwardA (huif.forwardA),
    .\huif.forwardB (huif.forwardB)
  );
`endif

endmodule

program test;

    import cpu_types_pkg::*;
    parameter PERIOD = 10;
    initial begin

        // Initialization
        hazard_unit_tb.huif.ex_dest = '0;
        hazard_unit_tb.huif.mem_dest = '0;
        hazard_unit_tb.huif.id_rs = '0;
        hazard_unit_tb.huif.id_rt = '0;
        hazard_unit_tb.huif.ex_regWrite = 0;
        hazard_unit_tb.huif.mem_regWrite = 0;
        hazard_unit_tb.huif.id_memRead = 0;
        hazard_unit_tb.huif.PCsrc = 0;
        hazard_unit_tb.huif.if_rs = '0;
        hazard_unit_tb.huif.if_rt = '0;
        #(5 * PERIOD)

        // No Jumps or Branches (flush == 0)
        hazard_unit_tb.huif.PCsrc = 0;
        #(PERIOD)

        if(hazard_unit_tb.huif.flush == 0 && hazard_unit_tb.huif.stall == 0) begin
            $display("Passed: No Jumps or Branches");
        end else begin
            $display("Failed: No Jumps or Branches");
        end

        #(2 * PERIOD)

        // Jumps or Branches (flush == 1)
        hazard_unit_tb.huif.PCsrc = 1;
        #(PERIOD)

        if(hazard_unit_tb.huif.flush == 1 && hazard_unit_tb.huif.stall == 0) begin
            $display("Passed Jumps or Branches");
        end else begin
            $display("Failed Jumps or Branches");
        end

        #(2 * PERIOD)
        
        // Stalls 1
        hazard_unit_tb.huif.PCsrc = 0;
        hazard_unit_tb.huif.id_memRead = 1;
        hazard_unit_tb.huif.id_rt = 5'b10101;
        hazard_unit_tb.huif.if_rs = 5'b10101;
        hazard_unit_tb.huif.if_rt = '0;

        #(PERIOD)

        if(hazard_unit_tb.huif.flush == 0 && hazard_unit_tb.huif.stall == 1) begin
            $display("Passed Stalls 1");
        end else begin
            $display("Failed Stalls 1");
        end

        // Stalls 2
        hazard_unit_tb.huif.PCsrc = 0;
        hazard_unit_tb.huif.id_memRead = 1;
        hazard_unit_tb.huif.id_rt = 5'b10101;
        hazard_unit_tb.huif.if_rs = '0;
        hazard_unit_tb.huif.if_rt = 5'b10101;

        #(PERIOD)

        if(hazard_unit_tb.huif.flush == 0 && hazard_unit_tb.huif.stall == 1) begin
            $display("Passed Stalls 2");
        end else begin
            $display("Failed Stalls 2");
        end
    end
endprogram