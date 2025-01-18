// $Id: $
// File name:   rcu.sv
// Created:     2/15/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: receiver control unit for UART

module rcu (
    input logic clk, n_rst, new_packet_detected, packet_done, framing_error,
    output logic sbc_clear, sbc_enable, load_buffer, enable_timer
);

logic [2:0] state, nxt_state;

always_ff @(posedge clk, negedge n_rst) begin: state_ff
    if (n_rst == 0) begin
        state <= 0;
    end
    else begin
        state <= nxt_state;
    end
end

always_comb begin: state_output_logic
    nxt_state = 0;
    sbc_clear = 0;
    enable_timer = 0;
    sbc_enable = 0;
    load_buffer = 0;
    case (state)
    'd0 : nxt_state = (new_packet_detected)? 'd1: 'd0;
    'd1 : begin nxt_state = 'd2; sbc_clear = 1'b1; enable_timer = 1'b1; end
    'd2 : begin nxt_state = (packet_done)? 'd3: 'd2; enable_timer = 1'b1; end
    'd3 : begin nxt_state = 'd4; sbc_enable = 1'b1; end
    'd4 : begin nxt_state = 'd0 /*(framing_error)? 'd0 : 'd5*/; load_buffer = !framing_error; end
    // 'd5 : begin load_buffer = 1'b1; end
        default: begin nxt_state = 0; sbc_clear = 0; enable_timer = 0; sbc_enable = 0; load_buffer = 0; end
    endcase
end


endmodule