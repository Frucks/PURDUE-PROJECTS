// $Id: $
// File name:   sync_low.sv
// Created:     2/1/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module sync_low
(
    input logic clk, n_rst, async_in,
    output logic sync_out
);
    logic output_1, output_2;

    always_ff @ (posedge clk, negedge n_rst)
    begin :sychronizer_low
    if (1'b0 == n_rst) begin
        output_1 <= 1'b0;
        output_2 <= 1'b0;
    end
    else begin
        output_1 <= async_in;
        output_2 <= output_1;
    end
    end

    assign sync_out = output_2;

endmodule