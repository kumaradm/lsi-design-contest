`include "encoder.v"

module tb_encoder();
    parameter N = 9;
    parameter WIDTH = 16;
    reg clk, rst;
    reg [N-1:0] in;
    wire [WIDTH-1:0] a1, a2;

    encoder #() en
    (
        .clk(clk),
        .rst(rst),
        .in(in),
        .a1(a1),
        .a2(a2)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_encoder.vcd");
        $dumpvars(0, tb_encoder);
        rst = 1;
        clk = 0;
        #10;
        in = 9'b111101111;
        rst = 0;
        #300;
        $display("%0b", a1);
        $display("%0b", a2);
        #10 $finish;
    end
endmodule