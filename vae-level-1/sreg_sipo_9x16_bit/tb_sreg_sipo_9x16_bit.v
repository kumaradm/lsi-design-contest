`include "sreg_sipo_9x16_bit.v"
`timescale 1ps / 1ps

module tb_sreg_sipo_9x16_bit;

    // Testbench signals
    parameter N_IN = 9;
    parameter WIDTH = 16;
    reg clk;
    reg rst;
    reg load;
    reg [WIDTH-1:0] in_serial;
    reg [N_IN*WIDTH-1:0] in_parallel;
    wire [N_IN*WIDTH-1:0] out_parallel;

    // Instantiate the SIPO shift register module
    sreg_sipo_9x16_bit uut (
        .clk(clk),
        .rst(rst),
        .in_serial(in_serial),
        .load(load),
        .out_parallel(out_parallel)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Clock period of 10 time units
    end

    // Test procedure
    initial begin
        $dumpfile("tb_sreg_sipo_9x16_bit.vcd");  // VCD file name
        $dumpvars(0, tb_sreg_sipo_9x16_bit);
        // Initialize signals
        clk = 0;
        rst = 1;
        load = 0;
        in_serial = 16'b0;

        #10 rst = 0;

        // Shift in serial data
        #10 in_serial = 16'b1;  // Shift in a bit (1)
        #10 in_serial = 16'b0;  // Shift in a bit (0)
        #10 in_serial = 16'b1;  // Shift in a bit (1)
        #10 in_serial = 16'b0;  // Shift in a bit (0)
        #10 in_serial = 16'b1;  // Shift in a bit (0)
        #10 in_serial = 16'b0;  // Shift in a bit (0)
        #10 in_serial = 16'b0;  // Shift in a bit (0)
        #10 in_serial = 16'b1;  // Shift in a bit (0)
        #10 in_serial = 16'b0;  // Shift in a bit (0)

        #10 load = 1;
        // Finish simulation
        #10 $finish;
    end
endmodule
