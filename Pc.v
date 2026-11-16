module Pc (input [11:0] D, input Clock, Resetn, enable, output reg [11:0] Q);

    always @(negedge Resetn, posedge Clock)
        if (!Resetn)
            Q <= 0;
        else if (enable)
            Q <= D;

endmodule

