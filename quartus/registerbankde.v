module registerbankde(input             clk,
                      input             we,
                      input             reset,
                      input      [31:0] rs1IN,
                      input      [31:0] rs2IN,
                      input      [31:0] pcIN,
                      input      [4:0]  rdAddrIN,
                      input      [31:0] immExtIN,
                      input      [31:0] pcPlus4IN,
                      output reg [31:0] rs1OUT,
                      output reg [31:0] rs2OUT,
                      output reg [31:0] pcOUT,
                      output reg [4:0]  rdAddrOUT,
                      output reg [31:0] immExtOUT,
                      output reg [31:0] pcPlus4OUT);

  always @ (posedge reset)
  begin
    rs1OUT <= 32'b0;
    rs2OUT <= 32'b0;
    pcOUT <= 32'b0;
    rdAddrOUT <= 5'b0;
    immExtOUT <= 32'b0;
    pcPlus4OUT <= 32'b0;
  end

  always @ (posedge clk)
    if (we && ~reset) begin
      rs1OUT <= rs1IN;
      rs2OUT <= rs2IN;
      pcOUT <= pcIN;
      rdAddrOUT <= rdAddrIN;
      immExtOUT <= immExtIN;
      pcPlus4OUT <= pcPlus4IN;
    end
endmodule