module forwardingunit (
    input         RegWriteM, RegWriteW,
    input  [4:0]  rs1E, rs2E, rdM, rdW,
    output [1:0]  forwardAE, forwardBE
);

    assign forwardAE = (rs1E === rdM && rs1E !== 5'b0 && RegWriteM) ? 2'b01 :
                       (rs1E === rdW && rs1E !== 5'b0 && RegWriteW) ? 2'b10 :
                       2'b00;

    assign forwardBE = (rs2E === rdM && rs2E !== 5'b0 && RegWriteM) ? 2'b01 :
                       (rs2E === rdW && rs2E !== 5'b0 && RegWriteW) ? 2'b10 :
                       2'b00;

endmodule