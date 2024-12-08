//file: qmult.v
`timescale 1ns / 1ps
// (Q,N) = (12,16) => 1 sign-bit + 3 integer-bits + 12 fractional-bits = 16 total-bits
//                    |S|III|FFFFFFFFFFFF|
// The same thing in A(I,F) format would be A(3,12)
module sig_comparator #(
	//Parameterized values
	parameter Q = 12,
	parameter N = 16
	)
	(
	 input			[N-1:0]	a,
	 input			[N-1:0]	b,
	 output         y    //output quantized to same number of bits as the input
	 );
	 
	 //	The underlying assumption, here, is that both fixed-point values are of the same length (N,Q)
	 //	Because of this, the results will be of length N+N = 2N bits
	 //	This also simplifies the hand-back of results, as the binimal point 
	 //	will always be in the same location
	
	wire [N-1:Q]	int_a;
    wire [N-1:Q]	int_b;
    wire [Q-1:0]	frac_a;
    wire [Q-1:0]	frac_b;
	
    assign int_a = a[N-1:Q];
    assign int_b = b[N-1:Q];
    assign frac_a = a[Q-1:0];
    assign frac_b = b[Q-1:0];
	assign y = (int_a[N-1]>int_b[N-1]) ? 0 : (int_a[N-1]!=int_b[N-1]) ? 1 : (int_a[N-2:Q]>int_b[N-2:Q]) ? 1 : (int_a[N-2:Q]!=int_b[N-2:Q]) ? 0 : (frac_a>frac_b) ? 1 : 0;

endmodule