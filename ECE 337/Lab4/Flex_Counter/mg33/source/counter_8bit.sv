// $Id: $
// File name:   counter_8bit.sv
// Created:     2/7/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module counter_8bit
(
    input logic clk, n_rst, clear, count_enable,
    input logic [8:0] rollover_val,
    output logic [8:0] count_out,
    output logic rollover_flag
);

  flex_counter #(.NUM_CNT_BITS(8)) COUNT (.clk(clk), .n_rst(n_rst), .clear(clear), .count_enable(count_enable), .rollover_val(rollover_val), .count_out(count_out), .rollover_flag(rollover_flag));


endmodule