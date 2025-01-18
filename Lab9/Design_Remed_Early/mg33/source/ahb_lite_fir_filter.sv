// $Id: $
// File name:   ahb_lite_fir_filter.sv
// Created:     3/30/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module ahb_lite_fir_filter (
    input logic clk, n_rst, hsel,
    input logic [3:0] haddr,
    input logic hsize,
    input logic [1:0] htrans,
    input logic hwrite,
    input logic [15:0] hwdata,
    output logic [15:0] hrdata,
    output logic hresp
);

logic modwait, err, load_coeff;
logic [15:0] fir_coefficient;
logic [15:0] fir_out;
logic new_coefficient_set;
logic [1:0] coefficient_num;
logic [15:0] sample_data;

ahb_lite_slave SLAVE (.clk(clkl), .n_rst(n_rst), .sample_data(sample_data), .data_ready(data_ready), .new_coefficient_set(new_coefficient_set), .coefficient_num(coefficient_num), .fir_coefficient(fir_coefficient), .modwait(modwait), .fir_out(fir_out), .err(err), .hsel(hsel), .haddr(haddr), .hsize(hsize), .htrans(htrans), .hwrite(hwrite), .hwdata(hwdata), .hrdata(hrdata), .hresp(hresp));
coefficient_loader LOADER (.clk(clk), .n_reset(n_rst), .new_coefficient_set(new_coefficient_set), .modwait(modwait), .load_coeff(load_coeff), .coefficient_num(coefficient_num));
fir_filter FILTER (.clk(clk), .n_reset(n_rst), .sample_data(sample_data), .data_ready(data_ready), .fir_coefficient(fir_coefficient), .load_coeff(load_coeff), .one_k_samples(), .modwait(modwait), .fir_out(fir_out), .err(err));


endmodule