module Adder
(
    input [31:0] a_i,
    input [31:0] b_i,
    output [31:0] sum_o
);

assign sum_o = a_i + b_i;

endmodule