module hazardunit (
    input         isLoading,
    input   [4:0] rs1D, rs2D, rdE,
    output        stallF, stallD, flushE
);

    wire lwStall = (rs1D === rdE || rs2D === rdE) && isLoading;

    assign stallF = lwStall;
    assign stallD = lwStall;
    assign flushE = lwStall;

endmodule