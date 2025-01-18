// $Id: $
// File name:   adder_16bit.sv
// Created:     1/25/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);
	always @(a)
	begin
		assert ((a <= 16'hFFFF) && (a >= 16'h0000))
		else $error("Input 'a' of component is not a digital logic value");
	end
	
	always @(b)
	begin
		assert ((b <= 16'hFFFF) && (b >= 16'h0000))
		else $error("Input 'b' of component is not a digital logic value");
	end

	always @(carry_in)
	begin
		assert ((carry_in == 1'b1) || (carry_in == 1'b0))
		else $error("Input 'carry_in' of component is not a digital logic value");
	end
	// STUDENT: Fill in the correct port map with parameter override syntax for using your n-bit ripple carry adder design to be an 8-bit ripple carry adder design
	adder_nbit #(.BIT_WIDTH(16)) ADD (.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));
endmodule