// $Id: $
// File name:   magnitude.sv
// Created:     2/22/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module magnitude (
    input logic [16:0] in,
    output logic [15:0] out
);

logic [16:0] temp;
always_comb begin: magnitude_comb
    if (in[16]) begin
        temp = ~in + 'd1;
        out = temp[15:0];
    end
    else
        out = in[15:0];
end

endmodule