module registerbankfd(input             clk,
                      input             we,
                      input             reset,
                      input      [31:0] instructionIN,
                      input      [31:0] pcIN,
                      input      [31:0] pcPlus4IN,
                      output reg [31:0] instructionOUT,
                      output reg [31:0] pcOUT,
                      output reg [31:0] pcPlus4OUT);

  always @ (posedge clk)
    if (reset) begin
      pcOUT <= 32'b0;
      instructionOUT <= 32'b0;
      pcPlus4OUT <= 32'b0;
    end else if (we) begin
      pcOUT <= pcIN;
      instructionOUT <= instructionIN;
      pcPlus4OUT <= pcPlus4IN;
    end
endmodule