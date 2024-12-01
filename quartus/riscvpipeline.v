module riscvpipeline(input          clk, reset,
                     output  [31:0] PC,
                     input   [31:0] Instr,
                     output         MemWrite,
                     output  [31:0] ALUResult, WriteData,
                     input   [31:0] ReadData);

  wire       ALUSrc, RegWrite, Jump, Branch, MemWriteD;
  wire [1:0] ResultSrc, ImmSrc;
  wire [2:0] ALUControl;
  
  wire [6:0] op;
  wire [2:0] funct3;
  wire       funct7b5;

  controller c(op, funct3, funct7b5,
               RegWrite, ResultSrc, MemWriteD,
               Jump, Branch,
               ALUControl, ALUSrc, ImmSrc);

  datapath   dp(clk, reset, ResultSrc,
                MemWriteD, ALUSrc,
                RegWrite, ImmSrc,
                ALUControl, Jump,
                Branch, PC, Instr,
                op, funct3, funct7b5,
                ALUResult, WriteData,
                MemWrite, ReadData);
endmodule