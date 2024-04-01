`include "cpu_types_pkg.vh"
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.negative (aluif.negative),
    .\aluif.overflow (aluif.overflow),
    .\aluif.zero (aluif.zero),
    .\aluif.aluop (aluif.aluop),
    .\aluif.port_a (aluif.port_a),
    .\aluif.port_b (aluif.port_b),
    .\aluif.port_out (aluif.port_out)
  );
`endif

endmodule

program test;
import cpu_types_pkg::*;
parameter PERIOD = 10;
initial begin

    //TEST SLL
    aluif.port_a = 'b100010; //2
    aluif.port_b = 'd5; //101
    aluif.aluop = ALU_SLL;
    #(PERIOD)
    assert (aluif.port_out == 'd20) $display("Success SLL"); //10100
        else   $error("Failure SLL");
    
    //TEST SRL
    aluif.port_a = 'b100010; //2
    aluif.port_b = 'd20; //10100
    aluif.aluop = ALU_SRL;
    #(PERIOD)
    assert (aluif.port_out == 'd5) $display("Success SRL"); //101
        else   $error("Failure SRL");

    //TEST ADD 2 POS
    aluif.port_a = 6;
    aluif.port_b = 7;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.port_out == 'd13) $display("Success ADD 2 POS");
        else   $error("Failure ADD 2 POS");

    //TEST ADD 1 POS 1 NEG, NEG RESULT
    aluif.port_a = 6;
    aluif.port_b = -7;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.port_out == -1) $display("Success ADD 1 POS 1 NEG, NEG RESULT");
        else   $error("Failure ADD 1 POS 1 NEG, NEG RESULT");
    
    //TEST ADD 1 POS 1 NEG, POS RESULT
    aluif.port_a = -6;
    aluif.port_b = 7;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success ADD 1 POS 1 NEG, POS RESULT");
        else   $error("Failure ADD 1 POS 1 NEG, POS RESULT");

    //TEST ADD 2 NEG
    aluif.port_a = -6;
    aluif.port_b = -7;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.port_out == -13) $display("Success ADD 2 NEG");
        else   $error("Failure ADD 2 NEG");

    //TEST SUB 2 POS, NEG RESULT
    aluif.port_a = 6;
    aluif.port_b = 7;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.port_out == -1) $display("Success SUB 2 POS, NEG RESULT");
        else   $error("Failure SUB 2 POS, NEG RESULT");

    //TEST SUB 2 POS, POS RESULT
    aluif.port_a = 7;
    aluif.port_b = 6;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SUB 2 POS, POS RESULT");
        else   $error("Failure SUB 2 POS, POS RESULT");

    //TEST SUB 1 POS 1 NEG, NEG RESULT
    aluif.port_a = -6;
    aluif.port_b = 7;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.port_out == -13) $display("Success SUB 1 POS 1 NEG, NEG RESULT");
        else   $error("Failure SUB 1 POS 1 NEG, NEG RESULT");
    
    //TEST SUB 1 POS 1 NEG, POS RESULT
    aluif.port_a = 6;
    aluif.port_b = -7;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.port_out == 13) $display("Success SUB 1 POS 1 NEG, POS RESULT");
        else   $error("Failure SUB 1 POS 1 NEG, POS RESULT");

    //TEST SUB 2 NEG, POS RESULT
    aluif.port_a = -6;
    aluif.port_b = -7;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SUB 2 NEG, POS RESULT");
        else   $error("Failure SUB 2 NEG, POS RESULT");

    //TEST SUB 2 NEG, NEG RESULT
    aluif.port_a = -7;
    aluif.port_b = -6;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.port_out == -1) $display("Success SUB 2 NEG, NEG RESULT");
        else   $error("Failure SUB 2 NEG, NEG RESULT");

    //TEST AND
    aluif.port_a = 'b1101001;
    aluif.port_b = 'b0101110;
    aluif.aluop = ALU_AND;
    #(PERIOD)
    assert (aluif.port_out == 'b0101000) $display("Success AND");
        else   $error("Failure AND");

    //TEST OR
    aluif.port_a = 'b1101001;
    aluif.port_b = 'b0101110;
    aluif.aluop = ALU_OR;
    #(PERIOD)
    assert (aluif.port_out == 'b1101111) $display("Success OR");
        else   $error("Failure OR");

    //TEST XOR
    aluif.port_a = 'b1101001;
    aluif.port_b = 'b0101110;
    aluif.aluop = ALU_XOR;
    #(PERIOD)
    assert (aluif.port_out == 'b1000111) $display("Success XOR");
        else   $error("Failure XOR");

    //TEST NOR
    aluif.port_a = -23; //'b1101001
    aluif.port_b = 'b0101110;
    aluif.aluop = ALU_NOR;
    #(PERIOD)
    assert (aluif.port_out == 'b0010000) $display("Success NOR");
        else   $error("Failure NOR");

    //TEST SLT 2 POS
    aluif.port_a = 6;
    aluif.port_b = 7;
    aluif.aluop = ALU_SLT;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SLT 2 POS = 1");
        else   $error("Failure SLT 2 POS = 1");

    aluif.port_a = 7;
    aluif.port_b = 6;
    aluif.aluop = ALU_SLT;
    #(PERIOD)
    assert (aluif.port_out == 0) $display("Success SLT 2 POS = 0");
        else   $error("Failure SLT 2 POS = 0");

    //TEST SLT 1 POS 1 NEG
    aluif.port_a = -6;
    aluif.port_b = 7;
    aluif.aluop = ALU_SLT;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SLT 1 POS 1 NEG = 1");
        else   $error("Failure SLT 1 POS 1 NEG = 1");

    aluif.port_a = 6;
    aluif.port_b = -7;
    aluif.aluop = ALU_SLT;
    #(PERIOD)
    assert (aluif.port_out == 0) $display("Success SLT 1 POS 1 NEG = 0");
        else   $error("Failure SLT 1 POS 1 NEG = 0");

    //TEST SLT 2 NEG
    aluif.port_a = -7;
    aluif.port_b = -6;
    aluif.aluop = ALU_SLT;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SLT 2 NEG = 1");
        else   $error("Failure SLT 2 NEG = 1");

    aluif.port_a = -6;
    aluif.port_b = -7;
    aluif.aluop = ALU_SLT;
    #(PERIOD)
    assert (aluif.port_out == 0) $display("Success SLT 2 NEG = 0");
        else   $error("Failure SLT 2 NEG = 0");

    //TEST SLTU 2 POS
    aluif.port_a = 'b0110;
    aluif.port_b = 'b0111;
    aluif.aluop = ALU_SLTU;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SLTU 2 POS = 1");
        else   $error("Failure SLTU 2 POS = 1");

    aluif.port_a = 'b0111;
    aluif.port_b = 'b0110;
    aluif.aluop = ALU_SLTU;
    #(PERIOD)
    assert (aluif.port_out == 0) $display("Success SLTU 2 POS = 0");
        else   $error("Failure SLTU 2 POS = 0");

    //TEST SLTU 1 POS 1 NEG
    aluif.port_a = 'b0110; //6
    aluif.port_b = 'b1111; //-1 signed, 15 unsigned
    aluif.aluop = ALU_SLTU;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SLTU 1 POS 1 NEG = 1");
        else   $error("Failure SLTU 1 POS 1 NEG = 1");

    aluif.port_a = 'b1111; //-1 signed, 15 unsigned
    aluif.port_b = 'b0110; //6
    aluif.aluop = ALU_SLTU;
    #(PERIOD)
    assert (aluif.port_out == 0) $display("Success SLTU 1 POS 1 NEG = 0");
        else   $error("Failure SLTU 1 POS 1 NEG = 0");

    //TEST SLTU 2 NEG
    aluif.port_a = 'b1110; //-2 signed, 14 unsigned
    aluif.port_b = 'b1111; //-1 signed, 15 unsigned
    aluif.aluop = ALU_SLTU;
    #(PERIOD)
    assert (aluif.port_out == 1) $display("Success SLTU 2 NEG = 1");
        else   $error("Failure SLTU 2 NEG = 1");

    aluif.port_a = 'b1111; //-1 signed, 15 unsigned
    aluif.port_b = 'b1110; //-2 signed, 14 unsigned
    aluif.aluop = ALU_SLTU;
    #(PERIOD)
    assert (aluif.port_out == 0) $display("Success SLTU 2 NEG = 0");
        else   $error("Failure SLTU 2 NEG = 0");

    //TEST ZERO FLAG
    aluif.port_a = 1;
    aluif.port_b = -1;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.zero == 1) $display("Success ZERO = 1");
        else   $error("Failure ZERO = 1");

    aluif.port_a = 2;
    aluif.port_b = -1;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.zero == 0) $display("Success ZERO = 0");
        else   $error("Failure ZERO = 0");

    //TEST OVERFLOW ADD
    aluif.port_a = 2147483647;
    aluif.port_b = 2;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.overflow == 1) $display("Success OVERFLOW ADD = 1");
        else   $error("Failure OVERFLOW ADD = 1");

    aluif.port_a = 2;
    aluif.port_b = -1;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.overflow == 0) $display("Success OVERFLOW ADD = 0");
        else   $error("Failure OVERFLOW ADD = 0");

    //TEST OVERFLOW SUB
    aluif.port_a = -2147483648;
    aluif.port_b = 2;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.overflow == 1) $display("Success OVERFLOW SUB = 1");
        else   $error("Failure OVERFLOW SUB = 1");

    aluif.port_a = 2;
    aluif.port_b = -1;
    aluif.aluop = ALU_SUB;
    #(PERIOD)
    assert (aluif.overflow == 0) $display("Success OVERFLOW SUB = 0");
        else   $error("Failure OVERFLOW SUB = 0");

    //TEST NEGATIVE FLAG
    aluif.port_a = 1;
    aluif.port_b = -2;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.negative == 1) $display("Success NEGATIVE = 1");
        else   $error("Failure NEGATIVE = 1");

    aluif.port_a = 2;
    aluif.port_b = -1;
    aluif.aluop = ALU_ADD;
    #(PERIOD)
    assert (aluif.negative == 0) $display("Success NEGATIVE = 0");
        else   $error("Failure NEGATIVE = 0");

end
endprogram