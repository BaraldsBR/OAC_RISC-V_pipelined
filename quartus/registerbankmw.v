module registerbankmw(input             clk,
                      input             we,
                      input             reset,
                      input      [31:0] aluResultIN,
                      input      [31:0] memoryResIN,
                      input      [4:0]  rdAddrIN,
                      input      [31:0] pcPlus4IN,
                      output reg [31:0] aluResultOUT,
                      output reg [31:0] memoryResOUT,
                      output reg [4:0]  rdAddrOUT,
                      output reg [31:0] pcPlus4OUT);

  always @ (posedge reset)
    begin
      aluResultOUT <= 32'b0;
      memoryResOUT <= 32'b0;
      rdAddrOUT <= 5'b0;
      pcPlus4OUT <= 32'b0;
    end

  always @ (posedge clk)
    if (we && ~reset) begin
      aluResultOUT <= aluResultIN;
      memoryResOUT <= memoryResIN;
      rdAddrOUT <= rdAddrIN;
      pcPlus4OUT <= pcPlus4IN;
    end
endmodule