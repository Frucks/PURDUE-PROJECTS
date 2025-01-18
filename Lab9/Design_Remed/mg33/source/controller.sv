// $Id: $
// File name:   controller.sv
// Created:     2/22/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module controller (
    input logic clk, n_rst, dr, lc, overflow,
    output logic cnt_up, clear, modwait,
    output logic [2:0] op,
    output logic [3:0] src1, src2, dest,
    output logic err
);

logic nxt_modwait;
typedef enum logic [4:0] {IDLE, STORE, ZERO, SORTD1, SORTD2, SORTD3, SORTD4, MUL1, ADD1, MUL2, SUB1, MUL3, ADD2, MUL4, SUB2, EIDLE, STOREL1, STOREL2, STOREL3, STOREL4, WAITL1, WAITL2, WAITL3} stateType;
stateType state, nxt_state;

always_ff @(posedge clk, negedge n_rst) begin: controller_ff
    if (n_rst == 1'b0) begin
        modwait = 0;
        state = IDLE;
    end
    else begin
        modwait = nxt_modwait;
        state = nxt_state;
    end
end

always_comb begin: controller_comb
    nxt_modwait = 1'b0; nxt_state = IDLE; cnt_up = 1'b0; op = '0; src1 = '0; src2 = '0; dest = '0; err = '0; clear = 1'b0;
    case (state)
        IDLE : begin nxt_modwait = 1'b0; op = 3'b000; if (lc) nxt_state = STOREL1; else begin if (dr) nxt_state = STORE; else nxt_state = IDLE; end end

        // Data states
        STORE: begin nxt_modwait = 1'b1; err = 1'b0; op = 3'b010; dest = 'd5; if (dr == 0) nxt_state = EIDLE; else begin nxt_state = ZERO; end end
        ZERO: begin nxt_modwait = 1'b1; cnt_up = 1'b1; op = 3'b101; src1 = 'd0; src2 = 'd0; dest = 0; nxt_state = SORTD1; end
        SORTD1: begin nxt_modwait = 1'b1; op = 3'b001; src1 = 'd2; dest = 'd1; nxt_state = SORTD2; end
        SORTD2: begin nxt_modwait = 1'b1; op = 3'b001; src1 = 'd3; dest = 'd2; nxt_state = SORTD3; end
        SORTD3: begin nxt_modwait = 1'b1; op = 3'b001; src1 = 'd4; dest = 'd3; nxt_state = SORTD4; end
        SORTD4: begin nxt_modwait = 1'b1; op = 3'b001; src1 = 'd5; dest = 'd4; nxt_state = MUL1; end
        MUL1: begin nxt_modwait = 1'b1;  op = 3'b110; src1 = 'd1; src2 = 'd6; dest = 'd10; nxt_state = ADD1; end
        ADD1: begin nxt_modwait = 1'b1; op = 3'b100; src1 = 'd0; src2 = 'd10; dest = 'd0;  if (overflow) nxt_state = EIDLE; else nxt_state = MUL2; end
        MUL2: begin nxt_modwait = 1'b1; op = 3'b110; src1 = 'd2; src2 = 'd7; dest = 'd10; nxt_state = SUB1; end
        SUB1: begin nxt_modwait = 1'b1; op = 3'b101; src1 = 'd0; src2 = 'd10; dest = 'd0; if (overflow) nxt_state = EIDLE; else nxt_state = MUL3; end
        MUL3: begin nxt_modwait = 1'b1; op = 3'b110; src1 = 'd3; src2 = 'd8; dest = 'd10; nxt_state = ADD2; end
        ADD2: begin nxt_modwait = 1'b1; op = 3'b100; src1 = 'd0; src2 = 'd10; dest = 'd0; if (overflow) nxt_state = EIDLE; else nxt_state = MUL4; end
        MUL4: begin nxt_modwait = 1'b1; op = 3'b110; src1 = 'd4; src2 = 'd9; dest = 'd10; nxt_state = SUB2; end
        SUB2: begin nxt_modwait = 1'b1; op = 3'b101; src1 = 'd0; src2 = 'd10; dest = 'd0; if (overflow) nxt_state = EIDLE; else nxt_state = IDLE; end
        EIDLE: begin err = 1'b1; op = 3'b000; if (dr) nxt_state = STORE; else nxt_state = EIDLE; end

        //Coeff states
        STOREL1: begin nxt_modwait = 1'b1; op = 3'b011; dest = 'd9; clear = 1'b1; nxt_state = WAITL1; end
        WAITL1: begin nxt_modwait = 1'b0; op = 3'b000; if (lc) nxt_state = STOREL2; else nxt_state = WAITL1; end
        STOREL2: begin nxt_modwait = 1'b1; op = 3'b011; dest = 'd8; nxt_state = WAITL2; end
        WAITL2: begin nxt_modwait = 1'b0; op = 3'b000; if (lc) nxt_state = STOREL3; else nxt_state = WAITL2; end
        STOREL3: begin nxt_modwait = 1'b1; op = 3'b011; dest = 'd7; nxt_state = WAITL3; end
        WAITL3: begin nxt_modwait = 1'b0; op = 3'b000; if (lc) nxt_state = STOREL4; else nxt_state = WAITL3; end
        STOREL4: begin nxt_modwait = 1'b1; op = 3'b011; dest = 'd6; nxt_state = IDLE; end

        default: begin nxt_modwait = 1'b0; nxt_state = IDLE; cnt_up = 1'b0; op = '0; src1 = '0; src2 = '0; dest = '0; err = '0; clear = 1'b0; end
    endcase
end

endmodule