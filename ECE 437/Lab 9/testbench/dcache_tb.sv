`include "cpu_types_pkg.vh"
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  datapath_cache_if dcif ();
  caches_if cif0();

  // test program
  test PROG ();

`ifndef MAPPED
  dcache DUT(CLK, nRST, dcif, cif0);
`else
  dcache DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\dcif.halt (dcif.halt),
    .\dcif.dmemREN (dcif.dmemREN),
    .\dcif.dmemWEN (dcif.dmemWEN),
    .\dcif.datomic (dcif.datomic),
    .\dcif.dmemstore (dcif.dmemstore),
    .\dcif.dmemaddr (dcif.dmemaddr),
    .\dcif.dhit (dcif.dhit)
    .\dcif.dmemload (dcif.dmemload)
    .\dcif.flushed (dcif.flushed)
    .\cif0.dwait (cif0.dwait)
    .\cif0.dload (cif0.dload)
    .\cif0.dREN (cif0.dREN)
    .\cif0.dWEN (cif0.dWEN)
    .\cif0.daddr (cif0.daddr)
    .\cif0.dstore (cif0.dstore)
  );
`endif
    
endmodule

program test;
import cpu_types_pkg::*;
parameter PERIOD = 10;
int test_num = 0;
string test_name;
word_t addr, data;

