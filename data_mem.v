module data_mem (input Clock, we, input [11:0] addr, input [15:0] wdata, output [15:0] rdata);

    reg [15:0] mem [0:4095];
    integer i;
    initial
        for (i = 0; i < 4096; i = i + 1)
            mem[i] = 0;
    assign rdata = mem[addr];
    always @(posedge Clock)
        if (we)
            mem[addr] <= wdata;
endmodule

