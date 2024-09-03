module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;
wire ID_FlushIF = Flush.flush_o;

MUX2 MUX_PCSrc (
    .a_i(Adder_PC.sum_o),
    .b_i(Adder_branch.sum_o),
    .ctl_i(ID_FlushIF)
);

Adder Adder_PC(
    .a_i(PC.pc_o),
    .b_i(32'd4)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(Hazard_Detection.PCWrite_o),
    .pc_i(MUX_PCSrc.out_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o)
);

IFID IFID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(Instruction_Memory.instr_o),
    .pc_i(PC.pc_o),
    .flush_i(ID_FlushIF),
    .stall_i(Hazard_Detection.Stall_o)
);

Control Control(
    .opcode_i(IFID.instr_o[6:0]),
    .noOp_i(Hazard_Detection.noOp_o)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(IFID.instr_o[19:15]),
    .RS2addr_i(IFID.instr_o[24:20]),
    .RDaddr_i(MEMWB.RDaddr_o),
    .RDdata_i(MUX_WB.out_o),
    .RegWrite_i(MEMWB.RegWrite_o)
);

Flush Flush(
    .RS1data_i(Registers.RS1data_o),
    .RS2data_i(Registers.RS2data_o),
    .branch_i(Control.Branch_o)
);

Shifter Shifter(
    .immed_i(Sign_Extend.out_o)
);

Adder Adder_branch(
    .a_i(IFID.pc_o),
    .b_i(Shifter.shifted_o)
);

Sign_Extend Sign_Extend(
    .in_i(IFID.instr_o)
);

IDEX IDEX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(Control.RegWrite_o),
    .MemToReg_i(Control.MemToReg_o),
    .MemRead_i(Control.MemRead_o),
    .MemWrite_i(Control.MemWrite_o),
    .ALUOp_i(Control.ALUOp_o),
    .ALUSrc_i(Control.ALUSrc_o),
    .RS1data_i(Registers.RS1data_o),
    .RS2data_i(Registers.RS2data_o),
    .immed_i(Sign_Extend.out_o),
    .func7_i(IFID.instr_o[31:25]),
    .func3_i(IFID.instr_o[14:12]),
    .RS1addr_i(IFID.instr_o[19:15]),
    .RS2addr_i(IFID.instr_o[24:20]),
    .RDaddr_i(IFID.instr_o[11:7])
);

MUX4 MUX_A (
    .a_i(IDEX.RS1data_o),
    .b_i(MUX_WB.out_o),
    .c_i(EXMEM.ALUResult_o),
    .ctl_i(Forward.forwardA_o)
);

MUX4 MUX_B (
    .a_i(IDEX.RS2data_o),
    .b_i(MUX_WB.out_o),
    .c_i(EXMEM.ALUResult_o),
    .ctl_i(Forward.forwardB_o)
);

MUX2 MUX_ALUSrc(
    .a_i(MUX_B.out_o),
    .b_i(IDEX.immed_o),
    .ctl_i(IDEX.ALUSrc_o)
);
  
ALU ALU(
    .a_i(MUX_A.out_o),
    .b_i(MUX_ALUSrc.out_o),
    .ctl_i(ALU_Control.ctl_o)
);

ALU_Control ALU_Control(
    .func7_i(IDEX.func7_o),
    .func3_i(IDEX.func3_o),
    .op_i(IDEX.ALUOp_o)
);

EXMEM EXMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(IDEX.RegWrite_o),
    .MemToReg_i(IDEX.MemToReg_o),
    .MemRead_i(IDEX.MemRead_o),
    .MemWrite_i(IDEX.MemWrite_o),
    .ALUResult_i(ALU.result_o),
    .MemWriteData_i(MUX_B.out_o),
    .RDaddr_i(IDEX.RDaddr_o)
);

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(EXMEM.ALUResult_o),
    .MemRead_i(EXMEM.MemRead_o),
    .MemWrite_i(EXMEM.MemWrite_o),
    .data_i(EXMEM.MemWriteData_o)
);

MEMWB MEMWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(EXMEM.RegWrite_o),
    .MemToReg_i(EXMEM.MemToReg_o),
    .ALUResult_i(EXMEM.ALUResult_o),
    .MemReadData_i(Data_Memory.data_o),
    .RDaddr_i(EXMEM.RDaddr_o)
);

MUX2 MUX_WB(
    .a_i(MEMWB.ALUResult_o),
    .b_i(MEMWB.MemReadData_o),
    .ctl_i(MEMWB.MemToReg_o)
);

Forward Forward(
    .MEMRegWrite_i(EXMEM.RegWrite_o),
    .MEMRDaddr_i(EXMEM.RDaddr_o),
    .WBRegWrite_i(MEMWB.RegWrite_o),
    .WBRDaddr_i(MEMWB.RDaddr_o),
    .EXRS1addr_i(IDEX.RS1addr_o),
    .EXRS2addr_i(IDEX.RS2addr_o)
);

Hazard_Detection Hazard_Detection(
    .EXMemRead_i(IDEX.MemRead_o),
    .EXRDaddr_i(IDEX.RDaddr_o),
    .RS1addr_i(IFID.instr_o[19:15]),
    .RS2addr_i(IFID.instr_o[24:20])
);

endmodule

