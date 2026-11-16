module extend (input [15:0] instruction, output [11:0] target, output [15:0] imm);

    assign target = instruction[11:0];
    assign imm = {8'b00000000, instruction[7:0]};
endmodule

