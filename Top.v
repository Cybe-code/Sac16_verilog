module Top (input Clock, Resetn, input [15:0] inst, output [11:0] pc, output halt);

    wire [11:0] pc_plus1, pc_next, target, dmem_addr, sp, sp_next;
    wire [15:0] rd1, rd2, acc, alu_b, alu_y, imm, wd;
    wire [15:0] dmem_rdata, dmem_wdata;
    wire [3:0]  ws;
    wire [2:0]  alu_op;
    wire [1:0]  wb_sel, addr_sel, pc_sel, sp_mode;
    wire reg_write, reg_dst, reg_sel, mem_write, data_sel, acc_zero;

    assign pc_plus1 = pc + 1;
    assign pc_next  = (pc_sel == 0) ? pc_plus1 :
                      (pc_sel == 1) ? target :
                                      dmem_rdata[11:0];  
    Pc A1 (.D(pc_next), .Clock(Clock), .Resetn(Resetn),
             .enable(~halt), .Q(pc));

    assign acc_zero = (acc == 0);
    control_unit B2 (.opcode(inst[15:12]), .acc_zero(acc_zero),
                       .reg_write(reg_write), .reg_dst(reg_dst), .reg_sel(reg_sel),
                       .alu_op(alu_op), .wb_sel(wb_sel), .mem_write(mem_write),
                       .addr_sel(addr_sel), .data_sel(data_sel),
                       .pc_sel(pc_sel), .sp_mode(sp_mode), .halt(halt));

    extend C3 (.instruction(inst), .target(target), .imm(imm));

    assign ws = reg_dst ? 4'd8 : inst[11:8];               
    assign wd = (wb_sel == 0) ? alu_y :                     
                (wb_sel == 1) ? dmem_rdata :
                                imm;
    reg_memory D4 (.Clock(Clock), .Resetn(Resetn), .we(reg_write),
                     .ws(ws), .rs1(inst[11:8]), .rs2(inst[7:4]), .wd(wd),
                     .rd1(rd1), .rd2(rd2), .acc(acc));

    assign alu_b = reg_sel ? rd2 : rd1;
    Alu E5 (.Op(alu_op), .ACC(acc), .Reg(alu_b), .R(alu_y));

    Sp F6 (.Clock(Clock), .Resetn(Resetn), .sp_mode(sp_mode),
             .sp(sp), .sp_next(sp_next));

    assign dmem_addr  = (addr_sel == 0) ? target :        
                        (addr_sel == 1) ? sp :
                                          sp_next;
    assign dmem_wdata = data_sel ? {4'b0000, pc_plus1} : acc;
    data_mem G7 (.Clock(Clock), .we(mem_write), .addr(dmem_addr),
                     .wdata(dmem_wdata), .rdata(dmem_rdata));
endmodule
