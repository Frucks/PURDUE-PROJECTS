// $Id: $
// File name:   ahb_lite_slave.sv
// Created:     3/28/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

module ahb_lite_slave (
    input logic clk, n_rst,
    output logic [15:0] sample_data,
    output logic data_ready, new_coefficient_set,
    input logic [1:0] coefficient_num,
    output logic [15:0] fir_coefficient,
    input logic modwait,
    input logic [15:0] fir_out,
    input logic err, hsel,
    input logic [3:0] haddr,
    input logic hsize,
    input logic [1:0] htrans,
    input logic hwrite,
    input logic [15:0] hwdata,
    output logic [15:0] hrdata,
    output logic hresp
);

logic [15:0] nxt_newsample;
logic nxt_dataready;
logic nxt_newcoeff;
logic [15:0] nxt_hrdata;
logic nxt_hrespread;
logic nxt_hrespwrite;
logic [15:0] f0;
logic [15:0] f1;
logic [15:0] f2;
logic [15:0] f3;
logic [15:0] nxt_f0;
logic [15:0] nxt_f1;
logic [15:0] nxt_f2;
logic [15:0] nxt_f3;
logic [15:0] status;
logic [15:0] nxt_status;
logic [3:0] prev_addr;
logic prev_hwrite;
logic prev_hsize;


always_ff @(posedge clk, negedge n_rst) begin: ahbslave_ff
    if (n_rst == 0) begin
        hrdata <= 0;
        hresp <= 0;
        sample_data <= 0;
        data_ready <= 0;
        new_coefficient_set <= 0;
        f0 <= 0;
        f1 <= 0;
        f2 <= 0;
        f3 <= 0;
        prev_addr <= 0;
        prev_hwrite <= 0;
        prev_hsize <= 0;
    end
    else begin
        hrdata <= nxt_hrdata;
        hresp <= nxt_hrespread || nxt_hrespwrite;
        sample_data <= nxt_newsample;
        data_ready <= nxt_dataready;
        new_coefficient_set <= nxt_newcoeff;
        f0 <= nxt_f0;
        f1 <= nxt_f1;
        f2 <= nxt_f2;
        f3 <= nxt_f3;
        prev_addr <= haddr;
        prev_hwrite <= hwrite;
        prev_hsize <= hsize;
    end
end

always_comb begin: write_comb
nxt_newsample = sample_data;
nxt_f0 = f0;
nxt_f1 = f1;
nxt_f2 = f2;
nxt_f3 = f3;
nxt_newcoeff = 'd0;
nxt_hrespwrite = 1'b0;
nxt_dataready = 1'b0;

if (hsel) begin
    if (prev_hwrite) begin
        if (prev_hsize) begin
            case (prev_addr)
            'h4 : begin nxt_newsample = hwdata; nxt_dataready = 1'b1; end
            'h6 : nxt_f0 = hwdata;
            'h8 : nxt_f1 = hwdata;
            'hA : nxt_f2 = hwdata;
            'hC : nxt_f3 = hwdata;
            'hE : nxt_newcoeff = 1'd1;
                default: nxt_hrespwrite = 1'b1;
            endcase
        end
        else begin
            case (haddr)
            'h4 : begin nxt_newsample = hwdata[7:0]; nxt_dataready = 1'b1; end
            'h5 : begin nxt_newsample = hwdata[15:8]; nxt_dataready = 1'b1; end
            'h6 : nxt_f0[7:0] = hwdata[7:0];
            'h7 : nxt_f0[15:8]= hwdata[15:8];
            'h8 : nxt_f1[7:0] = hwdata[7:0];
            'h9 : nxt_f1[15:8] = hwdata[15:8];
            'hA : nxt_f2[7:0] = hwdata[7:0];
            'hB : nxt_f2[15:8] = hwdata[15:8];
            'hC : nxt_f3[7:0] = hwdata[7:0];
            'hD : nxt_f3[15:8] = hwdata[15:8];
            'hE : nxt_newcoeff = 1'd1;
                default: nxt_hrespwrite = 1'b1;
            endcase
        end
    end
end
end

always_comb begin: read_comb
nxt_hrdata = hrdata;
nxt_hrespread = 1'b0;
if (hsel) begin
    if (hwrite == 0) begin
        if (hsize) begin
            case (haddr)
            'h0 : nxt_hrdata = status;
            'h2 : nxt_hrdata = fir_out;
            'h4 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: sample_data;
            'h6 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: f0;
            'h8 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: f1;
            'hA : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: f2;
            'hC : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: f3;
            'hE : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: new_coefficient_set;
                default: nxt_hrespread = 1'b1;
        endcase
        end
        else begin
            case (haddr)
            'h0 : nxt_hrdata = {8'd0, status[7:0]};
            'h1 : nxt_hrdata = {status[15:8], 8'd0};
            'h2 : nxt_hrdata = {8'd0, fir_out[7:0]};
            'h3 : nxt_hrdata = {fir_out[15:8], 8'd0};
            'h4 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {8'd0, hwdata[7:0]}: {8'd0, sample_data[7:0]};
            'h5 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {hwdata[15:8], 8'd0}: {sample_data[15:8], 8'd0};
            'h6 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {8'd0, hwdata[7:0]}: {8'd0, f0[7:0]};
            'h7 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {hwdata[15:8], 8'd0}: {f0[15:8], 8'd0};
            'h8 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {8'd0, hwdata[7:0]}: {8'd0, f1[7:0]};
            'h9 : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {hwdata[15:8], 8'd0}: {f1[15:8], 8'd0};
            'hA : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {8'd0, hwdata[7:0]}: {8'd0, f2[7:0]};
            'hB : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {hwdata[15:8], 8'd0}: {f2[15:8], 8'd0};
            'hC : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {8'd0, hwdata[7:0]}: {8'd0, f3[7:0]};
            'hD : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? {hwdata[15:8], 8'd0}: {f3[15:8], 8'd0};
            'hE : nxt_hrdata = ((prev_addr == haddr) && (prev_hwrite == 1'b1)) ? hwdata: new_coefficient_set;
                default: nxt_hrespread = 1'b1;
        endcase
        end
    end
end
end

always_comb begin: fir_comb
    case (coefficient_num)
'd0 : fir_coefficient = f0;
'd1 : fir_coefficient = f1;
'd2 : fir_coefficient = f2;
'd3 : fir_coefficient = f3;
endcase
end

assign status ={7'b0, err, 7'b0, (modwait || new_coefficient_set)};

endmodule