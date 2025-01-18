// $Id: $
// File name:   counter.sv
// Created:     2/22/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module counter (
    input logic clk, n_rst, cnt_up, clear,
    output logic one_k_samples
);

flex_counter #(.NUM_CNT_BITS(10)) COUNT (.clk(clk), .n_rst(n_rst), .clear(clear), .count_enable(cnt_up), .rollover_val(10'd1000), .count_out(), .rollover_flag(one_k_samples));

endmodule