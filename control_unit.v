module control_unit (input [3:0] opcode,  input acc_zero, output reg reg_write, output reg reg_dst, output reg reg_sel,        
                     output reg [2:0] alu_op, output reg [1:0] wb_sel, output reg mem_write, output reg [1:0] addr_sel,
                     output reg data_sel, output reg [1:0] pc_sel, output reg [1:0] sp_mode, output reg halt);

    always @(opcode, acc_zero) begin
        reg_write = 0;  reg_dst = 0;  reg_sel = 0;  alu_op = 0;  wb_sel = 0;
        mem_write = 0;  addr_sel = 0; data_sel = 0; pc_sel = 0;  sp_mode = 0;   
        halt = 0;

        case (opcode)
            0:  begin reg_write = 1; reg_dst = 1; wb_sel = 1; addr_sel = 0; end      // LD
            1:  begin mem_write = 1; data_sel = 0; addr_sel = 0; end                 // ST
            2:  begin reg_write = 1; reg_dst = 0; reg_sel = 1; alu_op = 6; wb_sel = 0; end     // MOV
            3:  begin reg_write = 1; reg_sel = 0; reg_dst = 1; alu_op = 0; wb_sel = 0; end     // ADD
            4:  begin reg_write = 1; reg_sel = 0; reg_dst = 1; alu_op = 1; wb_sel = 0; end     // SUB
            5:  begin reg_write = 1; reg_sel = 0; reg_dst = 1; alu_op = 2; wb_sel = 0; end     // MUL
            6:  begin reg_write = 1; reg_sel = 0;reg_dst = 1; alu_op = 3; wb_sel = 0; end      // AND
            7:  begin reg_write = 1; reg_sel = 0; reg_dst = 1; alu_op = 4; wb_sel = 0; end     // OR
            8:  begin reg_write = 1; reg_sel = 0; reg_dst = 1; alu_op = 5; wb_sel = 0; end     // NOT
            9:  begin pc_sel = 1; end                          // JMP
            10: begin if (acc_zero)  pc_sel = 1; end           // JZ
            11: begin if (!acc_zero) pc_sel = 1; end           // JNZ
            12: begin mem_write = 1; addr_sel = 1; data_sel = 1; pc_sel = 1; sp_mode = 1; end  // CALL  
            13: begin addr_sel = 2; pc_sel = 2; sp_mode = 2; end       // RET
            14: begin reg_write = 1; wb_sel = 2; reg_dst = 0; end      // LDI
            15: begin halt = 1; end                                    // HALT
            default: halt = 1;
        endcase
    end
endmodule

