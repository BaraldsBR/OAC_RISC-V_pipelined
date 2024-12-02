module hazardunit (
    input         isLoading, takenBranch,
    input   [4:0] rs1D, rs2D, rdE,
    output        stallF, stallD, flushD, flushE
);

    wire lwStall = (rs1D === rdE || rs2D === rdE) && isLoading;

    assign stallF = lwStall;
    assign stallD = lwStall;
    assign flushD = takenBranch;
    assign flushE = takenBranch | lwStall;

endmodule