// $Id: $
// File name:   moore.sv
// Created:     2/14/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module moore
(
    input logic clk, n_rst, i,
    output logic o
);

logic nxt_o;
logic [2:0] state;
logic [2:0] nxt_state;

always_ff @( posedge clk, negedge n_rst )
begin: mooreff
if (1'b0 == n_rst)
begin
    o <= 0;
    state <= 0;
end
else begin
    o <= nxt_o;
    state <= nxt_state;
end
end

always_comb
begin: moorecomb
nxt_state = state;
nxt_o = o;
if (state == 0)
begin
    nxt_o = 0;
    nxt_state = (i == 'd1)? 'd1 : 'd0;
end
else if (state == 'd1)
begin
    nxt_o = 0;
    nxt_state = (i == 'd1)? 'd2 : 'd0;
end
else if (state == 'd2)
begin
    nxt_o = 0;
    nxt_state = (i == 'd0)? 'd3 : 'd1;
end
else if (state == 'd3)
begin
    nxt_o = 0;
    nxt_state = (i == 'd1)? 'd4 : 'd0;
end
else if (state == 'd4)
begin
    nxt_o = 1;
    nxt_state = (i == 'd1)? 'd2 : 'd0;
end
end

endmodule