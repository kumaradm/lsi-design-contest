`include "softplus_16_bit.v"
// `timescale 1ns / 1ns

module tb_softplus_16_bit();
    parameter N=16, Q=12;
    reg [N-1:0] x;
    
    wire [N-1:0] y;

    softplus8 #(.N(N), .Q(Q)) comp1
    (
        .x(x),
        .y(y)
    );

    initial begin
        $dumpfile("tb_softplus_16_bit.vcd");
        $dumpvars(0, tb_softplus_16_bit);
        x = 16'b1010000000000000;
        #10;
        $display("%0b", y);
        x = 16'b1011100000000000;
        #10;
        $display("%0b", y);
        x = 16'b1101000000000000;
        #10;
        $display("%0b", y);
        x = 16'b1110100000000000;
        #10;
        $display("%0b", y);
        x = 16'b0000000000000000;
        #10;
        $display("%0b", y);
        x = 16'b0001100000000000;
        #10;
        $display("%0b", y);
        x = 16'b0011000000000000;
        #10;
        $display("%0b", y);
        x = 16'b0100100000000000;
        #10;
        $display("%0b", y);
        x = 16'b0110000000000000;
        #10;
        $display("%0b", y);
    end
endmodule