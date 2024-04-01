`include "alu_if.vh"
`timescale 1 ns / 1 ns
import cpu_types_pkg::*;

module alu_tb;
    aluop_t aluop;

    // interface
    alu_if alu ();
    // test program
    test PROG ();

    // DUT
`ifndef MAPPED
  alu DUT(alu);
`else
    alu DUT (
        .\alu.aluop (alu.aluop),
        .\alu.port_a (alu.port_a),
        .\alu.port_b (alu.port_b),
        .\alu.port_out (alu.port_out),
        .\alu.negative (alu.negative),
        .\alu.zero (alu.zero),
        .\alu.overflow (alu.overflow)
    );
`endif
endmodule

program test;
    integer i;
    initial begin
    
    // Testing SLL
    alu_tb.alu.aluop = ALU_SLL;
    alu_tb.alu.port_b = 32'h1;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = i;
        #(5ns)
        if(alu_tb.alu.port_out == alu_tb.alu.port_b << i) begin
            $display("PASSED: SLL Test #%d",i);
        end
        else begin
            $display("FAILED: SLL Test #%d",i);
        end
    end
    
    // Testing SRL
    alu_tb.alu.aluop = ALU_SRL;
    alu_tb.alu.port_b = '1;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = i;
        #(5ns)
        if(alu_tb.alu.port_out == alu_tb.alu.port_b >> i) begin
            $display("PASSED: SRL Test #%d",i);
        end
        else begin 
            $display("FAILED: SRL Test #%d",i);
        end
    end

    // Testing ADD
    alu_tb.alu.aluop = ALU_ADD;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == $signed(alu_tb.alu.port_a) + $signed(alu_tb.alu.port_b)) begin
            $display("PASSED: ADD Test #%d",i);
        end
        else begin 
            $display("FAILED: ADD Test #%d",i);
        end
    end

    // Testing SUB
    alu_tb.alu.aluop = ALU_SUB;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == $signed(alu_tb.alu.port_a) - $signed(alu_tb.alu.port_b)) begin
            $display("PASSED: SUB Test #%d",i);
        end
        else begin
            $display("FAILED: SUB Test #%d",i);
        end
    end

    // Testing AND
    alu_tb.alu.aluop = ALU_AND;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == (alu_tb.alu.port_a & alu_tb.alu.port_b)) begin
            $display("PASSED: AND Test #%d",i);
        end
        else begin
            $display("FAILED: AND Test #%d",i);
        end
    end

    // Testing OR
    alu_tb.alu.aluop = ALU_OR;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == alu_tb.alu.port_a | alu_tb.alu.port_b) begin
            $display("PASSED: OR Test #%d",i);
        end
        else begin
            $display("FAILED: OR Test #%d",i);
        end
    end

    // Testing XOR
    alu_tb.alu.aluop = ALU_XOR;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == alu_tb.alu.port_a ^ alu_tb.alu.port_b) begin
            $display("PASSED: XOR Test #%d",i);
        end
        else begin
            $display("FAILED: XOR Test #%d",i);
        end
    end

    // Testing NOR
    alu_tb.alu.aluop = ALU_NOR;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == ~(alu_tb.alu.port_a | alu_tb.alu.port_b)) begin
            $display("PASSED: NOR Test #%d",i);
        end
        else begin
            $display("FAILED: NOR Test #%d",i);
        end
    end

    // Testing SLT
    alu_tb.alu.aluop = ALU_SLT;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == $signed(alu_tb.alu.port_a) < $signed(alu_tb.alu.port_b)) begin
            $display("PASSED: SLT Test #%d",i);
        end
        else begin 
            $display("FAILED: SLT Test #%d",i);
        end
    end

    // Testing SLTU
    alu_tb.alu.aluop = ALU_SLTU;
    for (i = 0; i < 32; i++) begin
        alu_tb.alu.port_a = $random;
        alu_tb.alu.port_b = $random;
        #(5ns)
        if(alu_tb.alu.port_out == alu_tb.alu.port_a < alu_tb.alu.port_b) begin
            $display("PASSED: SLTU Test #%d",i);
        end
        else begin 
            $display("FAILED: SLTU Test #%d",i);
        end
    end

    // Testing negative flag
    alu_tb.alu.aluop = ALU_SUB;
    alu_tb.alu.port_a = 1;
    alu_tb.alu.port_b = 2;
    #(5ns)
    if(alu_tb.alu.negative) begin
        $display("PASSED: Negative Test");
    end
    else begin
        $display("FAILED: Negative Test");
    end

    // Test zero flag
    alu_tb.alu.aluop = ALU_SUB;
    alu_tb.alu.port_a = 2;
    alu_tb.alu.port_b = 2;
    #(5ns)
    if(alu_tb.alu.zero) begin
        $display("PASSED: Zero Test");
    end
    else begin
        $display("FAILED: Zero Test");
    end

    // Test overflow flag
    alu_tb.alu.aluop = ALU_ADD;
    alu_tb.alu.port_a = 32'b01111111111111111111111111111111;
    alu_tb.alu.port_b = 1;
    #(5ns)
    if(alu_tb.alu.overflow) begin
        $display("PASSED: Overflow (addition) Test");
    end
    else begin
        $display("FAILED: Overflow (addition) Test");
    end

    alu_tb.alu.aluop = ALU_SUB;
    alu_tb.alu.port_a = 32'b01000000000000000000000000000000;
    alu_tb.alu.port_b = 32'b10000000000000000000000000000000;
    #(5ns)
    if(alu_tb.alu.overflow) begin
        $display("PASSED: Overflow (subtraction) Test");
    end
    else begin
        $display("FAILED: Overflow (subtraction) Test");
    end
    end
endprogram