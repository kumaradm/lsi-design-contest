`include "sreg_piso_9_bit.v"
`timescale 1ps / 1ps

module tb_sreg_piso_9_bit;

    // Testbench signals
    parameter WIDTH = 9;
    reg clk;                 // Clock signal
    reg rst;               // rst signal
    reg load;                // Load signal
    reg [WIDTH-1:0] in_parallel;   // 9-bit parallel input
    wire out_serial;         // Serial output

    // Instantiate the piso_shift_register module
    sreg_piso_9_bit uut (
        .clk(clk),               // Connect clk to uut's clk
        .rst(rst),           // Connect rst to uut's rst
        .load(load),             // Connect load to uut's load
        .in_parallel(in_parallel), // Connect in_parallel to uut's in_parallel
        .out_serial(out_serial)  // Connect out_serial to uut's out_serial
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;  // 100 MHz clock period
    end

    // Test procedure
    initial begin
        $dumpfile("tb_sreg_piso_9_bit.vcd");  // VCD file name
        $dumpvars(0, tb_sreg_piso_9_bit);
        
        // Initialize signals
        clk = 0;
        rst = 0;
        load = 0;
        in_parallel = 9'b0;

        // Apply rst
        rst = 1;
        #10 rst = 0;

        // Load parallel data into the shift register
        in_parallel = 9'b101010101; // Example parallel data
        load = 1;
        #10 load = 0;  // Load the data for one clock cycle

        // Shift the data out serially
        // #10;  // Wait 10 time units before checking the output
        // $display("Serial Output: %b", out_serial); // Display the first serial bit

        // // Shift through the bits one by one
        // repeat (9) begin
        //     #10; // Wait for next clock cycle
        //     $display("Serial Output: %b", out_serial); // Display the current serial bit
        // end

        // Test end
        $finish;
    end

endmodule