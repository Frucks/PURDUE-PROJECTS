// $Id: $
// File name:   adder_4bit.sv
// Created:     1/18/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module adder_4bit
(
	input logic [3:0]a, [3:0]b, carry_in,
	output logic [3:0]sum, overflow
);
	logic [4:0]carrys;
	genvar i;
	
	assign carrys[0] = carry_in;
	generate
	for (i = 0; i <= 3; i = i + 1) begin
		adder_1bitIX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
		end
	endgenerate
	assign overflow = carrys[4];
endmodule