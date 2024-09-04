module ALU
(
    input signed [31:0] a_i,
    input signed [31:0] b_i,
    input [2:0] ctl_i,
    output reg [31:0] data_o
);

always @(*) begin
    case (ctl_i)
        3'b000: data_o = a_i & b_i;
        3'b001: data_o = a_i ^ b_i;
        3'b010: data_o = a_i << b_i;
        3'b011: data_o = a_i + b_i;
        3'b100: data_o = a_i - b_i;
        3'b101: data_o = a_i * b_i;
        3'b110: data_o = a_i >>> {{27'b0}, {b_i[4:0]}};
    endcase
end

endmodule