module Sp (input Clock, Resetn, input [1:0] sp_mode, output reg [11:0] sp, output [11:0] sp_next);

    assign sp_next = sp + 1;
    always @(negedge Resetn, posedge Clock)
        if (!Resetn)
            sp <= 12'hFFF;         
        else if (sp_mode == 1)
            sp <= sp - 1;
        else if (sp_mode == 2)
            sp <= sp + 1;
endmodule
