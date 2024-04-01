`include "EX_MEM_if.vh"
`include "cpu_types_pkg.vh"

module EX_MEM (
	input logic CLK, nRST, 
	EX_MEM_if.exmem exif
);

	import cpu_types_pkg::*;
    logic dhitLatch;

    always_ff @(posedge CLK, negedge nRST) begin
        if(~nRST) begin
            exif.instruction_out <= '0;
            exif.sign_extended_out <= '0;
            exif.dest_reg_out <= '0;
            exif.next_PC_out <= '0;
            exif.rdat2_out <= '0;
            exif.zero_out <= '0;
            exif.port_out_out <= '0;
            exif.MemWr_out <= 0;
            exif.MemRead_out <= 0;
            exif.RegWr_out <= 0;
            exif.MemtoReg_out <= '0;
            exif.halt_out <= 0;
            exif.jumpR_out <= 0;
            exif.taken_out <= 0;
            dhitLatch <= 0;
        end else if(exif.flush) begin 
            exif.instruction_out <= '0;
            exif.sign_extended_out <= '0;
            exif.dest_reg_out <= '0;
            exif.next_PC_out <= '0;
            exif.rdat2_out <= '0;
            exif.zero_out <= '0;
            exif.port_out_out <= '0;
            exif.MemWr_out <= 0;
            exif.MemRead_out <= 0;
            exif.RegWr_out <= 0;
            exif.MemtoReg_out <= '0;
            exif.halt_out <= 0;
            exif.jumpR_out <= 0;
            exif.taken_out <= 0;
            dhitLatch <= 0;
        end
        else if(exif.EX_MEM_en) begin
            if ((exif.instruction_out == exif.instruction_in) && (dhitLatch || exif.dhit)) begin
                exif.MemWr_out <= 0;
                exif.MemRead_out <= 0;
                dhitLatch <= 1;
            end
            else if (exif.next_PC_out != exif.next_PC_in) begin
                exif.instruction_out <= exif.instruction_in;
                exif.sign_extended_out <= exif.sign_extended_in;
                exif.dest_reg_out <= exif.dest_reg_in;
                exif.next_PC_out <= exif.next_PC_in;
                exif.rdat2_out <= exif.rdat2_in;
                exif.zero_out <= exif.zero_in;
                exif.port_out_out <= exif.port_out_in;
                exif.MemWr_out <= exif.MemWr_in;
                exif.MemRead_out <= exif.MemRead_in;
                exif.RegWr_out <= exif.RegWr_in;
                exif.MemtoReg_out <= exif.MemtoReg_in;
                exif.halt_out <= exif.halt_in;
                exif.jumpR_out <= exif.jumpR_in;
                exif.taken_out <= exif.taken_in;
                dhitLatch <= 0;
            end
        end
    end

endmodule
