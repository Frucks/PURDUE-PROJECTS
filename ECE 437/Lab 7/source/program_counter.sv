`include "cpu_types_pkg.vh"
`include "program_counter_if.vh"

module program_counter (
    input logic CLK, nRST,
    program_counter_if.pc pcif
);
    
    import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST ) begin
        if(!nRST) begin
            pcif.PC <= '0;
        end else begin
            if(pcif.PCEN) begin
                pcif.PC <= pcif.new_PC;
            end
        end
    end

    assign pcif.next_PC = pcif.PC + 4;


endmodule