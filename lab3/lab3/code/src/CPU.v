module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

MUX2 MUX_PCSrc1 (
    .a_i(Adder_PC.sum_o),
    .b_i(Adder_branch.sum_o),
    .ctl_i(branch_predictor.predict_o && Control.Branch_o)
);

MUX2 MUX_PCSrc2 (
    .a_i(MUX_PCSrc1.out_o),
    .b_i(ID_EX.resetPC_o),
    .ctl_i(branch_predictor.reset_o)
);

Adder Adder_PC(
    .a_i(PC.pc_o),
    .b_i(32'd4)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(Hazard_Detection.PCWrite_o),
    .pc_i(MUX_PCSrc2.out_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o)
);

IF_ID IF_ID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(Instruction_Memory.instr_o),
    .pc_i(PC.pc_o),
    .flush_i(branch_predictor.IFIDFlush_o),
    .stall_i(Hazard_Detection.Stall_o)
);

Control Control(
    .opcode_i(IF_ID.instr_o[6:0]),
    .noOp_i(Hazard_Detection.noOp_o)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(IF_ID.instr_o[19:15]),
    .RS2addr_i(IF_ID.instr_o[24:20]),
    .RDaddr_i(MEM_WB.RDaddr_o),
    .RDdata_i(MUX_WB.out_o),
    .RegWrite_i(MEM_WB.RegWrite_o)
);

Shifter Shifter(
    .immed_i(Sign_Extend.out_o)
);

Adder Adder_branch(
    .a_i(IF_ID.pc_o),
    .b_i(Shifter.shifted_o)
);

Adder Adder_notBranch(
    .a_i(IF_ID.pc_o),
    .b_i(32'd4)
);

MUX2 MUX_resetPC(
    .a_i(Adder_branch.sum_o),
    .b_i(Adder_notBranch.sum_o),
    .ctl_i(branch_predictor.predict_o)
);

Sign_Extend Sign_Extend(
    .in_i(IF_ID.instr_o)
);

ID_EX ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush_i(branch_predictor.IDEXFlush_o),
    .RegWrite_i(Control.RegWrite_o),
    .MemToReg_i(Control.MemToReg_o),
    .MemRead_i(Control.MemRead_o),
    .MemWrite_i(Control.MemWrite_o),
    .ALUOp_i(Control.ALUOp_o),
    .ALUSrc_i(Control.ALUSrc_o),
    .Branch_i(Control.Branch_o),
    .RS1data_i(Registers.RS1data_o),
    .RS2data_i(Registers.RS2data_o),
    .immed_i(Sign_Extend.out_o),
    .func7_i(IF_ID.instr_o[31:25]),
    .func3_i(IF_ID.instr_o[14:12]),
    .RS1addr_i(IF_ID.instr_o[19:15]),
    .RS2addr_i(IF_ID.instr_o[24:20]),
    .RDaddr_i(IF_ID.instr_o[11:7]),
    .resetPC_i(MUX_resetPC.out_o)
);

MUX4 MUX_A (
    .a_i(ID_EX.RS1data_o),
    .b_i(MUX_WB.out_o),
    .c_i(EX_MEM.ALUResult_o),
    .ctl_i(Forward.forwardA_o)
);

MUX4 MUX_B (
    .a_i(ID_EX.RS2data_o),
    .b_i(MUX_WB.out_o),
    .c_i(EX_MEM.ALUResult_o),
    .ctl_i(Forward.forwardB_o)
);

MUX2 MUX_ALUSrc(
    .a_i(MUX_B.out_o),
    .b_i(ID_EX.immed_o),
    .ctl_i(ID_EX.ALUSrc_o)
);
  
ALU ALU(
    .a_i(MUX_A.out_o),
    .b_i(MUX_ALUSrc.out_o),
    .ctl_i(ALU_Control.ctl_o)
);

ALU_Control ALU_Control(
    .func7_i(ID_EX.func7_o),
    .func3_i(ID_EX.func3_o),
    .op_i(ID_EX.ALUOp_o)
);

EX_MEM EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(ID_EX.RegWrite_o),
    .MemToReg_i(ID_EX.MemToReg_o),
    .MemRead_i(ID_EX.MemRead_o),
    .MemWrite_i(ID_EX.MemWrite_o),
    .ALUResult_i(ALU.data_o),
    .MemWriteData_i(MUX_B.out_o),
    .RDaddr_i(ID_EX.RDaddr_o)
);

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(EX_MEM.ALUResult_o),
    .MemRead_i(EX_MEM.MemRead_o),
    .MemWrite_i(EX_MEM.MemWrite_o),
    .data_i(EX_MEM.MemWriteData_o)
);

MEM_WB MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(EX_MEM.RegWrite_o),
    .MemToReg_i(EX_MEM.MemToReg_o),
    .ALUResult_i(EX_MEM.ALUResult_o),
    .MemReadData_i(Data_Memory.data_o),
    .RDaddr_i(EX_MEM.RDaddr_o)
);

MUX2 MUX_WB(
    .a_i(MEM_WB.ALUResult_o),
    .b_i(MEM_WB.MemReadData_o),
    .ctl_i(MEM_WB.MemToReg_o)
);

Forward Forward(
    .MEMRegWrite_i(EX_MEM.RegWrite_o),
    .MEMRDaddr_i(EX_MEM.RDaddr_o),
    .WBRegWrite_i(MEM_WB.RegWrite_o),
    .WBRDaddr_i(MEM_WB.RDaddr_o),
    .EXRS1addr_i(ID_EX.RS1addr_o),
    .EXRS2addr_i(ID_EX.RS2addr_o)
);

Hazard_Detection Hazard_Detection(
    .EXMemRead_i(ID_EX.MemRead_o),
    .EXRDaddr_i(ID_EX.RDaddr_o),
    .RS1addr_i(IF_ID.instr_o[19:15]),
    .RS2addr_i(IF_ID.instr_o[24:20])
);

branch_predictor branch_predictor(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .IDBranch_i(Control.Branch_o),
    .EXBranch_i(ID_EX.Branch_o),
    .EXALUData_i(ALU.data_o)
);

endmodule

