// $Id: $
// File name:   sensor_s.sv
// Created:     1/18/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 

module sensor_s
(
	input logic [3:0] sensors,
	output logic error
);

	logic and1;
	logic and2;
	logic or1;

	AND2X1 A1(.Y(and1), .A(sensors[3]), .B(sensors[1]));
	AND2X1 A2(.Y(and2), .A(sensors[2]), .B(sensors[1]));
	OR2X1 O1(.Y(or1), .A(and1), .B(and2));
	OR2X1 O2(.Y(error), .A(sensors[0]), .B(or1));

endmodule