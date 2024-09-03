module Flush (
    input [31:0] RS1data_i,
    input [31:0] RS2data_i,
    input branch_i,
    output flush_o
);

assign flush_o = ((RS1data_i == RS2data_i) ? 1'b1 : 1'b0) && branch_i;
    
endmodule