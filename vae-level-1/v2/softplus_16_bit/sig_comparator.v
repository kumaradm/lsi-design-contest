`timescale 1ns / 1ps

module sig_comparator #(
	parameter Q = 12,
	parameter N = 16
	)(
		input clk, rst,
		input [N-1:0] a, b, 
		output y
);
	
	wire [N-1:Q] int_a = a[N-1:Q];
    wire [N-1:Q] int_b = b[N-1:Q];
    wire [Q-1:0] frac_a = a[Q-1:0];
    wire [Q-1:0] frac_b = b[Q-1:0];
	
	assign y = (int_a[N-1]>int_b[N-1]) ? 0 : (int_a[N-1]!=int_b[N-1]) ? 1 : 
				(int_a[N-2:Q]>int_b[N-2:Q]) ? 1 : (int_a[N-2:Q]!=int_b[N-2:Q]) ? 0 : 
				(frac_a>frac_b) ? 1 : 0;
endmodule