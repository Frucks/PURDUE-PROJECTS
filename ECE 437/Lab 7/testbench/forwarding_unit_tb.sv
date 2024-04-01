`include "cpu_types_pkg.vh"
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module forwarding_unit_tb;
  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  forwarding_unit_if fuif ();
  // test program
  test PROG (fuif);
  // DUT
`ifndef MAPPED
  forwarding_unit DUT(fuif);
`else
  forwarding_unit DUT(
    .\fuif.ex_dest (fuif.ex_dest),
    .\fuif.mem_dest (fuif.mem_dest),
    .\fuif.id_rs (fuif.id_rs),
    .\fuif.id_rt (fuif.id_rt),
    .\fuif.ex_regWrite (fuif.ex_regWrite),
    .\fuif.mem_regWrite (fuif.mem_regWrite),
    .\fuif.if_rs (fuif.if_rs)
    .\fuif.if_rt (fuif.if_rt)
    .\fuif.jumpSrc (fuif.jumpSrc)
    .\fuif.id_RegWr (fuif.id_RegWr)
    .\fuif.id_dest (fuif.id_dest)
    .\fuif.forwardA (fuif.forwardA)
    .\fuif.forwardB (fuif.forwardB)
    .\fuif.forwardJR (fuif.forwardJR)
  );
`endif

endmodule

program test
import cpu_types_pkg::*;
(
    forwarding_unit_if fuif
);
parameter PERIOD = 10;
int test_num = 0;
string test_name;
initial begin
    //SET ALL INPUTS TO 0
    fuif.ex_dest = 0;
    fuif.mem_dest = 0;
    fuif.id_rs = 0;
    fuif.id_rt = 0;
    fuif.ex_regWrite = 0;
    fuif.mem_regWrite = 0;

    //TEST forwardA = 2'b00
    test_name = "forwardA = 2'b00";
    test_num++;
    $display("\nTest Case %0d: %s", test_num, test_name);
    #(PERIOD)
    assert (fuif.forwardA == 2'b00) $display("forwardA SUCCESS set to %0d at time %0d", fuif.forwardA, $time);
        else   $error("forwardA FAIL set to %0d at time %0d", fuif.forwardA, $time);

    //TEST forwardA = 2'b10
    test_name = "forwardA = 2'b10";
    test_num++;
    $display("\nTest Case %0d: %s", test_num, test_name);
    fuif.ex_regWrite = 1;
    fuif.ex_dest = 'd5;
    fuif.id_rs = 'd5;
    #(PERIOD)
    assert (fuif.forwardA == 2'b10) $display("forwardA SUCCESS set to %0d at time %0d", fuif.forwardA, $time);
        else   $error("forwardA FAIL set to %0d at time %0d", fuif.forwardA, $time);
    
    //TEST forwardA = 2'b01
    test_name = "forwardA = 2'b01";
    test_num++;
    $display("\nTest Case %0d: %s", test_num, test_name);
    fuif.ex_regWrite = 0;
    fuif.ex_dest = 0;
    fuif.mem_regWrite = 1;
    fuif.mem_dest = 'd5;
    fuif.id_rs = 'd5;
    #(PERIOD)
    assert (fuif.forwardA == 2'b01) $display("forwardA SUCCESS set to %0d at time %0d", fuif.forwardA, $time);
        else   $error("forwardA FAIL set to %0d at time %0d", fuif.forwardA, $time);

    //TEST forwardB = 2'b00
    test_name = "forwardB = 2'b00";
    test_num++;
    fuif.mem_regWrite = 0;
    fuif.mem_dest = 0;
    fuif.id_rs = 0;
    $display("\nTest Case %0d: %s", test_num, test_name);
    #(PERIOD)
    assert (fuif.forwardB == 2'b00) $display("forwardB SUCCESS set to %0d at time %0d", fuif.forwardB, $time);
        else   $error("forwardB FAIL set to %0d at time %0d", fuif.forwardB, $time);

    //TEST forwardB = 2'b10
    test_name = "forwardB = 2'b10";
    test_num++;
    $display("\nTest Case %0d: %s", test_num, test_name);
    fuif.ex_regWrite = 1;
    fuif.ex_dest = 'd5;
    fuif.id_rt = 'd5;
    #(PERIOD)
    assert (fuif.forwardB == 2'b10) $display("forwardB SUCCESS set to %0d at time %0d", fuif.forwardB, $time);
        else   $error("forwardB FAIL set to %0d at time %0d", fuif.forwardB, $time);
    
    //TEST forwardB = 2'b01
    test_name = "forwardB = 2'b01";
    test_num++;
    $display("\nTest Case %0d: %s", test_num, test_name);
    fuif.ex_regWrite = 0;
    fuif.ex_dest = 0;
    fuif.mem_regWrite = 1;
    fuif.mem_dest = 'd5;
    fuif.id_rt = 'd5;
    #(PERIOD)
    assert (fuif.forwardB == 2'b01) $display("forwardB SUCCESS set to %0d at time %0d", fuif.forwardB, $time);
        else   $error("forwardB FAIL set to %0d at time %0d", fuif.forwardB, $time);

end
endprogram