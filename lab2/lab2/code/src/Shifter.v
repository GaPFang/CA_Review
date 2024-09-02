module Shifter (
    input [31:0] immed_i,
    output [31:0] shifted_o
);

assign shifted_o = immed_i << 1;
    
endmodule