module Alu (input [2:0] Op, input [15:0] ACC, Reg, output reg [15:0] R);

    always @(*)
        case (Op)
            0: R = ACC + Reg;
            1: R = ACC - Reg;
            2: R = ACC * Reg;    
            3: R = ACC & Reg;
            4: R = ACC | Reg;
            5: R = ~ACC;
            6: R = Reg;
            default: R = 16'd0;
        endcase
endmodule

