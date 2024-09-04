module EX_MEM (
    input clk_i,
    input rst_i,
    input RegWrite_i,
    input MemToReg_i,
    input MemRead_i,
    input MemWrite_i,
    input [31:0] ALUResult_i,
    input [31:0] MemWriteData_i,
    input [4:0] RDaddr_i,
    output reg RegWrite_o,
    output reg MemToReg_o,
    output reg MemRead_o,
    output reg MemWrite_o,
    output reg [31:0] ALUResult_o,
    output reg [31:0] MemWriteData_o,
    output reg [4:0] RDaddr_o
);

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        RegWrite_o <= 1'b0;
        MemToReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALUResult_o <= 32'b0;
        MemWriteData_o <= 32'b0;
        RDaddr_o <= 5'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemToReg_o <= MemToReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUResult_o <= ALUResult_i;
        MemWriteData_o <= MemWriteData_i;
        RDaddr_o <= RDaddr_i;
    end
end
    
endmodule