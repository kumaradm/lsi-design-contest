`include "adder_9x16_bit.v"
`timescale 1ps / 1ps

module tb_adder_9x16_bit();
    parameter WIDTH=16;
    reg [WIDTH-1:0] in1, in2, in3, in4, in5, in6, in7, in8, in9;
    wire [WIDTH-1:0] out;

    adder_9x16_bit #(.WIDTH(WIDTH), .WIDTH(WIDTH)) adder
    (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .in9(in9),
        .out(out)
    );

    initial begin
        $dumpfile("tb_adder_9x16_bit.vcd");
        $dumpvars(0, tb_adder_9x16_bit);
        in1 = 16'b0001000000000000;
        in2 = 16'b0001000000000000;
        in3 = 16'b0001000000000000;
        in4 = 16'b0001000000000000;
        in5 = 16'b0001000000000000;
        in6 = 16'b0001000000000000;
        in7 = 16'b0001000000000000;
        in8 = 16'b0001000000000000;
        in9 = 16'b0001000000000000;
        #10;
    end
endmodule