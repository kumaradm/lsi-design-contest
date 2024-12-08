module adder_9x16_bit
#(parameter WIDTH=16)(
    input [WIDTH-1:0] in1, in2, in3, in4, in5, in6, in7, in8, in9,
    output [WIDTH-1:0] out
);

assign out = in1 + in2 + in3 + in4 + in5 + in6 + in7 + in8 + in9;

endmodule