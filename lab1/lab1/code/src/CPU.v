module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

Control Control(
    .opcode_i(Instruction_Memory.instr_o[6:0])
);

Adder Add_PC(
    .a_i(PC.pc_o),
    .b_i(32'd4)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(Add_PC.sum_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(Instruction_Memory.instr_o[19:15]),
    .RS2addr_i(Instruction_Memory.instr_o[24:20]),
    .RDaddr_i(Instruction_Memory.instr_o[11:7]),
    .RDdata_i(ALU.result_o),
    .RegWrite_i(Control.RegWrite_o)
);

MUX32 MUX_ALUSrc(
    .a_i(Registers.RS2data_o),
    .b_i(Sign_Extend.out_o),
    .ctl_i(Control.ALUSrc_o)
);

Sign_Extend Sign_Extend(
    .in_i(Instruction_Memory.instr_o[31:20])
);
  
ALU ALU(
    .a_i(Registers.RS1data_o),
    .b_i(MUX_ALUSrc.out_o),
    .ctl_i(ALU_Control.ctl_o)
);

ALU_Control ALU_Control(
    .func7_i(Instruction_Memory.instr_o[31:25]),
    .func3_i(Instruction_Memory.instr_o[14:12]),
    .op_i(Control.ALUOp_o)
);

endmodule

