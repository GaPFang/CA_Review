module Control
(
    input [6:0] opcode_i,
    input noOp_i,
    output reg RegWrite_o,
    output reg MemToReg_o,
    output reg MemRead_o,
    output reg MemWrite_o,
    output reg [1:0] ALUOp_o,
    output reg ALUSrc_o,
    output reg Branch_o
);

always @(*) begin
    RegWrite_o <= 1'b0;
    MemToReg_o <= 1'b0;
    MemRead_o <= 1'b0;
    MemWrite_o <= 1'b0;
    ALUOp_o <= 2'b00;
    ALUSrc_o <= 1'b0;
    Branch_o <= 1'b0;
    if (!noOp_i) begin
        if (opcode_i[4:0] == 5'b10011) begin
            RegWrite_o <= 1'b1;
            MemToReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b0;
            ALUOp_o <= (opcode_i[6:5] == 2'b01) ? 2'b10 : 2'b11;
            ALUSrc_o <= (opcode_i[6:5] == 2'b01) ? 1'b0 : 1'b1;
            Branch_o <= 1'b0;
        end
        if (opcode_i == 7'b0000011) begin
            RegWrite_o <= 1'b1;
            MemToReg_o <= 1'b1;
            MemRead_o <= 1'b1;
            MemWrite_o <= 1'b0;
            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1'b1;
            Branch_o <= 1'b0;
        end
        if (opcode_i == 7'b0100011) begin
            RegWrite_o <= 1'b0;
            MemToReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b1;
            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1'b1;
            Branch_o <= 1'b0;
        end
        if (opcode_i == 7'b1100011) begin
            RegWrite_o <= 1'b0;
            MemToReg_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b0;
            ALUOp_o <= 2'b01;
            ALUSrc_o <= 1'b0;
            Branch_o <= 1'b1;
        end
    end
end

endmodule