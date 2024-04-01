`include "cpu_types_pkg.vh"
`include "branch_predictor_if.vh"

module branch_predictor (
    input logic CLK, nRST,
    branch_predictor_if.bp bpif
);

typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
state_t state, next_state;

always_comb begin
    case(state)
        S0: begin
            bpif.take = 1;
            next_state = S0;
            if(bpif.good) begin
                next_state = S0;
            end else if(bpif.bad)begin
                next_state = S1;
            end
        end
        S1: begin
            bpif.take = 1;
            next_state = S1;
            if(bpif.good) begin
                next_state = S0;
            end else if(bpif.bad) begin
                next_state = S2;
            end
        end
        S2: begin
            bpif.take = 0;
            next_state = S2;
            if(bpif.good) begin
                next_state = S2;
            end else if(bpif.bad) begin
                next_state = S3;
            end
        end
        S3: begin
            bpif.take = 0;
            next_state = S3;
            if(bpif.good) begin
                next_state = S2;
            end else if(bpif.bad) begin
                next_state = S0;
            end
        end
        default: begin
            bpif.take = 1;
            next_state = S0;
        end
    endcase
end

always_ff @(posedge CLK, negedge nRST) begin
    if(~nRST) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

    
endmodule
