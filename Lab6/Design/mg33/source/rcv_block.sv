// $Id: $
// File name:   rcv_block.sv
// Created:     2/15/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: receiver block for UART

module rcv_block (
    input logic clk, n_rst, serial_in, data_read,
    output logic [7:0] rx_data,
    output logic data_ready, overrun_error, framing_error
);

logic start_bit_detected, new_packet_detected; //start_bit_det outputs
logic shift_strobe, packet_done; //timer outputs
logic sbc_clear, sbc_enable, load_buffer, enable_timer; //RCU outputs
logic [7:0] packet_data;
logic stop_bit; //sr_9bit outputs


start_bit_det START_DET (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_detected), .new_packet_detected(new_packet_detected));
rcu RCU (.clk(clk), .n_rst(n_rst), .new_packet_detected(new_packet_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));
timer TIMER (.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_strobe(shift_strobe), .packet_done(packet_done));
sr_9bit SHIFT (.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));
stop_bit_chk STOP_CHK (.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));
rx_data_buff DATA_BUFF (.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

endmodule