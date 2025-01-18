// $Id: $
// File name:   timer.sv
// Created:     2/15/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: timer for UART

module timer (
    input logic clk, n_rst, enable_timer,
    input logic [3:0] data_size,
    input logic [13:0] bit_period,
    output logic shift_strobe, packet_done
);

logic [3:0] clk_count;
logic [14:0] bits_per_packet;

always_comb begin: statement_label
    shift_strobe = 0;
    bits_per_packet = data_size + 'd1;
    if (clk_count == 'd1) begin
        shift_strobe = 1'b1;
    end
    else begin
        shift_strobe = 0;
    end
end

flex_counter #(.NUM_CNT_BITS(4)) CLOCK_COUNT (.clk(clk), .n_rst(n_rst), .clear(!enable_timer), .count_enable(enable_timer), .rollover_val(bit_period), .count_out(clk_count), .rollover_flag());

flex_counter #(.NUM_CNT_BITS(15)) BIT_COUNT (.clk(clk), .n_rst(n_rst), .clear(!enable_timer), .count_enable(shift_strobe), .rollover_val(bits_per_packet), .count_out(), .rollover_flag(packet_done));

endmodule