`include "multiplier_fixed_point_16_bit.v"
`timescale 1ps / 1ps

module tb_multiplier_fixed_point_16_bit();
    parameter N=16, Q=12;
    reg [N-1:0] x1, x2;
    
    wire [N-1:0] y;
    wire of;

    multiplier_fixed_point_16_bit #(.N(N), .Q(Q)) comp1
    (
        .a(x1),
        .b(x2),
        .q_result(y),
        .overflow(of)
    );

    initial begin
        $dumpfile("tb_multiplier_fixed_point_16_bit.vcd");
        $dumpvars(0, tb_multiplier_fixed_point_16_bit);
        x1 = 16'b0001000000000000;
        x2 = 16'b0001000000000000;
        #10;
    end
endmodule