`include "MEM_WB_if.vh"
`include "cpu_types_pkg.vh"

module MEM_WB (
	input logic CLK, nRST, 
	MEM_WB_if.memwb memif
);

	import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST) begin
        if(~nRST) begin
            memif.instruction_out <= '0;
            memif.dest_reg_out <= '0;
            memif.next_PC_out <= '0;
            memif.port_out_out <= '0;
            memif.dmemload_out <= '0;
            memif.RegWr_out <= 0;
            memif.halt_out <= 0;
            memif.MemtoReg_out <= '0;
        end else if(memif.MEM_WB_en) begin
            memif.instruction_out <= memif.instruction_in;
            memif.dest_reg_out <= memif.dest_reg_in;
            memif.next_PC_out <= memif.next_PC_in;
            memif.port_out_out <= memif.port_out_in;
            memif.dmemload_out <= memif.dmemload_in;
            memif.RegWr_out <= memif.RegWr_in;
            memif.halt_out <= memif.halt_in;
            memif.MemtoReg_out <= memif.MemtoReg_in;
        end
    end

endmodule
