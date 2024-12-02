module registerbankmw(input             clk,
                      input             we,
                      input             reset,
                      input      [31:0] aluResultIN, memoryResIN,
                      input      [4:0]  rdAddrIN,
                      input      [31:0] pcPlus4IN,
                      input             RegWriteIN,
                      input      [1:0]  ResultSrcIN,
                      output reg [31:0] aluResultOUT, memoryResOUT,
                      output reg [4:0]  rdAddrOUT,
                      output reg [31:0] pcPlus4OUT,
                      output reg        RegWriteOUT,
                      output reg [1:0]  ResultSrcOUT);

  always @ (posedge clk)
    if (reset) begin
      aluResultOUT <= 32'b0;
      memoryResOUT <= 32'b0;
      rdAddrOUT <= 5'b0;
      pcPlus4OUT <= 32'b0;
      RegWriteOUT <= 1'b0;
      ResultSrcOUT <= 2'b0;
    end else if (we) begin
      aluResultOUT <= aluResultIN;
      memoryResOUT <= memoryResIN;
      rdAddrOUT <= rdAddrIN;
      pcPlus4OUT <= pcPlus4IN;
      RegWriteOUT <= RegWriteIN;
      ResultSrcOUT <= ResultSrcIN;
    end
endmodule