module Forward
(
    input MEMRegWrite_i,
    input [4:0] MEMRDaddr_i,
    input WBRegWrite_i,
    input [4:0] WBRDaddr_i,
    input [4:0] EXRS1addr_i,
    input [4:0] EXRS2addr_i,
    output reg [1:0] forwardA_o,
    output reg [1:0] forwardB_o
);

reg EXHazard1;
reg EXHazard2;
reg MEMHazard1;
reg MEMHazard2;

always @(*) begin
    EXHazard1 = (MEMRegWrite_i && MEMRDaddr_i && (MEMRDaddr_i == EXRS1addr_i)) ? 1'b1 : 1'b0;
    EXHazard2 = (MEMRegWrite_i && MEMRDaddr_i && (MEMRDaddr_i == EXRS2addr_i)) ? 1'b1 : 1'b0;
    MEMHazard1 = (WBRegWrite_i && WBRDaddr_i && !EXHazard1 && (WBRDaddr_i == EXRS1addr_i)) ? 1'b1 : 1'b0;
    MEMHazard2 = (WBRegWrite_i && WBRDaddr_i && !EXHazard2 && (WBRDaddr_i == EXRS2addr_i)) ? 1'b1 : 1'b0;

    forwardA_o = 2'b00;
    forwardB_o = 2'b00;
    if (EXHazard1) forwardA_o = 2'b10;
    if (EXHazard2) forwardB_o = 2'b10;
    if (MEMHazard1) forwardA_o = 2'b01;
    if (MEMHazard2) forwardB_o = 2'b01;
end

endmodule