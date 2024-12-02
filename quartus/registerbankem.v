module registerbankem(input             clk,
                      input             we,
                      input             reset,
                      input      [31:0] aluResultIN, writeDataIN,
                      input      [4:0]  rdAddrIN,
                      input      [31:0] pcPlus4IN,
                      input             RegWriteIN, MemWriteIN,
                      input      [1:0]  ResultSrcIN,
                      output reg [31:0] aluResultOUT, writeDataOUT,
                      output reg [4:0]  rdAddrOUT,
                      output reg [31:0] pcPlus4OUT,
                      output reg        RegWriteOUT, MemWriteOUT,
                      output reg [1:0]  ResultSrcOUT);

  always @ (posedge clk)
  begin
    if (reset) begin
      aluResultOUT <= 32'b0;
      writeDataOUT <= 32'b0;
      rdAddrOUT <= 5'b0;
      pcPlus4OUT <= 32'b0;
      RegWriteOUT <= 1'b0;
      MemWriteOUT <= 1'b0;
      ResultSrcOUT <= 2'b0;
    end else if (we) begin
      aluResultOUT <= aluResultIN;
      writeDataOUT <= writeDataIN;
      rdAddrOUT <= rdAddrIN;
      pcPlus4OUT <= pcPlus4IN;
      RegWriteOUT <= RegWriteIN;
      MemWriteOUT <= MemWriteIN;
      ResultSrcOUT <= ResultSrcIN;
    end
  end
endmodule