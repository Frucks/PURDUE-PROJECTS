`include "control_unit_if.vh"

`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module control_unit_tb;
    // interface
    control_unit_if cuif ();
    // test program
    test PROG ();
    // DUT
`ifndef MAPPED
    control_unit DUT(cuif);
`else
    control_unit DUT (
        .\cuif.instruction (cuif.instruction),
        .\cuif.ALUsrc (cuif.ALUsrc),
        .\cuif.MemWr (cuif.MemWr),
        .\cuif.MemRead (cuif.MemRead),
        .\cuif.MemtoReg (cuif.MemtoReg),
        .\cuif.RegWr (cuif.RegWr),
        .\cuif.RegDst (cuif.RegDst),
        .\cuif.branch (cuif.branch),
        .\cuif.jumpSrc (cuif.jumpSrc),
        .\cuif.LUI_flag (cuif.LUI_flag),
        .\cuif.ExtOp (cuif.ExtOp),
        .\cuif.aluop (cuif.aluop),
        .\cuif.halt (cuif.halt),
    );
`endif

program test;
    string testname;
    initial begin
        // 000000-00001-00010-00011-00000-100000
        // R[$3] <= R[$1] + R[$2]
        testname = "ADD";
        control_unit_tb.cuif.instruction = 32'h00221820;
        #(10);
        // R[$3] <= R[$1] - R[$2]
        testname = "SUB";
        control_unit_tb.cuif.instruction = 32'h00221822;
        #(10);
        // R[$3] <= R[$1] & R[$2]
        testname = "AND";
        control_unit_tb.cuif.instruction = 32'h00221824;
        #(10);
        // JR
        testname = "JR";
        control_unit_tb.cuif.instruction = 32'h00221808;
        #(10);
        // J
        testname = "J";
        control_unit_tb.cuif.instruction = 32'h08235555;
        #(10);
        // JAL
        testname = "JAL";
        control_unit_tb.cuif.instruction = 32'h0C235555;
        #(10);
        // BEQ
        testname = "BEQ";
        control_unit_tb.cuif.instruction = 32'h10235555;
        #(10);
        // ORI
        testname = "ORI";
        control_unit_tb.cuif.instruction = 32'h3423D555;
        #(10);
        // LUI
        testname = "LUI";
        control_unit_tb.cuif.instruction = 32'h3C235555;
        #(10);
        // LW
        testname = "LW";
        control_unit_tb.cuif.instruction = 32'h8C235555;
        #(10);
        // SW
        testname = "SW";
        control_unit_tb.cuif.instruction = 32'hAC235555;
        #(10);
        $finish;
    end
endprogram


endmodule