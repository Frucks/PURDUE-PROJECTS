`include "IF_ID_if.vh"
`include "cpu_types_pkg.vh"

module IF_ID (
    input logic CLK, nRST,
    IF_ID_if.ifid ifif
);

    import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST ) begin
        if(~nRST) begin
            ifif.instruction_out <= '0;
            ifif.next_PC_out <= '0;
            ifif.rs_out <= '0;
            ifif.rt_out <= '0;
            ifif.rd_out <= '0;
            ifif.taken_out <= 0;
        end else if(ifif.flush) begin
            ifif.instruction_out <= '0;
            ifif.next_PC_out <= '0;
            ifif.rs_out <= '0;
            ifif.rt_out <= '0;
            ifif.rd_out <= '0;
            ifif.taken_out <= 0;
        end else if(ifif.IF_ID_en) begin
            ifif.instruction_out <= ifif.instruction_in;
            ifif.next_PC_out <= ifif.next_PC_in;
            ifif.rs_out <= ifif.rs_in;
            ifif.rt_out <= ifif.rt_in;
            ifif.rd_out <= ifif.rd_in;
            ifif.taken_out <= ifif.taken_in;
        end
    end


endmodule