// `include "../multiplier_fixed_point_16_bit/multiplier_fixed_point_16_bit.v"

module multiplier_fp_9x16_bit
#(parameter
    Q = 12,
	N = 16
)
(
    input [N-1:0] a1, a2, a3, a4, a5, a6, a7, a8, a9,
    input [N-1:0] b1, b2, b3, b4, b5, b6, b7, b8, b9,
    input clk, start,
    output [N-1:0] o1, o2, o3, o4, o5, o6, o7, o8, o9,
    output busy
);
wire busy1, busy2, busy3, busy4, busy5, busy6, busy7, busy8, busy9;

multiplier_fixed_point_16_bit #() mult1
(
    .a(a1),
    .b(b1),
    .clk(clk),  
    .start(start),
    .busy(busy1),
    .q_result(o1)
);

    multiplier_fixed_point_16_bit #() mult2
    (
        .a(a2),
        .b(b2),
        .clk(clk),  
        .start(start),
        .busy(busy2),
        .q_result(o2)
    );

    multiplier_fixed_point_16_bit #() mult3
    (
        .a(a3),
        .b(b3),
        .clk(clk),  
        .start(start),
        .busy(busy3),
        .q_result(o3)
    );

    multiplier_fixed_point_16_bit #() mult4
    (
        .a(a4),
        .b(b4),
        .clk(clk),  
        .start(start),
        .busy(busy4),
        .q_result(o4)
    );

    multiplier_fixed_point_16_bit #() mult5
    (
        .a(a5),
        .b(b5),
        .clk(clk),  
        .start(start),
        .busy(busy5),
        .q_result(o5)
    );

    multiplier_fixed_point_16_bit #() mult6
    (
        .a(a6),
        .b(b6),
        .clk(clk),  
        .start(start),
        .busy(busy6),
        .q_result(o6)
    );

    multiplier_fixed_point_16_bit #() mult7
    (
        .a(a7),
        .b(b7),
        .clk(clk),  
        .start(start),
        .busy(busy7),
        .q_result(o7)
    );

    multiplier_fixed_point_16_bit #() mult8
    (
        .a(a8),
        .b(b8),
        .clk(clk),  
        .start(start),
        .busy(busy8),
        .q_result(o8)
    );

    multiplier_fixed_point_16_bit #() mult9
    (
        .a(a9),
        .b(b9),
        .clk(clk),  
        .start(start),
        .busy(busy9),
        .q_result(o9)
    );

    assign busy = busy1 | busy2 | busy3 | busy4 | busy5 | busy6 | busy7 | busy8 | busy9;
endmodule