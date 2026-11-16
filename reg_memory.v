module reg_memory (input Clock, Resetn, we, input [3:0] ws, rs1, rs2, input [15:0] wd, output [15:0] rd1, rd2, acc);

    reg [15:0] R [0:8];   
    integer i;
    assign rd1 = (rs1 <= 8) ? R[rs1] : 16'd0;
    assign rd2 = (rs2 <= 8) ? R[rs2] : 16'd0;
    assign acc = R[8];
    always @(negedge Resetn, posedge Clock)
        if (!Resetn) begin
            for (i = 0; i < 9; i = i + 1)
                R[i] <= 0;
        end
        else if (we && ws <= 8)
            R[ws] <= wd;

endmodule

