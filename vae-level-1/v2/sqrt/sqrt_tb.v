`timescale 1ns/1ps
`include "sqrt.v"

module sqrt_tb();

    parameter CLK_PERIOD = 10;
    parameter WIDTH = 16;
    parameter FBITS = 8;
    parameter SF = 2.0**-8.0;  // Q8.8 scaling factor is 2^-8

    reg clk;
    reg start;              // start signal
    wire busy;              // calculation in progress
    wire valid;             // root and rem are valid
    reg [WIDTH-1:0] rad;    // radicand
    wire [WIDTH-1:0] root;  // root
    wire [WIDTH-1:0] rem;   // remainder

    // Intermediate variables for monitoring
    real rad_real;
    real root_real;

    sqrt #(.WIDTH(WIDTH), .FBITS(FBITS)) sqrt_inst (
        .clk(clk),
        .start(start),
        .busy(busy),
        .valid(valid),
        .rad(rad),
        .root(root),
        .rem(rem)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    // Continuous assignments for monitoring
    always @(*) begin
        rad_real = rad * SF;
        root_real = root * SF;
    end

    initial begin
        $dumpfile("sqrt_tb.vcd");
        $dumpvars(0, sqrt_tb);

        $monitor("\t%d:\tsqrt(%f) = %b (%f) (rem = %b) (V=%b)",
                    $time, rad_real, root, root_real, rem, valid);
    end

    initial begin
        clk = 1;
        start = 0;

        #100    rad = 16'b1110_1000_1001_0000;  // 232.56250000
                start = 1;
        #10     start = 0;

        #120    rad = 16'b0000_0000_0100_0000;  // 0.25
                start = 1;
        #10     start = 0;

        #120    rad = 16'b0000_0010_0000_0000;  // 2.0
                start = 1;
        #10     start = 0;

        #120    $finish;
    end
endmodule