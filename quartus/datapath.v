module datapath(input         clk, reset,
                input  [1:0]  ResultSrc, 
                input         PCSrc, ALUSrc,
                input         RegWrite,
                input  [1:0]  ImmSrc,
                input  [2:0]  ALUControl,
                output        Zero,
                output [31:0] PC,
                input  [31:0] Instr,
                output [31:0] ALUResult, WriteData,
                input  [31:0] ReadData);

  // instruction fetch

  wire [31:0] PCF, PCNextF, PCPlus4F;
  assign PC = PCF;

  adder          pcadd4(PCF, 32'd4, PCPlus4F);
  mux2 #(32)     pcmux(PCPlus4F, PCTargetE, PCSrc, PCNextF);
  flopr #(32)    pcreg(clk, reset, PCNextF, PCF); 

  wire [31:0] InstrD, PCD, PCPlus4D;
  registerbankfd rfd(clk, 1'b1, 1'b0, InstrF, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);

  // instruction decode

  wire [31:0] ImmExtD, rs1D, rs2D;

  regfile     rf(clk, RegWrite, InstrD[19:15], InstrD[24:20], 
                 rdAddrW, ResultW, rs1D, rs2D);
  extend      ext(InstrD[31:7], ImmSrc, ImmExtD);

  wire [4:0]  rdAddrE;
  wire [31:0] rs1E, rs2E, PCE, ImmExtE, PCPlus4E;
  registerbankde rde(clk, 1'b1, 1'b0, rs1D, rs2D, PCD, InstrD[11:7], ImmExtD, PCPlus4D, rs1E, rs2E, PCE, rdAddrE, ImmExtE, PCPlus4E);

  // instruction execution

  wire [31:0] PCTargetE, SrcBE, ALUResultE;

  mux2 #(32)  srcbmux(rs2E, ImmExtE, ALUSrc, SrcBE);
  alu         alu(rs1E, SrcBE, ALUControl, ALUResultE, Zero);
  adder       pcaddbranch(PCE, ImmExtE, PCTargetE);
 
 
  wire [4:0]  rdAddrM;
  wire [31:0] rs2M, ALUResultM, PCPlus4M;
  registerbankem rem(clk, 1'b1, 1'b0, ALUResultE, rs2E, rdAddrE, PCPlus4E, ALUResultM, rs2M, rdAddrM, PCPlus4M);

  // memory access

  wire [31:0] ReadDataM;
  assign ALUResult = ALUResultM;
  assign WriteData = rs2M;
  assign ReadDataM = ReadData;

  wire [4:0]  rdAddrW;
  wire [31:0] ReadDataW, ALUResultW, PCPlus4W;
  registerbankmw rmw(clk, 1'b1, 1'b0, ALUResultM, ReadDataM, rdAddrM, PCPlus4M, ALUResultW, ReadDataW, rdAddrW, PCPlus4W);
  
  wire [31:0] ResultW;
  mux3 #(32)  resultmux(ALUResultW, ReadDataW, PCPlus4W, ResultSrc, ResultW);

endmodule