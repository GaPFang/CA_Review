module Sign_Extend
(
    input [31:0] in_i,
    output reg [31:0] out_o
);

always @(*) begin
    out_o = {{20{in_i[31]}}, in_i[31:20]};
    if (in_i[6:0] == 7'b0100011) begin
        out_o = {{20{in_i[31]}}, in_i[31:25], in_i[11:7]};
    end
    if (in_i[6:0] == 7'b1100011) begin
        out_o = {{20{in_i[31]}}, in_i[31], in_i[7], in_i[30:25], in_i[11:8]};
    end
end

endmodule