module ALU_Control
(
    input [6:0] func7_i,
    input [2:0] func3_i,
    input [1:0] op_i,
    output reg [2:0] ctl_o
);

// and: 000
// xor: 001
// sll: 010
// add, addi, lw, sw: 011
// sub, beq: 100
// mul: 101
// srai: 110

initial begin
    ctl_o = 3'b000;
end

always @(*) begin
    if (op_i == 2'b10) begin
        if (func3_i == 3'b111) begin
            ctl_o = 3'b000;
        end
        if (func3_i == 3'b100) begin
            ctl_o = 3'b001;
        end
        if (func3_i == 3'b001) begin
            ctl_o = 3'b010;
        end
        if (func3_i == 3'b000) begin
            if (func7_i == 7'b0) begin
                ctl_o = 3'b011;
            end
            if (func7_i == 7'd32) begin
                ctl_o = 3'b100;
            end
            if (func7_i == 7'b1) begin
                ctl_o = 3'b101;
            end
        end
    end 
    if (op_i == 2'b11) begin
        if (func3_i == 3'b000) begin
            ctl_o = 3'b011;
        end
        if (func3_i == 3'b101) begin
            ctl_o = 3'b110;
        end
    end
    if (op_i == 2'b00) begin
        ctl_o = 3'b011;
    end
end


endmodule