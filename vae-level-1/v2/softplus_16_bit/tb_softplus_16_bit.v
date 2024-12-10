`include "softplus_16_bit.v"
`timescale 1ns / 1ns

module tb_softplus_16_bit();
    parameter N=16, Q=12;
    reg clk, start;
    reg [N-1:0] x;
    
    wire [N-1:0] y;

    softplus_16_bit #(.N(N), .Q(Q)) comp1
    (
        .clk(clk),
        .start(start),
        .x(x),
        .y(y)
    );
    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_softplus_16_bit.vcd");
        $dumpvars(0, tb_softplus_16_bit);
        start = 1;
        clk = 0;
        x = 16'b0010000000000000;
        #10;
        start = 0;
        #100;
        $display("%0b", y);
        #10 $finish;
    end
endmodule