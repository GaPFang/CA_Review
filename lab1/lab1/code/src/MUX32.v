module MUX32 
(
    input [31:0] a_i,
    input [31:0] b_i,
    input ctl_i,
    output [31:0] out_o
);

assign out_o = ctl_i ? b_i : a_i;

endmodule