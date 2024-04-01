/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "IF_ID_if.vh"
`include "ID_EX_if.vh"
`include "EX_MEM_if.vh"
`include "MEM_WB_if.vh"
`include "hazard_unit_if.vh"
`include "forwarding_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  // iterfaces
  control_unit_if cuif();
  register_file_if rfif();
  alu_if aluif();
  IF_ID_if ifif();
  ID_EX_if idif();
  EX_MEM_if exif();
  MEM_WB_if memif();
  hazard_unit_if huif();
  forwarding_unit_if fuif();

  // calling all modules
  control_unit CTRL(cuif);
  register_file REG(CLK, nRST, rfif);
  alu ALU(aluif);
  IF_ID IFID(CLK, nRST, ifif);
  ID_EX IDEX(CLK, nRST, idif);
  EX_MEM EXMEM(CLK, nRST, exif);
  MEM_WB MEMWB(CLK, nRST, memif);
  hazard_unit HZRD (huif);
  forwarding_unit FRWD (fuif);

  typedef enum logic [1:0] {NH = 2'b00, NS = 2'b01, TH = 2'b10, TS = 2'b11} state_t;
  word_t sign_extended, branchAddr, jumpAddr;
  logic halt;
  logic flush;
  state_t state;
  word_t currPC;
  logic [17:0] nxtBTB;
  logic [7:0] branchPC; //INDEX = (NPC - 4)[9:2]
  logic [15:0] branchTarget; //INPUT
  logic [255:0] [17:0] BTB; // BTB[INDEX] = {16'bTARGET, 2'bSTATE}
  word_t currPCFETCH;
  logic [7:0] branchPCFETCH; //INDEX = (NPC - 4)[9:2]
  logic [1:0] PCsrc;
  word_t PC, new_PC, next_PC;
  logic PCEN;
  logic ihit;

  assign ihit = (dpif.ihit && !(exif.MemWr_out || exif.MemRead_out));

  //2 BIT SATURATING BRANCH TARGET BUFFER
  assign currPC = ((exif.next_PC_out - 4) >> 2);
  assign branchPC = currPC[7:0];
  assign branchTarget = exif.instruction_out[15:0];

  always_comb begin
    PCsrc = 0;
    nxtBTB = 0;
    state = TH;
    if (exif.instruction_out[31:26] == BEQ) begin
      if (exif.zero_out) begin
        PCsrc = (exif.taken_out) ? 0 : 'd1; //1 = NEED TO BRANCH
        state = (BTB[branchPC][1:0]) ? TH : NS;
        nxtBTB = {branchTarget, state};
      end
      else begin
        PCsrc = (exif.taken_out) ? 'd2 : 0; //2 = SHOULD NOT HAVE BRANCHED
        state = (BTB[branchPC][1:0] == TH) ? TS : NH;
        nxtBTB = {branchTarget, state};
      end
    end
    else if (exif.instruction_out[31:26] == BNE) begin
      if (!exif.zero_out) begin
        PCsrc = (exif.taken_out) ? 0 : 'd1; //1 = NEED TO BRANCH
        state = (BTB[branchPC][1:0]) ? TH : NS;
        nxtBTB = {branchTarget, state};
      end
      else begin
        PCsrc = (exif.taken_out) ? 'd2 : 0; //2 = SHOULD NOT HAVE BRANCHED
        state = (BTB[branchPC][1:0] == TH) ? TS : NH;
        nxtBTB = {branchTarget, state};
      end
    end
  end

  always_ff @(posedge CLK, negedge nRST) begin
  if(!nRST) begin
    BTB <= '0;
  end else begin
    BTB[branchPC] <= nxtBTB;
  end
  end

  assign flush = PCsrc || exif.jumpR_out;
  // IF_ID Reg
  assign ifif.IF_ID_en = ihit && !huif.stall && !(halt || cuif.halt);
  assign ifif.instruction_in = dpif.imemload;
  assign ifif.rs_in = dpif.imemload[25:21];
  assign ifif.rt_in = dpif.imemload[20:16];
  assign ifif.rd_in = dpif.imemload[15:11];
  assign ifif.next_PC_in = next_PC;
  assign ifif.flush = flush || (cuif.jump && ihit);

  // ID_EX Reg
  assign idif.ID_EX_en = ihit;
  assign idif.instruction_in = ifif.instruction_out;
  assign idif.rs_in = ifif.rs_out;
  assign idif.rt_in = ifif.rt_out;
  assign idif.rd_in = ifif.rd_out;
  assign idif.sign_extended_in = sign_extended;
  assign idif.next_PC_in = ifif.next_PC_out;
  assign idif.rdat1_in = (cuif.jumpAL) ? ifif.next_PC_out : rfif.rdat1;
  assign idif.rdat2_in = rfif.rdat2;
  assign idif.flush = flush;
  assign idif.ALUsrc_in = cuif.ALUsrc;
  assign idif.MemWr_in = cuif.MemWr;
  assign idif.MemRead_in = cuif.MemRead;
  assign idif.RegWr_in = cuif.RegWr;
  assign idif.LUI_flag_in = cuif.LUI_flag;
  assign idif.halt_in = cuif.halt;
  assign idif.MemtoReg_in = cuif.MemtoReg;
  assign idif.RegDst_in = cuif.RegDst;
  assign idif.aluop_in = cuif.aluop;
  assign idif.stall = huif.stall;
  assign idif.jumpAL_in = cuif.jumpAL;
  assign idif.jumpR_in = cuif.jumpR;
  assign idif.taken_in = ifif.taken_out;

  // EX_MEM Register
  assign exif.EX_MEM_en = (ihit || dpif.dhit);
  assign exif.instruction_in = idif.instruction_out;
  assign exif.sign_extended_in = idif.sign_extended_out;
  assign exif.next_PC_in = idif.next_PC_out;
  assign exif.rdat2_in = fuif.forwarded_B;
  assign exif.port_out_in = aluif.port_out;
  assign exif.zero_in = aluif.zero;
  assign exif.flush = flush;
  assign exif.MemWr_in = idif.MemWr_out;
  assign exif.MemRead_in = idif.MemRead_out;
  assign exif.RegWr_in = idif.RegWr_out;
  assign exif.halt_in = idif.halt_out;
  assign exif.MemtoReg_in = idif.MemtoReg_out;
  assign exif.dhit = dpif.dhit;
  assign exif.dest_reg_in = (idif.RegDst_out) ? idif.rd_out : ((idif.jumpAL_out) ? 5'd31 : idif.rt_out);
  assign exif.jumpR_in = idif.jumpR_out;
  assign exif.taken_in = idif.taken_out;

  // MEM_WB Register
  assign memif.instruction_in = exif.instruction_out;
  assign memif.next_PC_in = exif.next_PC_out;
  assign memif.port_out_in = exif.port_out_out;
  assign memif.dmemload_in = (dpif.dhit) ? dpif.dmemload : memif.dmemload_out;
  assign memif.MEM_WB_en = exif.EX_MEM_en;
  assign memif.RegWr_in = exif.RegWr_out;
  assign memif.halt_in = exif.halt_out;
  assign memif.MemtoReg_in = exif.MemtoReg_out;
  assign memif.dest_reg_in = exif.dest_reg_out;

  // Register File
  assign rfif.rsel1 = ifif.rs_out;
  assign rfif.rsel2 = (cuif.jumpAL || cuif.jumpR) ? '0 : ifif.rt_out;
  assign rfif.wsel = memif.dest_reg_out;
  assign rfif.WEN = memif.RegWr_out;
  assign rfif.wdat = (memif.MemtoReg_out) ? memif.dmemload_out : memif.port_out_out;

  // ALU
  assign aluif.port_a = (idif.LUI_flag_out) ? 32'd16 : fuif.forwarded_A;
  assign aluif.port_b = (idif.ALUsrc_out) ? idif.sign_extended_out : fuif.forwarded_B;
  assign aluif.aluop = idif.aluop_out;

  // Control Unit
  assign cuif.instruction = ifif.instruction_out;

  // Program Counter
  assign PCEN = (ihit && !huif.stall && !(halt || cuif.halt)) || flush || cuif.jump;
  assign branchAddr = exif.next_PC_out + (exif.sign_extended_out << 2);
  assign jumpAddr = {ifif.next_PC_out[31:28], (ifif.instruction_out[25:0] << 2)};
  assign currPCFETCH = PC >> 2;
  assign branchPCFETCH = currPCFETCH[7:0];
  always_comb begin
    new_PC = next_PC;
    ifif.taken_in = 0;
    if (PCsrc == 'd1) begin
      new_PC = branchAddr;
    end
    else if (PCsrc == 'd2) begin
      new_PC = exif.next_PC_out;
    end
    else if (cuif.jump) begin
      new_PC = jumpAddr;
    end
    else if (exif.jumpR_out) begin
      new_PC = exif.port_out_out;
    end
    else if (BTB[branchPCFETCH][1]) begin
      new_PC = next_PC + (32'($signed(ifif.instruction_in[15:0])) << 2);
      ifif.taken_in = 1;
    end
  end

  always_ff @(posedge CLK, negedge nRST) begin
    if(!nRST) begin
      PC <= '0;
    end else if(PCEN) begin
      PC <= new_PC;
    end
  end

assign next_PC = PC + 4;
  
  // Cache inputs 
  assign dpif.imemREN = 1;
  assign dpif.dmemREN = exif.MemRead_out;
  assign dpif.dmemWEN = exif.MemWr_out;
  assign dpif.dmemaddr = exif.port_out_out;
  assign dpif.imemaddr = PC;
  assign dpif.dmemstore = exif.rdat2_out;

  // Hazard Unit Inputs
  assign huif.id_rt = idif.rt_out;
  assign huif.id_memRead = idif.MemRead_out;
  assign huif.if_rs = ifif.rs_out;
  assign huif.if_rt = ifif.rt_out;

  // Forwarding Unit
  assign fuif.ex_dest = exif.dest_reg_out;
  assign fuif.mem_dest = memif.dest_reg_out;
  assign fuif.id_rs = idif.rs_out;
  assign fuif.id_rt = idif.rt_out;
  assign fuif.ex_regWrite = exif.RegWr_out;
  assign fuif.mem_regWrite = memif.RegWr_out;
  assign fuif.wdat = rfif.wdat;
  assign fuif.port_out_out = exif.port_out_out;
  assign fuif.rdat1_out = idif.rdat1_out;
  assign fuif.rdat2_out = idif.rdat2_out;

  //Sign Extend Logic
  assign sign_extended = (cuif.ExtOp) ? {16'd0, ifif.instruction_out[15:0]} : 32'($signed(ifif.instruction_out[15:0]));

  always_ff @(posedge CLK, negedge nRST) begin
    if(~nRST) begin
      dpif.halt <= 0;
    end else begin 
      dpif.halt <= memif.halt_out || dpif.halt;
    end
  end

  always_ff @(posedge CLK, negedge nRST) begin
    if (!nRST) begin
      halt <= 0;
    end
    else if (exif.flush) begin
      halt <= 0;
    end
    else begin
      halt <= cuif.halt || halt;
    end
  end

endmodule