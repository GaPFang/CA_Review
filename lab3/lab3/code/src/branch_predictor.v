module branch_predictor
(
    input clk_i,
    input rst_i,
    input IDBranch_i,
    input EXBranch_i,
    input [31:0] EXALUData_i,
    output reg predict_o,
    output reg IFIDFlush_o,
    output reg IDEXFlush_o,
    output reset_o
);

reg strong;
wire ans;

// initial begin
//     predict_o <= 0;
//     strong <= 1;
// end

assign ans = (EXALUData_i) ? 1'b0 : 1'b1;
assign reset_o = (ans != predict_o && EXBranch_i) ? 1'b1 : 1'b0;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        predict_o <= 1'b1;
        strong <= 1'b1;
    end
    else begin
        if (EXBranch_i) begin
            if (predict_o != ans) begin
                if (strong == 1'b1) begin
                    strong <= 1'b0;
                end else begin
                    predict_o <= ans;
                end
            end else begin
                strong <= 1'b1;
            end
        end
    end
end

always @(*) begin
    IFIDFlush_o = 1'b0;
    IDEXFlush_o = 1'b0;
    if (IDBranch_i) begin
        if (predict_o) begin
            IFIDFlush_o = 1'b1;
        end
    end
    if (EXBranch_i) begin
        if (predict_o != ans) begin
            IFIDFlush_o = 1'b1;
            if (ans) begin
                IDEXFlush_o = 1'b1;
            end
        end
    end
end

endmodule