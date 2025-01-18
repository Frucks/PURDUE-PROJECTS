// $Id: $
// File name:   adder_nbit.sv
// Created:     1/23/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

`timescale 1ns / 100ps

module adder_nbit
#(
    parameter BIT_WIDTH = 4
)
(
	input logic [BIT_WIDTH - 1:0]a,
	input logic [BIT_WIDTH - 1:0]b,
	input logic carry_in,
	output logic [BIT_WIDTH - 1:0]sum,
	output logic overflow
);
	logic [BIT_WIDTH:0]carrys;
	genvar i;
	
	assign carrys[0] = carry_in;
	generate
	for (i = 0; i <= BIT_WIDTH - 1; i = i + 1) begin
		always @(a[i])
		begin
		assert ((a[i] == 1'b1) || (a[i] == 1'b0))
		else $error("Input 'a' of component is not a digital logic value");
		end

		always @(b[i])
		begin
		assert ((b[i] == 1'b1) || (b[i] == 1'b0))
		else $error("Input 'b' of component is not a digital logic value");
		end

		always @(carry_in)
		begin
		assert ((carry_in == 1'b1) || (carry_in == 1'b0))
		else $error("Input 'carry_in' of component is not a digital logic value");
		end
		
		adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
		end
	endgenerate
	assign overflow = carrys[BIT_WIDTH];

	always @(a[0], b[0], carrys[0])
	begin
		#(2) assert (((a[0] + b[0] + carrys[0]) % 2) == sum[0])
		else $error("Output 's' of first 1 bit adder is not correct");
	end
endmodule