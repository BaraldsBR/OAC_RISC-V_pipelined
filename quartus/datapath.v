module datapath(input         clk, reset,
                input  [1:0]  ResultSrc,
                input         MemWriteD,
                input         ALUSrc,
                input         RegWrite,
                input  [1:0]  ImmSrc,
                input  [2:0]  ALUControl,
                input         Jump, Branch,
                output [31:0] PC,
                input  [31:0] Instr,
                output [6:0]  op,
                output [2:0]  funct3,
                output        funct7b5,
                output [31:0] ALUResult, WriteData,
                output        MemWriteM,
                input  [31:0] ReadData);

  // wires
  // IF
  wire [31:0]    PCF, PCNextF, PCPlus4F, InstrF;

  // ID
  wire [31:0]    InstrD, PCD, PCPlus4D;
  wire           RegWriteD, JumpD, BranchD, ALUSrcD;
  wire [1:0]     ResultSrcD, ImmSrcD;
  wire [2:0]     ALUControlD;
  wire [31:0]    ImmExtD, rs1D, rs2D;

  // EX
  wire           RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
  wire [1:0]     ResultSrcE;
  wire [2:0]     ALUControlE;
  wire [4:0]     rs1AddrE, rs2AddrE, rdAddrE;
  wire [31:0]    rs1E, rs2E, PCE, ImmExtE, PCPlus4E;
  wire [31:0]    fwdRs1E, fwdRs2E, PCTargetE, SrcBE, ALUResultE;
  wire           ZeroE, PCSrcE;
  wire [1:0]     forwardAE, forwardBE;

  // MEM
  wire           RegWriteM;
  wire [1:0]     ResultSrcM;
  wire [4:0]     rdAddrM;
  wire [31:0]    rs2M, ALUResultM, PCPlus4M;
  wire [31:0]    ReadDataM;

  // WB
  wire           RegWriteW;
  wire [1:0]     ResultSrcW;
  wire [4:0]     rdAddrW;
  wire [31:0]    ReadDataW, ALUResultW, PCPlus4W;
  wire [31:0]    ResultW;

  // components
  // instruction fetch

  assign         PC = PCF;
  assign         InstrF = Instr;

  adder          pcadd4(PCF, 32'd4, PCPlus4F);
  mux2 #(32)     pcmux(PCPlus4F, PCTargetE, PCSrcE, PCNextF);
  flopr #(32)    pcreg(clk, reset, PCNextF, PCF);

  registerbankfd rfd(clk, 1'b1, reset,
                     InstrF, PCF, PCPlus4F,
                     InstrD, PCD, PCPlus4D);

  // instruction decode

  assign         RegWriteD = RegWrite;
  assign         JumpD = Jump;
  assign         BranchD = Branch;
  assign         ALUSrcD = ALUSrc;
  assign         ResultSrcD = ResultSrc;
  assign         ImmSrcD = ImmSrc;
  assign         ALUControlD = ALUControl;

  assign         op = InstrD[6:0];
  assign         funct3 = InstrD[14:12];
  assign         funct7b5 = InstrD[30];

  regfile        rf(clk, RegWriteW, InstrD[19:15], InstrD[24:20], 
                    rdAddrW, ResultW, rs1D, rs2D);
  extend         ext(InstrD[31:7], ImmSrcD, ImmExtD);

  registerbankde rde(clk, 1'b1, reset,
                     rs1D, rs2D, PCD, InstrD[11:7], ImmExtD, PCPlus4D,
                     RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
                     ResultSrcD, ALUControlD,
                     InstrD[19:15], InstrD[24:20],
                     rs1E, rs2E, PCE, rdAddrE, ImmExtE, PCPlus4E,
                     RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
                     ResultSrcE, ALUControlE,
                     rs1AddrE, rs2AddrE);

  // instruction execution

  assign         PCSrcE = JumpE | (BranchE & ZeroE);

  forwardingunit fu(RegWriteM, RegWriteW,
                    rs1AddrE, rs2AddrE,
                    rdAddrM, rdAddrW,
                    forwardAE, forwardBE);

  mux3 #(32)     fwdA(rs1E, ALUResultM, ResultW, forwardAE, fwdRs1E);
  mux3 #(32)     fwdB(rs2E, ALUResultM, ResultW, forwardBE, fwdRs2E);
  mux2 #(32)     srcbmux(fwdRs2E, ImmExtE, ALUSrcE, SrcBE);
  alu            alu(fwdRs1E, SrcBE, ALUControlE, ALUResultE, ZeroE);
  adder          pcaddbranch(PCE, ImmExtE, PCTargetE);

  registerbankem rem(clk, 1'b1, reset,
                     ALUResultE, rs2E, rdAddrE, PCPlus4E,
                     RegWriteE, MemWriteE, ResultSrcE,
                     ALUResultM, rs2M, rdAddrM, PCPlus4M,
                     RegWriteM, MemWriteM, ResultSrcM);

  // memory access

  assign         ALUResult = ALUResultM;
  assign         WriteData = rs2M;
  assign         ReadDataM = ReadData;

  registerbankmw rmw(clk, 1'b1, reset,
                     ALUResultM, ReadDataM, rdAddrM, PCPlus4M,
                     RegWriteM, ResultSrcM,
                     ALUResultW, ReadDataW, rdAddrW, PCPlus4W,
                     RegWriteW, ResultSrcW);
  
  // write back

  mux3 #(32)     resultmux(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);

endmodule