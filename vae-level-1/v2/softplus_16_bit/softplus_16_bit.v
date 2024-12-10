`include "../softplus_16_bit/sig_comparator.v"
`include "../multiplier_fixed_point_16_bit/multiplier_fixed_point_16_bit.v"

module softplus_16_bit
#(parameter
    N = 16,
    Q = 12,

    STATE_0 = 1'h0,
    STATE_1 = 1'h1,

    abscissas_1 = 16'b1010000000000000,
    abscissas_2 = 16'b1011100000000000,
    abscissas_3 = 16'b1101000000000000,
    abscissas_4 = 16'b1110100000000000,
    abscissas_5 = 16'b0000000000000000,
    abscissas_6 = 16'b0001100000000000,
    abscissas_7 = 16'b0011000000000000,
    abscissas_8 = 16'b0100100000000000,
    abscissas_9 = 16'b0110000000000000,

    slope_1 = 16'b0000000000010111,
    slope_2 = 16'b0000000001100110,
    slope_3 = 16'b0000000110100001,
    slope_4 = 16'b0000010100111110,
    slope_5 = 16'b0000101011000001,
    slope_6 = 16'b0000111001011110,
    slope_7 = 16'b0000111110011001,
    slope_8 = 16'b0000111111101000,

    intersect_1 = 16'b0000000010010110,
    intersect_2 = 16'b0000000111111010,
    intersect_3 = 16'b0000010110101010,
    intersect_4 = 16'b0000101100010111,
    intersect_5 = 16'b0000101100010111,
    intersect_6 = 16'b0000010110101010,
    intersect_7 = 16'b0000000111111010,
    intersect_8 = 16'b0000000010010110
)
(
    input clk, start,
    input [N-1:0] x,
    output [N-1:0] y
);
    reg state;
    wire nextState;
    wire seg_1, seg_2, seg_3, seg_4, seg_5, seg_6, seg_7, seg_8, seg_9;
    wire [N-1:0] slope, intersect, res_mult;
    
    sig_comparator #(.N(N)) s9
    (
        .a(x),
        .b(abscissas_9),
        .y(seg_9)
    );

    sig_comparator #(.N(N)) s8
    (
        .a(x),
        .b(abscissas_8),
        .y(seg_8)
    );

    sig_comparator #(.N(N)) s7
    (
        .a(x),
        .b(abscissas_7),
        .y(seg_7)
    );
    
    sig_comparator #(.N(N)) s6
    (
        .a(x),
        .b(abscissas_6),
        .y(seg_6)
    );

    sig_comparator #(.N(N)) s5
    (
        .a(x),
        .b(abscissas_5),
        .y(seg_5)
    );
    
    sig_comparator #(.N(N)) s4
    (
        .a(x),
        .b(abscissas_4),
        .y(seg_4)
    );

    sig_comparator #(.N(N)) s3
    (
        .a(x),
        .b(abscissas_3),
        .y(seg_3)
    );

    sig_comparator #(.N(N)) s2
    (
        .a(x),
        .b(abscissas_2),
        .y(seg_2)
    );

    sig_comparator #(.N(N)) s1
    (
        .a(x),
        .b(abscissas_1),
        .y(seg_1)
    );

    multiplier_fixed_point_16_bit #(.N(N), .Q(Q)) m1
    (
        .clk(clk),
        .start(start),
        .a(slope),
        .b(x),
        .q_result(res_mult)
    );

    always @(posedge clk) begin
        if (start) begin
            state <= STATE_0;
        end else begin
            state <= nextState;
        end
    end
    assign nextState = (state==STATE_0) ? STATE_1 : state;
    assign slope = (state!=STATE_0) ? slope : seg_9 ? 16'b0000000000000000 : seg_8 ? slope_8 : seg_7 ? slope_7 : seg_6 ? slope_6 : seg_5 ? slope_5 : seg_4 ? slope_4 : seg_3 ? slope_3 : seg_2 ? slope_2 : seg_1 ? slope_1 : 16'b0000000000000000;
    assign intersect = (state!=STATE_0) ? intersect : seg_9 ? 16'b0001000000000000 : seg_8 ? intersect_8 : seg_7 ? intersect_7 : seg_6 ? intersect_6 : seg_5 ? intersect_5 : seg_4 ? intersect_4 : seg_3 ? intersect_3 : seg_2 ? intersect_2 : seg_1 ? intersect_1 : 16'b0000000000000000;
    assign y = (state==STATE_1) ? res_mult + intersect : y;
endmodule