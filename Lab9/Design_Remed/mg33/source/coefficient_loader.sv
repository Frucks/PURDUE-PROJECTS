// $Id: $
// File name:   coefficient_loader.sv
// Created:     3/30/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module coefficient_loader (
    input logic clk, n_reset, new_coefficient_set, modwait,
    output logic load_coeff,
    output logic [1:0] coefficient_num
);

logic nxt_load;
logic [1:0] nxt_num;
typedef enum logic [3:0] {IDLE, ST0, WAIT0, ST1, WAIT1, ST2, WAIT2, ST3, WAIT3} stateType;
stateType state, nxt_state;

always_ff @(posedge clk, negedge n_reset) begin: load_ff
    if (n_reset == 0) begin
        load_coeff <= 0;
        coefficient_num <= 0;
        state <= IDLE;
    end
    else begin
        load_coeff <= nxt_load;
        coefficient_num <= nxt_num;
        state <= nxt_state;
    end
end

always_comb begin: load_comb
    nxt_state = state;
    nxt_load = 0;
    nxt_num = 0;
    case (state)
    IDLE : nxt_state = (new_coefficient_set && !modwait) ? ST0 : IDLE;
    ST0 : begin nxt_state = WAIT1; nxt_load = 1'b1; nxt_num = 'd0; end
    WAIT0 : nxt_state = (modwait) ? WAIT0: ST1;
    ST1 : begin nxt_state = WAIT2; nxt_load = 1'b1; nxt_num = 'd1; end
    WAIT1 : nxt_state = (modwait) ? WAIT1: ST2;
    ST2 : begin nxt_state = WAIT3; nxt_load = 1'b1; nxt_num = 'd2; end
    WAIT2 : nxt_state = (modwait) ? WAIT2: ST3;
    ST3 : begin nxt_state = IDLE; nxt_load = 1'b1; nxt_num = 'd3; end
        default: begin nxt_state = IDLE; nxt_load = 0; nxt_num = 0; end
    endcase
end

endmodule