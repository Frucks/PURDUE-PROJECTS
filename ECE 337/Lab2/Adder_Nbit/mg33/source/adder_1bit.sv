// $Id: $
// File name:   adder_1bit.sv
// Created:     1/18/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module adder_1bit
(
	input logic a,b,carry_in,
	output logic sum, carry_out
);
	assign sum = carry_in ^ (a ^ b);
	assign carry_out = ((!carry_in) & b & a) | (carry_in & (b | a));
endmodule