initial begin
  //SET ALL INPUTS TO 0
  dcif.halt = 0;
  dcif.dmemREN = 0;
  dcif.dmemWEN = 0;
  dcif.datomic = 0;
  dcif.dmemstore = '0;
  dcif.dmemaddr = '0;
  cif0.dwait = 1;
  cif0.dload = '0;

  test_name = "ASYNCHRONOUS RESET";
  dcache_tb.nRST = 0;
  #(5);
  dcache_tb.nRST = 1;
  
  // TEST 1: READ MISS (BLOCK 0)
  test_name = "READ MISS (BLOCK 0)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  data = 'd7;
  addr = {26'd3, 3'd0, 1'd0, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  dcif.dmemREN = 1;
  dcif.dmemaddr = addr;
  assert (dcif.dhit == 0) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD)
  //ALLOCATE BLOCK 0
  assert (cif0.dREN == 1) $display("dREN SUCCESS set to %0d at time %0d", cif0.dREN, $time);
    else   $display("dREN FAIL set to %0d at time %0d", cif0.dREN, $time);
  assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dload = data;
  cif0.dwait = 0;
  #(PERIOD)
  //ALLOCATE BLOCK 1
  assert (cif0.dREN == 1) $display("dREN SUCCESS set to %0d at time %0d", cif0.dREN, $time);
    else   $display("dREN FAIL set to %0d at time %0d", cif0.dREN, $time);
  assert (cif0.daddr == {26'd3, 3'd0, 1'd1, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dload = data + 1;
  cif0.dwait = 0;
  #(PERIOD)
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  assert (dcif.dmemload == data) $display("dmemload SUCCESS set to %0d at time %0d", dcif.dmemload, $time);
    else   $display("dmemload FAIL set to %0d at time %0d", dcif.dmemload, $time);
  //RESET INPUTS
  dcif.dmemREN = 0;
  dcif.dmemaddr = 0;
  // #(PERIOD)
  

  // TEST 2: READ HIT (BLOCK 0)
  test_name = "READ HIT (BLOCK 0)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  //ADDR AND DATA
  data = 'd7;
  addr = {26'd3, 3'd0, 1'd0, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  dcif.dmemREN = 1;
  dcif.dmemaddr = addr;
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  assert (dcif.dmemload == data) $display("dmemload SUCCESS set to %0d at time %0d", dcif.dmemload, $time);
    else   $display("dmemload FAIL set to %0d at time %0d", dcif.dmemload, $time);
  #(PERIOD)
  //RESET INPUTS
  dcif.dmemREN = 0;
  dcif.dmemaddr = 0;
  #(PERIOD)
  
  //TEST 3: READ MISS (BLOCK 1)
  test_name = "READ MISS (BLOCK 1)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  // #(PERIOD)
  //ADDR AND DATA
  data = 'd8;
  addr = {26'd4, 3'd0, 1'd1, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  dcif.dmemREN = 1;
  dcif.dmemaddr = addr;
  assert (dcif.dhit == 0) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD)
  //ALLOCATE BLOCK 0
  assert (cif0.dREN == 1) $display("dREN SUCCESS set to %0d at time %0d", cif0.dREN, $time);
    else   $display("dREN FAIL set to %0d at time %0d", cif0.dREN, $time);
  assert (cif0.daddr == {26'd4, 3'd0, 1'd0, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dload = data;
  cif0.dwait = 0;
  #(PERIOD)
  //ALLOCATE BLOCK 1
  assert (cif0.dREN == 1) $display("dREN SUCCESS set to %0d at time %0d", cif0.dREN, $time);
    else   $display("dREN FAIL set to %0d at time %0d", cif0.dREN, $time);
  assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dload = data + 1;
  cif0.dwait = 0;
  #(PERIOD)
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  assert (dcif.dmemload == data + 1) $display("dmemload SUCCESS set to %0d at time %0d", dcif.dmemload, $time);
    else   $display("dmemload FAIL set to %0d at time %0d", dcif.dmemload, $time);

  // TEST 4:READ HIT (BLOCK 1)
  test_name = "READ HIT (BLOCK 1)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  //INPUTS
  data = 'd9;
  addr = {26'd4, 3'd2, 1'd0, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  dcif.dmemREN = 1;
  dcif.dmemaddr = addr;
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  assert (dcif.dmemload == data) $display("dmemload SUCCESS set to %0d at time %0d", dcif.dmemload, $time);
    else   $display("dmemload FAIL set to %0d at time %0d", dcif.dmemload, $time);
  //RESET INPUTS
  dcif.dmemREN = 0;
  dcif.dmemaddr = 0;
  #(PERIOD)

  // TEST 5: WRITE MISS (BLOCK 0)
  test_name = "WRITE MISS (BLOCK 0)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  dcif.dmemaddr = {26'd6, 3'd1, 1'd0, 2'd0};
  data = 'd10;
  //COMPARE
  cif0.dload = data;
  dcif.dmemWEN = 1;
  dcif.dmemstore = data;
  assert (dcif.dhit == 0) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD)
  // WB 1
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == data) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  // WB 2
  // dcif.dmemstore = data + 1;
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == {26'd5, 3'd1, 1'd1, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dwait = 0;
  //COMPARE
  // assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
  //   else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  //RESET INPUTS
  #(PERIOD * 3)
  dcif.dmemWEN = 0;
  // dcif.dmemaddr = 0;
  // dcif.dmemstore = 0;
  #(PERIOD)

  // TEST 6: WRITE HIT BLOCK 0
  test_name = "WRITE HIT (BLOCK 0)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  // #(PERIOD)
  //ADDR AND DATA
  data = 'd12;
  addr = {26'd6, 3'd1, 1'd0, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  cif0.dload = data;
  dcif.dmemWEN = 1;
  dcif.dmemaddr = addr;
  dcif.dmemstore = data;
  
  #(PERIOD/2)
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD/2)
  //WRITE BACK 0
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == data) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //WRITE BACK 1
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == {26'd5, 3'd1, 1'd1, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //COMPARE
  // assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
  //   else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  //RESET INPUTS
  #(PERIOD * 3)
  dcif.dmemWEN = 0;
  dcif.dmemaddr = 0;
  dcif.dmemstore = 0;
  #(PERIOD * 2)

  // TEST 7: WRITE MISS (BLOCK 1)
  test_name = "WRITE MISS (BLOCK 1)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  dcif.dmemaddr = {26'd7, 3'd1, 1'd1, 2'd0};
  data = 'd14;
  //COMPARE
  cif0.dload = data;
  dcif.dmemWEN = 1;
  dcif.dmemstore = data;
  assert (dcif.dhit == 0) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD)
  // WB 1
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  #(PERIOD)
  assert (cif0.dstore == data) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  // WB 2
  // dcif.dmemstore = data + 1;
  assert (cif0.dWEN == 0) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == {26'd5, 3'd1, 1'd1, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dwait = 0;
  //COMPARE
  // assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
  //   else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  //RESET INPUTS
  #(PERIOD * 2)
  dcif.dmemWEN = 0;
  dcif.dmemaddr = 0;
  dcif.dmemstore = 0;
  // #(PERIOD * 2)

  // TEST 8: WRITE HIT BLOCK 1
  test_name = "WRITE HIT (BLOCK 1)";
  test_num++;
  // #(PERIOD * 2)
  $display("\nTest Case %0d: %s", test_num, test_name);
  // #(PERIOD)
  //ADDR AND DATA
  data = 'd15;
  addr = {26'd7, 3'd1, 1'd1, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  dcif.dmemWEN = 1;
  dcif.dmemaddr = addr;
  dcif.dmemstore = data;
  #(PERIOD/2)
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD/2)
  //WRITE BACK 0
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == {26'd5, 3'd1, 1'd0, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == 'd12) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //WRITE BACK 1
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  // assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
  //   else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == 'd10) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  //RESET INPUTS
  #(PERIOD * 2)
  dcif.dmemWEN = 0;
  dcif.dmemaddr = 0;
  dcif.dmemstore = 0;

  // TEST 9: WRITE BOTH BLOCKS (BLOCK 0)
  test_name = "WRITE BOTH BLOCKS (BLOCK 0)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  data = 'd2;
  addr = {26'd19, 3'd5, 1'd0, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  dcif.dmemWEN = 1;
  dcif.dmemaddr = addr;
  dcif.dmemstore = data;
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD)
  //WRITE BACK 0
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == data) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //WRITE BACK 1
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  assert (cif0.daddr == {26'd19, 3'd5, 1'd1, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //COMPARE
  // assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
  //   else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  //RESET INPUTS
  dcif.dmemWEN = 0;
  dcif.dmemaddr = 0;
  dcif.dmemstore = 0;

  // TEST 10: WRITE BOTH BLOCKS (BLOCK 1)
  test_name = "WRITE BOTH BLOCKS (BLOCK 1)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  data = 'd16;
  addr = {26'd19, 3'd5, 1'd1, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  dcif.dmemWEN = 1;
  dcif.dmemaddr = addr;
  dcif.dmemstore = data;
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  #(PERIOD)
  //WRITE BACK 0
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  assert (cif0.daddr == {26'd19, 3'd5, 1'd0, 2'd0}) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == 'd2) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //WRITE BACK 1
  assert (cif0.dWEN == 1) $display("dWEN SUCCESS set to %0d at time %0d", cif0.dWEN, $time);
    else   $display("dWEN FAIL set to %0d at time %0d", cif0.dWEN, $time);
  assert (cif0.daddr == addr) $display("daddr SUCCESS set to %0d at time %0d", cif0.daddr, $time);
    else   $display("daddr FAIL set to %0d at time %0d", cif0.daddr, $time);
  assert (cif0.dstore == data) $display("dstore SUCCESS set to %0d at time %0d", cif0.dstore, $time);
    else   $display("dstore FAIL set to %0d at time %0d", cif0.dstore, $time);
  cif0.dwait = 0;
  #(PERIOD)
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  //RESET INPUTS
  dcif.dmemWEN = 0;
  dcif.dmemaddr = 0;
  dcif.dmemstore = 0;

  // TEST 11: READ BOTH BLOCKS (BLOCK 0)
  test_name = "READ HIT (BLOCK 0)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  data = 'd2;
  addr = {26'd19, 3'd5, 1'd0, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  dcif.dmemREN = 1;
  dcif.dmemaddr = addr;
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  assert (dcif.dmemload == data) $display("dmemload SUCCESS set to %0d at time %0d", dcif.dmemload, $time);
    else   $display("dmemload FAIL set to %0d at time %0d", dcif.dmemload, $time);
  //RESET INPUTS
  dcif.dmemREN = 0;
  dcif.dmemaddr = 0;


  // TEST 12: READ BOTH BLOCKS (BLOCK 1)
  #(PERIOD * 10)
  test_name = "READ BOTH BLOCKS (BLOCK 1)";
  test_num++;
  $display("\nTest Case %0d: %s", test_num, test_name);
  #(PERIOD)
  //ADDR AND DATA
  data = 'd16;
  addr = {26'd19, 3'd5, 1'd1, 2'd0}; //{TAG, INDEX, BLOCK OFFSET, BYTE OFFSET}
  //COMPARE
  assert (dcif.dhit == 1) $display("dhit SUCCESS set to %0d at time %0d", dcif.dhit, $time);
    else   $display("dhit FAIL set to %0d at time %0d", dcif.dhit, $time);
  assert (dcif.dmemload == data) $display("dmemload SUCCESS set to %0d at time %0d", dcif.dmemload, $time);
    else   $display("dmemload FAIL set to %0d at time %0d", dcif.dmemload, $time);
  //RESET INPUTS
  dcif.dmemREN = 0;
  dcif.dmemaddr = 0;

// TEST 13: FLUSH
test_name = "FLUSH";
test_num++;
$display("\nTest Case %0d: %s", test_num, test_name);
#(PERIOD)
//ADDR AND DATA
dcif.halt = 1;
#(PERIOD * 30)

assert (dcif.flushed == 1) $display("flushed SUCCESS set to %0d at time %0d", dcif.flushed, $time);
  else   $display("flushed FAIL set to %0d at time %0d", dcif.flushed, $time);
end

endprogram