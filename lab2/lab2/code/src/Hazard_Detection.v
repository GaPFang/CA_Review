module Hazard_Detection
(
    input EXMemRead_i,
    input [4:0] EXRDaddr_i,
    input [4:0] RS1addr_i,
    input [4:0] RS2addr_i,
    output reg noOp_o,
    output reg Stall_o,
    output reg PCWrite_o
);

always @(*) begin
    Stall_o = 1'b0;
    if (EXMemRead_i) begin
        Stall_o = (EXRDaddr_i == RS1addr_i || EXRDaddr_i == RS2addr_i) ? 1'b1 : 1'b0;
    end
    noOp_o = Stall_o;
    PCWrite_o = Stall_o ? 1'b0 : 1'b1;
end


endmodule