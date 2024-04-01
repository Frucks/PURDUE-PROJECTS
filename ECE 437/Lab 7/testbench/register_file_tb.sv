/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test;
  initial begin
  // initialization 
  register_file_tb.rfif.WEN = 0;
  register_file_tb.rfif.wdat = 0;
  register_file_tb.rfif.wsel = '0;
  register_file_tb.rfif.rsel1 = '0;
  register_file_tb.rfif.rsel2 = '0;

  // Asynchronous Reset
  register_file_tb.nRST = 0;
  #(register_file_tb.PERIOD * 5);
  register_file_tb.nRST = 1;
  #(register_file_tb.PERIOD);

  // Writes to register 0
  register_file_tb.rfif.WEN = 1;
	register_file_tb.rfif.wdat = 32'b10101010101010101010101010101010;
	register_file_tb.rfif.wsel = '0;
	register_file_tb.rfif.rsel1 = '0;
	register_file_tb.rfif.rsel2 = '0;

  #(register_file_tb.PERIOD * 2);

  if (register_file_tb.rfif.rdat1 == '0 && register_file_tb.rfif.rdat2 == '0) 
	     $display("PASSED: Register 0 Write");
	else $error("FAILED: Register 0 Write");

  // Normal Reads and Writes
  #(register_file_tb.PERIOD * 2);
  register_file_tb.rfif.WEN = 0; // sets things apart
  
  // v1
  #(register_file_tb.PERIOD);

  register_file_tb.rfif.WEN = 1;
	register_file_tb.rfif.wdat = register_file_tb.v1;
	register_file_tb.rfif.wsel = 32'd5;
	register_file_tb.rfif.rsel1 = 32'd5;
	register_file_tb.rfif.rsel2 = 32'd5;

  #(register_file_tb.PERIOD);

  if (register_file_tb.rfif.rdat1 == register_file_tb.rfif.wdat && register_file_tb.rfif.rdat2 == register_file_tb.rfif.wdat) begin
	  $display("PASSED for v1");
  end
	else begin
    $error("FAILED for v1");
  end

  // v2
  #(register_file_tb.PERIOD);

  register_file_tb.rfif.WEN = 1;
	register_file_tb.rfif.wdat = register_file_tb.v2;
	register_file_tb.rfif.wsel = 32'd10;
	register_file_tb.rfif.rsel1 = 32'd10;
	register_file_tb.rfif.rsel2 = 32'd10;

  #(register_file_tb.PERIOD);

  if (register_file_tb.rfif.rdat1 == register_file_tb.rfif.wdat && register_file_tb.rfif.rdat2 == register_file_tb.rfif.wdat) begin
	  $display("PASSED for v2");
  end
	else begin
    $error("FAILED for v2");
  end

  // v3
  #(register_file_tb.PERIOD);

  register_file_tb.rfif.WEN = 1;
	register_file_tb.rfif.wdat = register_file_tb.v3;
	register_file_tb.rfif.wsel = 32'd15;
	register_file_tb.rfif.rsel1 = 32'd15;
	register_file_tb.rfif.rsel2 = 32'd15;

  #(register_file_tb.PERIOD);

  if (register_file_tb.rfif.rdat1 == register_file_tb.rfif.wdat && register_file_tb.rfif.rdat2 == register_file_tb.rfif.wdat) begin
	  $display("PASSED for v3");
  end
	else begin
    $error("FAILED for v3");
  end

  end

endprogram
