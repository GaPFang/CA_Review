module ALU
(
    input signed [31:0] a_i,
    input signed [31:0] b_i,
    input [2:0] ctl_i,
    output reg [31:0] result_o
);

always @(*) begin
    case (ctl_i)
        3'b000: result_o = a_i & b_i;
        3'b001: result_o = a_i ^ b_i;
        3'b010: result_o = a_i << b_i;
        3'b011: result_o = a_i + b_i;
        3'b100: result_o = a_i - b_i;
        3'b101: result_o = a_i * b_i;
        3'b110: result_o = a_i >>> {{27'b0}, {b_i[4:0]}};
    endcase
end

endmodule