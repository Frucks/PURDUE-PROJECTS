import cpu_types_pkg::*;

module dcache (
	input logic CLK, nRST,
	datapath_cache_if.dcache dcif,
	caches_if.dcache cif
);

    typedef enum logic[3:0] {
        IDLE, WB1, WB2, ALLOC1, ALLOC2, FLUSH1, FLUSH2, DIRTY, COUNT
    } state_t;

    dcache_frame [1:0][7:0] frames; 
    dcachef_t address;

    logic [31:0] test_address;
    
    logic miss;
    logic [7:0] available, next_available;
    // logic [4:0] row, next_row;
    // logic [2:0] row_trunc;
    word_t hit_count, next_hit_count;

    logic [4:0] count, next_count;

    state_t state, next_state;
    // input address
    assign address.tag = dcif.dmemaddr[31:6];
    assign address.idx = dcif.dmemaddr[5:3];
    assign address.blkoff = dcif.dmemaddr[2];
    assign address.bytoff = '0;

    assign test_address = {address.tag, address.idx,address.blkoff,address.bytoff};

    // assign row_trunc = row[2:0] - 1;

    //IDLE state
    logic [25:0] tag_1, tag_2;
    word_t data1_1, data2_1, data1_2, data2_2;
    logic dirty_1, valid_1, dirty_2, valid_2;
    logic flush, next_flush;

    assign dcif.flushed = flush;

    always_ff @(posedge CLK, negedge nRST) begin
        if(~nRST) begin
            frames[0][7:0] <= '0;
            frames[1][7:0] <= '0;
            available <= '0;
            state <= IDLE;
            hit_count <= 0;
            // row <= '0; 
            count <= '0;
            flush <= 0;
        end else begin
            frames[0][address.idx].tag <= tag_1;
            frames[1][address.idx].tag <= tag_2;
            frames[0][address.idx].data[0] <= data1_1;
            frames[0][address.idx].data[1] <= data2_1;
            frames[1][address.idx].data[0] <= data1_2;
            frames[1][address.idx].data[1] <= data2_2;
            // frames[0][address.idx].valid <= valid_1;
            // frames[1][address.idx].valid <= valid_2;
            frames[0][address.idx].dirty <= dirty_1;
            frames[1][address.idx].dirty <= dirty_2;
            available[address.idx] <= next_available[address.idx];
            state <= next_state;
            hit_count <= next_hit_count;
            // row <= next_row;
            count <= next_count;
            flush <= next_flush;
            // invalidate all frames
            if(state == DIRTY) begin
                if(!frames[0][count[2:0]].dirty || !frames[0][count[2:0]].valid) begin
                    frames[0][count[2:0]].valid <= valid_1;
                end else if (!frames[1][count[2:0]].dirty || !frames[1][count[2:0]].valid) begin
                    frames[1][count[2:0]].valid <= valid_2;
                end
            end else begin
                frames[0][address.idx].valid <= valid_1;
                frames[1][address.idx].valid <= valid_2;
            end
        end
    end

    //Output Logic
    // assign dcif.flushed = state == HALT; // also must invalidate blocks
    always_comb begin
        miss = 0;
        dcif.dhit = 0;
        dcif.dmemload = 0;
        cif.dREN = 0;
        cif.dWEN = 0;
        cif.daddr = 0;
        cif.dstore = 0;

        data1_1 = frames[0][address.idx].data[0]; 
        data2_1 = frames[0][address.idx].data[1];
        data1_2 = frames[1][address.idx].data[0];
        data2_2 = frames[1][address.idx].data[1];
        dirty_1 = frames[0][address.idx].dirty;
        dirty_2 = frames[1][address.idx].dirty;
        valid_1 = frames[0][address.idx].valid; 
        valid_2 = frames[1][address.idx].valid;
        tag_1 = frames[0][address.idx].tag;
        tag_2 = frames[1][address.idx].tag;

        next_available = available;
        // next_row = row;
        next_hit_count = hit_count;
        next_state = state;
        next_count = count;
        next_flush = flush;

        casez(state)
            IDLE : begin
                if (dcif.halt) begin
                    next_hit_count = hit_count;
                end else if (dcif.dmemREN) begin
                    if ((address.tag == frames[0][address.idx].tag) && frames[0][address.idx].valid) begin
                        dcif.dhit = 1;
                        dcif.dmemload = address.blkoff ? frames[0][address.idx].data[1]:frames[0][address.idx].data[0];
                        next_available[address.idx] = 1;
                        next_hit_count = hit_count + 1;
                    end else if ((address.tag == frames[1][address.idx].tag) && frames[1][address.idx].valid) begin
                        dcif.dhit = 1;
                        dcif.dmemload = address.blkoff ? frames[1][address.idx].data[1]:frames[1][address.idx].data[0];
                        next_available[address.idx] = 0;
                        next_hit_count = hit_count + 1;
                    end else begin
                        miss = 1;

                        // if any blocks are invalid, directly replace
                        if(!frames[0][address.idx].valid || !frames[1][address.idx].valid) begin
                            if(!frames[0][address.idx].valid) begin
                                next_available[address.idx] = 0;
                            end else begin
                                next_available[address.idx] = 1;
                            end
                        end

                        next_hit_count = hit_count - 1;
                    end
                end else if (dcif.dmemWEN) begin
                    if ((address.tag == frames[0][address.idx].tag && frames[0][address.idx].valid)) begin
                            dcif.dhit = 1;
                            dirty_1 = 1;
                            valid_1 = 1;
                            next_available[address.idx] = 1;
                            next_hit_count = hit_count + 1;
                            if(address.blkoff == 0) data1_1 = dcif.dmemstore; 
                            else data2_1 = dcif.dmemstore;
                    end else if ((address.tag == frames[1][address.idx].tag && frames[1][address.idx].valid)) begin
                            dcif.dhit = 1;
                            dirty_2 = 1;
                            valid_2 = 1;
                            next_available[address.idx] = 0;
                            next_hit_count = hit_count + 1;
                            if(address.blkoff == 0) data1_2 = dcif.dmemstore;
                            else data2_2 = dcif.dmemstore;
                    end else begin
                        miss = 1;

                        // if any blocks are invalid, directly replace
                        if(!frames[0][address.idx].valid || !frames[1][address.idx].valid) begin
                            if(!frames[0][address.idx].valid) begin
                                next_available[address.idx] = 0;
                            end else begin
                                next_available[address.idx] = 1;
                            end
                        end
                        next_hit_count = hit_count - 1;
                    end
                end

                if (dcif.halt) next_state = DIRTY;
                else if (miss) begin // allocate on miss
                    if (available[address.idx] == 0) begin // available next clock cycle !!!
                        next_state = frames[0][address.idx].dirty ? WB1:ALLOC1;
                    end else begin
                        next_state = frames[1][address.idx].dirty ? WB1:ALLOC1;
                    end
                end else begin
                    next_state = IDLE;
                end
            end
            WB1 : begin
                cif.dWEN = 1;
                cif.daddr = {frames[available[address.idx]][address.idx].tag, address.idx, 3'b000}; // look into, not ready in time for some reason
                cif.dstore = frames[available[address.idx]][address.idx].data[0];
                if (~cif.dwait) next_state = WB2;
            end
            WB2 : begin
                cif.dWEN = 1;
                cif.daddr = {frames[available[address.idx]][address.idx].tag, address.idx, 3'b100};
                cif.dstore = frames[available[address.idx]][address.idx].data[1];
                if (~cif.dwait) next_state = ALLOC1;
            end
            ALLOC1 : begin
                cif.dREN = 1;
                cif.daddr = {address.tag, address.idx, 3'b000};
                
                if (available[address.idx] == 0) begin
                    data1_1 = cif.dload;
                end else begin
                    data1_2 = cif.dload;
                end

                if (~cif.dwait) next_state = ALLOC2;
            end
            ALLOC2 : begin
                cif.dREN = 1;
                cif.daddr = {address.tag, address.idx, 3'b100};
                if (available[address.idx] == 0) begin
                    data2_1 = cif.dload;
                    tag_1 = address.tag;
                    dirty_1 = 0;
                    valid_1 = 1;
                end else begin
                    data2_2 = cif.dload;
                    tag_2 = address.tag;
                    dirty_2 = 0;
                    valid_2 = 1;
                end

                if (~cif.dwait) next_state = IDLE;
            end
            DIRTY : begin 
                if (count == 5'b10000) begin
                    next_state = COUNT;
                end else if (count < 8) begin
                    if(frames[0][count[2:0]].dirty && frames[0][count[2:0]].valid) begin
                        next_state = FLUSH1;
                    end else begin
                        next_count = count + 1;
                        // dirty_1 = 0;
                        // valid_1 = 0;
                    end
                end else if (count >= 8) begin
                    if(frames[1][count[2:0]].dirty && frames[1][count[2:0]].valid) begin
                        next_state = FLUSH1;
                    end else begin
                        next_count = count + 1;
                        // dirty_2 = 0;
                        // valid_2 = 0;
                    end
                end
                // next_row = row + 1;
                // next_count = count + 1;
                // if(!frames[count[3]][count[2:0]].valid || !frames[count[3]][count[2:0]].dirty) begin
                //     next_count = count + 1;
                // end
                // if(count == 5'b10000) next_state = COUNT;
            end
            FLUSH1 : begin
                cif.dWEN = 1;
                // if(row - 1 < 8) begin
                //     cif.daddr = {frames[0][row_trunc].tag, row_trunc, 3'b000};
                //     cif.dstore = frames[0][row_trunc].data[0];
                // end else begin
                //     cif.daddr = {frames[1][row_trunc].tag, row_trunc, 3'b000};
                //     cif.dstore = frames[1][row_trunc].data[0];
                // end
                if(count[3]) begin
                    cif.daddr = {frames[1][count[2:0]].tag, count[2:0], 3'b000};
                    cif.dstore = frames[1][count[2:0]].data[0];
                end else begin
                    cif.daddr = {frames[0][count[2:0]].tag, count[2:0], 3'b000};
                    cif.dstore = frames[0][count[2:0]].data[0];
                end
                // cif.daddr = {frames[count[3]][count[2:0]].tag, count[2:0], 3'b000};
                // cif.dstore = frames[count[3]][count[2:0]].data[0];

                if (~cif.dwait) next_state = FLUSH2;
            end
            FLUSH2 : begin
                cif.dWEN = 1;
                // if(row - 1 < 8) begin
                //     cif.daddr = {frames[0][row_trunc].tag, row_trunc, 3'b100};
                //     cif.dstore = frames[0][row_trunc].data[1];
                // end else begin
                //     cif.daddr = {frames[1][row_trunc].tag, row_trunc, 3'b100};
                //     cif.dstore = frames[1][row_trunc].data[1];
                // end
                if(count[3]) begin
                    cif.daddr = {frames[1][count[2:0]].tag, count[2:0], 3'b100};
                    cif.dstore = frames[1][count[2:0]].data[1];
                end else begin
                    cif.daddr = {frames[0][count[2:0]].tag, count[2:0], 3'b100};
                    cif.dstore = frames[0][count[2:0]].data[1];
                end
                // cif.daddr = {frames[count[3]][count[2:0]].tag, count[2:0], 3'b100};
                // cif.dstore = frames[count[3]][count[2:0]].data[1];
                
                if (~cif.dwait) begin
                    next_state = DIRTY;
                    next_count = count + 1;
                end
            end
            COUNT : begin
                cif.dWEN = 1;
                cif.daddr = 32'h00003100;
                cif.dstore = hit_count; 
                // next_flush = 1;
                if (~cif.dwait) next_flush = 1;
            end
            // HALT: dcif.flushed = 1;
            default: next_state = IDLE;
        endcase // state
    end

endmodule // dcache
