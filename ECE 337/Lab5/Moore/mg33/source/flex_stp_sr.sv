// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/8/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module flex_stp_sr
#(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1'b1
) (
    input logic clk, n_rst, shift_enable, serial_in,
    output logic [NUM_BITS - 1:0] parallel_out
);

logic [NUM_BITS - 1:0] nxt_parallel_out;

always_ff @(posedge clk, negedge n_rst)
begin : stpff
if (1'b0 == n_rst) begin
    parallel_out <= '1;
end
else begin
    parallel_out <= nxt_parallel_out;
end
end

always_comb
begin : stpcomb
    if (shift_enable == 1)
    begin
        if (SHIFT_MSB == 0)
        begin
            nxt_parallel_out = {serial_in, parallel_out[NUM_BITS - 1:1]};
        end
        else
        begin
            nxt_parallel_out = {parallel_out[NUM_BITS - 2:0], serial_in};
        end
    end
    else
    begin
        nxt_parallel_out = parallel_out;
    end
end

endmodule