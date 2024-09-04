module MEM_WB (
    input clk_i,
    input rst_i,
    input RegWrite_i,
    input MemToReg_i,
    input [31:0] ALUResult_i,
    input [31:0] MemReadData_i,
    input [4:0] RDaddr_i,
    output reg RegWrite_o,
    output reg MemToReg_o,
    output reg [31:0] ALUResult_o,
    output reg [31:0] MemReadData_o,
    output reg [4:0] RDaddr_o
);

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        RegWrite_o <= 1'b0;
        MemToReg_o <= 1'b0;
        ALUResult_o <= 32'b0;
        MemReadData_o <= 32'b0;
        RDaddr_o <= 5'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemToReg_o <= MemToReg_i;
        ALUResult_o <= ALUResult_i;
        MemReadData_o <= MemReadData_i;
        RDaddr_o <= RDaddr_i;
    end
end
    
endmodule