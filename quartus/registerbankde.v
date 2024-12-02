module registerbankde(input             clk,
                      input             we,
                      input             reset,
                      input      [31:0] rs1IN, rs2IN, pcIN,
                      input      [4:0]  rdAddrIN,
                      input      [31:0] immExtIN, pcPlus4IN,
                      input             RegWriteIN, MemWriteIN, JumpIN, BranchIN, ALUSrcIN,
                      input      [1:0]  ResultSrcIN,
                      input      [2:0]  ALUControlIN,
                      input      [4:0]  rs1AddrIN, rs2AddrIN,
                      output reg [31:0] rs1OUT, rs2OUT, pcOUT,
                      output reg [4:0]  rdAddrOUT,
                      output reg [31:0] immExtOUT, pcPlus4OUT,
                      output reg        RegWriteOUT, MemWriteOUT, JumpOUT, BranchOUT, ALUSrcOUT,
                      output reg [1:0]  ResultSrcOUT,
                      output reg [2:0]  ALUControlOUT,
                      output reg [4:0]  rs1AddrOUT, rs2AddrOUT);

  always @ (posedge reset, posedge clk)
  begin
    if (reset) begin
      rs1OUT <= 32'b0;
      rs2OUT <= 32'b0;
      pcOUT <= 32'b0;
      rdAddrOUT <= 5'b0;
      immExtOUT <= 32'b0;
      pcPlus4OUT <= 32'b0;

      RegWriteOUT <= 1'b0;
      MemWriteOUT <= 1'b0;
      JumpOUT <= 1'b0;
      BranchOUT <= 1'b0;
      ALUSrcOUT <= 1'b0;
      ResultSrcOUT <= 2'b0;
      ALUControlOUT <= 3'b0;

      rs1AddrOUT <= 5'b0;
      rs2AddrOUT <= 5'b0;
    end else if (we) begin
      rs1OUT <= rs1IN;
      rs2OUT <= rs2IN;
      pcOUT <= pcIN;
      rdAddrOUT <= rdAddrIN;
      immExtOUT <= immExtIN;
      pcPlus4OUT <= pcPlus4IN;

      RegWriteOUT <= RegWriteIN;
      MemWriteOUT <= MemWriteIN;
      JumpOUT <= JumpIN;
      BranchOUT <= BranchIN;
      ALUSrcOUT <= ALUSrcIN;
      ResultSrcOUT <= ResultSrcIN;
      ALUControlOUT <= ALUControlIN;

      rs1AddrOUT <= rs1AddrIN;
      rs2AddrOUT <= rs2AddrIN;
    end
  end
endmodule