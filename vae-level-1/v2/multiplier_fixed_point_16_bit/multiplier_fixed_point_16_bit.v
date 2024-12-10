`timescale 1ns / 1ps
module multiplier_fixed_point_16_bit
#(parameter 
	Q = 12,
	N = 16,
	STATE_0 = 2'h0,
	STATE_1 = 2'h1
	)
	(
	 input clk, start,
	 input [N-1:0]	a,
	 input [N-1:0]	b,
	 output [N-1:0] q_result,    
     output overflow, busy
	 );
	
	reg [1:0] state;
	wire [1:0] nextState;
	wire [2*N-1:0]	f_result;
	wire [N-1:0]   multiplicand;
	wire [N-1:0]    multiplier;
	wire [N-1:0]    a_2cmp, b_2cmp;
	wire [N-2:0]    quantized_result,quantized_result_2cmp;
	
	always @(posedge clk) begin
		if (start) begin
			state <= STATE_0;
		end else begin
			state <= nextState;
		end
	end
	assign nextState = (state==STATE_0) ? STATE_1 : state;
	assign busy = (state==STATE_0) ? 1 : 0;
 	assign f_result = (state==STATE_0) ? multiplicand[N-2:0] * multiplier[N-2:0] : f_result; //We remove the sign bit for multiplication
	assign a_2cmp = (state==STATE_0) ? {a[N-1],{(N-1){1'b1}} - a[N-2:0]+ 1'b1} : a_2cmp;  //2's complement of a
	assign b_2cmp = (state==STATE_0) ? {b[N-1],{(N-1){1'b1}} - b[N-2:0]+ 1'b1} : b_2cmp;  //2's complement of b
    assign multiplicand = (state!=STATE_0) ? multiplicand : (a[N-1]) ? a_2cmp : a;
    assign multiplier = (state!=STATE_0) ? multiplier : (b[N-1]) ? b_2cmp : b;
	
    assign overflow = (state!=STATE_1) ? overflow : (f_result[2*N-2:N-1+Q] > 0) ? 1'b1 : 1'b0;
    assign quantized_result = (state!=STATE_1) ? quantized_result : f_result[N-2+Q:Q];
    assign quantized_result_2cmp = (state!=STATE_1) ? quantized_result_2cmp : {(N-1){1'b1}} - quantized_result[N-2:0] + 1'b1;
    assign q_result[N-1] = (state!=STATE_1) ? q_result[N-1] : (a==1'b0 | b==1'b0) ? 1'b0 : a[N-1]^b[N-1];
	assign q_result[N-2:0] = (state!=STATE_1) ? q_result[N-2:0] : (q_result[N-1]) ? quantized_result_2cmp : quantized_result;
endmodule