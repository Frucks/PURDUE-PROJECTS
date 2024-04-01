`include "cpu_types_pkg.vh"

module icache (
  input CLK, nRST,
  datapath_cache_if.icache dcif,
  caches_if.icache cif
);

import cpu_types_pkg::*;

typedef enum logic {COMPARE, ALLOCATE} state_t;

icachef_t addr;
icache_frame [15:0] I_Cache;
icache_frame nxt_frame;
state_t state, nxt_state;

assign addr.tag = dcif.imemaddr[31:6];
assign addr.idx = dcif.imemaddr[5:2];
assign addr.bytoff = dcif.imemaddr[1:0];

always_ff @(posedge CLK, negedge nRST) begin
  if (!nRST) begin
    I_Cache <= '0;
    state <= COMPARE;
  end
  else begin
    I_Cache[addr.idx] <= nxt_frame;
    state <= nxt_state;
  end
end

always_comb begin
  dcif.ihit = 0;
  dcif.imemload = '0;
  cif.iREN = 0;
  cif.iaddr = '0;
  nxt_frame = I_Cache[addr.idx];
  nxt_state = COMPARE;
  casez (state)
    COMPARE : begin if (I_Cache[addr.idx].valid && (I_Cache[addr.idx].tag == addr.tag)) begin dcif.ihit = 1; dcif.imemload = I_Cache[addr.idx].data; nxt_state = COMPARE; end else nxt_state = ALLOCATE; end
    ALLOCATE : begin cif.iREN = 1; cif.iaddr = addr; if (!cif.iwait) begin nxt_frame.valid = 1; nxt_frame.tag = addr.tag; nxt_frame.data = cif.iload; nxt_state = COMPARE; end else  nxt_state = ALLOCATE; end
    default: begin nxt_state = COMPARE; dcif.ihit = 0; dcif.imemload = '0; cif.iREN = 0; cif.iaddr = '0; nxt_frame = I_Cache[addr.idx]; end
  endcase
end

endmodule