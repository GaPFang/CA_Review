module Control
(
    input [6:0] opcode_i,
    output [1:0] ALUOp_o,
    output ALUSrc_o,
    output RegWrite_o
);

assign ALUOp_o = opcode_i[5] ? 2'b10 : 2'b01;
assign ALUSrc_o = opcode_i[5] ? 1'b0 : 1'b1;
assign RegWrite_o = 1'b1;

endmodule