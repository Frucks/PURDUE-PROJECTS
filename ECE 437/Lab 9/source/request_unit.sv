`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

module request_unit (
    input logic CLK, nRST,
    request_unit_if.ru ruif
);
    
    import cpu_types_pkg::*;

    
    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            ruif.dmemREN <= 0;
            ruif.dmemWEN <= 0;
        end else if(ruif.ihit) begin
            ruif.dmemREN <= ruif.dREN;
            ruif.dmemWEN <= ruif.dWEN;
        end else if(ruif.dhit) begin
            ruif.dmemREN <= 0;
            ruif.dmemWEN <= 0;
        end 
    end

    assign ruif.imemREN = 1;

    // assign ruif.PCEN = ruif.ihit; // MOVE TO DATAPATH WHEN READY

endmodule