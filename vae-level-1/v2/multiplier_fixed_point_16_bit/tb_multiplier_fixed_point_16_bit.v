`include "multiplier_fixed_point_16_bit.v"
`timescale 1ps / 1ps

module tb_multiplier_fixed_point_16_bit();
    parameter N=16, Q=12;
    reg [N-1:0] x1, x2;
    reg clk, start;
    
    wire [N-1:0] y;
    wire of;

    multiplier_fixed_point_16_bit #(.N(N), .Q(Q)) comp1
    (  
        .clk(clk),
        .start(start),
        .a(x1),
        .b(x2),
        .q_result(y),
        .overflow(of)
    );
    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_multiplier_fixed_point_16_bit.vcd");
        $dumpvars(0, tb_multiplier_fixed_point_16_bit);
        start = 1;
        clk = 0;
        x1 = 16'b0001000000000000;
        x2 = 16'b0011000000000110;
        #10;
        start = 0;
        #10;
        $display("result=%0b", y);
        #10 $finish;
    end
endmodule