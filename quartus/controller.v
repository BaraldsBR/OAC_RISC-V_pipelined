module controller(input  [6:0] op,
                  input  [2:0] funct3,
                  input        funct7b5,
                  output       RegWrite,
                  output [1:0] ResultSrc,
                  output       MemWrite,
                  output       Jump, Branch,
                  output [2:0] ALUControl,
                  output       ALUSrc,
                  output [1:0] ImmSrc);

  wire [1:0] ALUOp;

  maindec md(op, ResultSrc, MemWrite, Branch,
             ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
  aludec  ad(op[5], funct3, funct7b5, ALUOp, ALUControl);
endmodule