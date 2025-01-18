// $Id: $
// File name:   apb_slave.sv
// Created:     3/6/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module apb_slave (
    input logic clk, n_rst,
    input logic [7:0] rx_data,
    input logic data_ready, overrun_error, framing_error,
    output logic data_read,
    input logic psel,
    input logic [2:0] paddr,
    input logic penable, pwrite,
    input logic [7:0] pwdata,
    output logic [7:0] prdata,
    output logic pslverr,
    output logic [3:0] data_size,
    output logic [13:0] bit_period
);

logic [7:0] nxt_prdata;
logic nxt_pslverr;
logic [3:0] nxt_datasize;
logic [13:0] nxt_bitperiod;
logic nxt_dataread;

always_ff @(posedge clk, negedge n_rst) begin: slave_ff
    if (n_rst == 0) begin
        prdata <= 0;
        pslverr <= 0;
        data_size <= 0;
        bit_period <= 0;
        data_read <= 0;
    end
    else begin
        prdata <= nxt_prdata;
        pslverr <= nxt_pslverr;
        data_size <= nxt_datasize;
        bit_period <= nxt_bitperiod;
        data_read <= nxt_dataread;
    end
end

always_comb begin: slave_comb
    nxt_dataread = 1'b0;
    nxt_prdata = prdata;
    nxt_bitperiod = bit_period; //data_size;
    nxt_datasize = data_size; //bit_period;
    nxt_pslverr = 1'b0;
    if (psel) begin
        if (pwrite) begin
            case (paddr)
            'd2 : nxt_bitperiod[7:0] = pwdata;
            'd3 : nxt_bitperiod[13:8] = pwdata[5:0];
            'd4 : nxt_datasize = pwdata;
                default: nxt_pslverr = 1'b1;
            endcase
        end
        else begin
            case (paddr)
            'd0 : nxt_prdata = (data_ready)? 'd1: 'd0;
            'd1 : nxt_prdata = (framing_error)? 'd1: (overrun_error)? 'd2: 'd0;
            'd2 : nxt_prdata = bit_period[7:0];
            'd3 : nxt_prdata = {2'd0, bit_period[13:8]};
            'd4 : nxt_prdata = {3'd0, data_size};
            'd6 : if (data_ready) begin nxt_prdata = rx_data; nxt_dataread = 1'b1; end
                default: nxt_pslverr = 1'b1;
            endcase
        end
    end
end

endmodule