// mapped needs this
`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

module register_file(
    input logic CLK, nRST,
    register_file_if.rf rfif
); 

import cpu_types_pkg::*;

word_t [31:0] registers;


assign rfif.rdat1 = registers[rfif.rsel1];
assign rfif.rdat2 = registers[rfif.rsel2]; 


always_ff @(negedge CLK, negedge nRST) begin
    if(!nRST) begin
        registers <= '0;
    end
    else begin 
        if(rfif.WEN && (rfif.wsel != 0)) begin
            registers[rfif.wsel] <= rfif.wdat;
        end
    end      
end

endmodule
