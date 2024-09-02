module MUX4 
(
    input [31:0] a_i,
    input [31:0] b_i,
    input [31:0] c_i,
    input [31:0] d_i,
    input [1:0] ctl_i,
    output [31:0] out_o
);

assign out_o = ctl_i[1] ? (ctl_i[0] ? d_i : c_i) : (ctl_i[0] ? b_i : a_i);

endmodule