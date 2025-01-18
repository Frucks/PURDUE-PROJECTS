// $Id: $
// File name:   sr_9bit.sv
// Created:     2/15/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 9-bit shift register for UART

module sr_9bit (
    input logic clk, n_rst, shift_strobe, serial_in,
    output logic [7:0] packet_data,
    output logic stop_bit
);

logic [8:0] parallel_out;

flex_stp_sr #(.NUM_BITS(9), .SHIFT_MSB(0)) SHIFT (.clk(clk), .n_rst(n_rst), .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out(parallel_out));

assign packet_data = parallel_out[7:0];
assign stop_bit = parallel_out[8];

endmodule