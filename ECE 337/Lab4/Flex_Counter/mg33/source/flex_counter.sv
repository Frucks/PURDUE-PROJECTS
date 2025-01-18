// $Id: $
// File name:   flex_counter.sv
// Created:     2/1/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module flex_counter
#(
    parameter NUM_CNT_BITS = 4
)
(
    input logic clk, n_rst, clear, count_enable,
    input logic [NUM_CNT_BITS - 1:0] rollover_val,
    output logic [NUM_CNT_BITS - 1:0] count_out,
    output logic rollover_flag
);

    logic [NUM_CNT_BITS - 1:0] next_count;
    logic next_flag;

    always_ff @ (posedge clk, negedge n_rst)
    begin :counter_ff
    if (1'b0 == n_rst) begin
        count_out <= '0;
        rollover_flag <= '0;
    end
    else begin
        count_out <= next_count;
        rollover_flag <= next_flag;
    end
    end

    always_comb
    begin :counter_comb
    next_count = count_out;
    if (clear == 1'b1) begin
        next_count = '0;
    end
    else if (count_out == rollover_val && count_enable == 1'b1) begin
        next_count = 'd1;
    end
    else if (count_enable == 1'b1)begin
        next_count = next_count + 'd1;
    end
    end

    always_comb begin: flag_comb
    next_flag = 1'b0;
    if (clear == 1'b1) begin
        next_flag = '0;
    end
    else if (next_count == rollover_val) begin
        next_flag = 1'b1;
    end
    end

endmodule