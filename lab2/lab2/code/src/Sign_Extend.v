module Sign_Extend
(
    input [11:0] in_i,
    output [31:0] out_o
);

assign out_o = {{20{in_i[11]}}, in_i};

endmodule