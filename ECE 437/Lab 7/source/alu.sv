`include "cpu_types_pkg.vh"
`include "alu_if.vh"
module alu
    import cpu_types_pkg::*;
    (
    alu_if.alu alu
    );

    always_comb begin
        casez (alu.aluop)
        ALU_SLL : begin alu.port_out = alu.port_b << alu.port_a[4:0]; end
        ALU_SRL : begin alu.port_out = alu.port_b >> alu.port_a[4:0]; end
        ALU_ADD : begin alu.port_out = $signed(alu.port_b) + $signed(alu.port_a); end
        ALU_SUB : begin alu.port_out = $signed(alu.port_a) - $signed(alu.port_b); end
        ALU_AND : begin alu.port_out = alu.port_b & alu.port_a; end
        ALU_OR  : begin alu.port_out = alu.port_b | alu.port_a; end
        ALU_XOR : begin alu.port_out = alu.port_b ^ alu.port_a; end
        ALU_NOR : begin alu.port_out = ~(alu.port_b | alu.port_a); end
        ALU_SLT : begin alu.port_out = ($signed(alu.port_a) < $signed(alu.port_b)); end
        ALU_SLTU : begin alu.port_out = (alu.port_a < alu.port_b); end
            default: alu.port_out = '0;
        endcase
    end

    always_comb begin
        casez (alu.aluop)
        ALU_ADD: begin alu.overflow = (alu.port_a[31] == alu.port_b[31]) && (alu.port_a[31] != alu.negative); end
        ALU_SUB: begin alu.overflow = (alu.port_a[31] != alu.port_b[31]) && (alu.port_a[31] != alu.negative); end
            default: alu.overflow = 0;
        endcase
    end

    assign alu.zero = (alu.port_out == '0); // if the output port is 0 then flag is set
    assign alu.negative = alu.port_out[31]; // if last bit in output port is 1, then flag is set

endmodule