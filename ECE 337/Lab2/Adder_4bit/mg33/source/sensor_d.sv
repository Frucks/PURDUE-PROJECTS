// $Id: $
// File name:   sensor_d.sv
// Created:     1/18/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module sensor_d
(
	input logic [3:0] sensors,
	output logic error
);

	assign error = sensors[0] | (sensors[2] & sensors[1]) | (sensors[3] & sensors[1]);
endmodule