// $Id: $
// File name:   fir_filter.sv
// Created:     2/22/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module fir_filter (
    input logic clk, n_reset,
    input logic [15:0] sample_data, fir_coefficient,
    input logic load_coeff, data_ready,
    output logic one_k_samples, modwait,
    output logic [15:0] fir_out,
    output logic err
);

logic dr, lc, overflow, cnt_up, clear;
logic [2:0] op;
logic [3:0] src1, src2, dest;
logic [16:0] outreg_data;

sync_low DR_SYNC (.clk(clk), .n_rst(n_reset), .async_in(data_ready), .sync_out(dr));
sync_low LC_SYNC (.clk(clk), .n_rst(n_reset), .async_in(load_coeff), .sync_out(lc));
controller CONTROL (.clk(clk), .n_rst(n_reset), .dr(dr), .lc(lc), .overflow(overflow), .cnt_up(cnt_up), .clear(clear), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err));
datapath DATAPATH (.clk(clk), .n_reset(n_reset), .op(op), .src1(src1), .src2(src2), .dest(dest), .ext_data1(sample_data), .ext_data2(fir_coefficient), .outreg_data(outreg_data), .overflow(overflow));
magnitude MAG (.in(outreg_data), .out(fir_out));
counter COUNT (.clk(clk), .n_rst(n_reset), .cnt_up(cnt_up), .clear(clear), .one_k_samples(one_k_samples));

endmodule