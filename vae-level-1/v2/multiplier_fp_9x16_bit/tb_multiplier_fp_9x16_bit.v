`include "multiplier_fp_9x16_bit.v"

module tb_multiplier_fp_9x16_bit();
    parameter N=16;
    reg clk, start;
    reg [N-1:0] a1, a2, a3, a4, a5, a6, a7, a8, a9;
    reg [N-1:0] b1, b2, b3, b4, b5, b6, b7, b8, b9;
    wire [N-1:0] o1, o2, o3, o4, o5, o6, o7, o8, o9;
    wire busy;

    multiplier_fp_9x16_bit #() mult
    (
        .clk(clk),
        .start(start),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .a8(a8),
        .a9(a9),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .b4(b4),
        .b5(b5),
        .b6(b6),
        .b7(b7),
        .b8(b8),
        .b9(b9),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .o5(o5),
        .o6(o6),
        .o7(o7),
        .o8(o8),
        .o9(o9),
        .busy(busy)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_multiplier_fp_9x16_bit.vcd");
        $dumpvars(0, tb_multiplier_fp_9x16_bit);
        clk = 1;
        start = 1;
        
        a1 = 16'h3000;
        a2 = 16'h3000;
        a3 = 16'h3000;
        a4 = 16'h3000;
        a5 = 16'h3000;
        a6 = 16'h3000;
        a7 = 16'h3000;
        a8 = 16'h3000;
        a9 = 16'h3000;
        b1 = 16'h2000;
        b2 = 16'h2000;
        b3 = 16'h2000;
        b4 = 16'h2000;
        b5 = 16'h2000;
        b6 = 16'h2000;
        b7 = 16'h2000;
        b8 = 16'h2000;
        b9 = 16'h2000;

        #5 start = 0;
        #5 start = 1;
        a1 = 16'h1000;
        a2 = 16'h1000;
        a3 = 16'h1000;
        a4 = 16'h1000;
        a5 = 16'h1000;
        a6 = 16'h1000;
        a7 = 16'h1000;
        a8 = 16'h1000;
        a9 = 16'h1000;
        b1 = 16'h2000;
        b2 = 16'h2000;
        b3 = 16'h2000;
        b4 = 16'h2000;
        b5 = 16'h2000;
        b6 = 16'h2000;
        b7 = 16'h2000;
        b8 = 16'h2000;
        b9 = 16'h2000;
        #10 start=0;
        #10 $finish;
    end
endmodule