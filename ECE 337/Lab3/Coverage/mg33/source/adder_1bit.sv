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
	always @(a)
	begin
		assert ((a == 1'b1) || (a == 1'b0))
		else $error("Input 'a' of component is not a digital logic value");
	end
	
	always @(b)
	begin
		assert ((b == 1'b1) || (b == 1'b0))
		else $error("Input 'b' of component is not a digital logic value");
	end

	always @(carry_in)
	begin
		assert ((carry_in == 1'b1) || (carry_in == 1'b0))
		else $error("Input 'carry_in' of component is not a digital logic value");
	end
	
	assign sum = carry_in ^ (a ^ b);
	assign carry_out = ((!carry_in) & b & a) | (carry_in & (b | a));
endmodule