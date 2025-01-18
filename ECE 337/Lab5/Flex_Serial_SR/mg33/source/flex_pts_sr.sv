// $Id: $
// File name:   flex_pts_sr.sv
// Created:     2/8/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module flex_pts_sr
#(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1'b1
) (
    input logic clk, n_rst, shift_enable, load_enable,
    input logic [NUM_BITS - 1:0] parallel_in,
    output logic serial_out
);

logic nxt_serial_out;
logic [NUM_BITS - 1:0] curr_par_in;

always_ff @(posedge clk, negedge n_rst)
begin : ptsff
if (1'b0 == n_rst) begin
    serial_out <= '1;
end
else begin
    serial_out <= nxt_serial_out;
end
end

always_comb
begin : ptscomb
if (load_enable == 1)
begin
    curr_par_in = parallel_in;
    if (SHIFT_MSB == 0)
    begin
        nxt_serial_out = parallel_in[0];
    end
    else
    begin
        nxt_serial_out = parallel_in[NUM_BITS - 1];
    end
end
else if (shift_enable == 1)
begin
    if (SHIFT_MSB == 0)
    begin
        curr_par_in = {1'b1, curr_par_in[NUM_BITS - 1:1]};
        nxt_serial_out = curr_par_in[0];
    end
    else
    begin
        curr_par_in = {curr_par_in[NUM_BITS - 2:0], 1'b1};
        nxt_serial_out = curr_par_in[NUM_BITS - 1];
    end
end
else
begin
    nxt_serial_out = curr_par_in[NUM_BITS - 1];
end
end

endmodule