`include "../sqrt/sqrt.v"
`include "../adder_9x16_bit/adder_9x16_bit.v"
// `include "../multiplier_fixed_point_16_bit/multiplier_fixed_point_16_bit.v"
`include "../softplus_16_bit/softplus_16_bit.v"

module encoder
#(parameter 
    WIDTH = 16,
    N_IN = 9,

    STATE_0 = 3'b000,
    STATE_1 = 3'b001,
    STATE_2 = 3'b010,
    STATE_3 = 3'b011,
    STATE_4 = 3'b100,
    STATE_5 = 3'b101,
    STATE_6 = 3'b110,
    STATE_7 = 3'b111,

    WEIGHT_MEAN_11 = 16'b0000000000111101,
    WEIGHT_MEAN_21 = 16'b1111111111101110,
    WEIGHT_MEAN_31 = 16'b1111111110111000,
    WEIGHT_MEAN_41 = 16'b0000000000000010,
    WEIGHT_MEAN_51 = 16'b1111111110111000,
    WEIGHT_MEAN_61 = 16'b0000000000110001,
    WEIGHT_MEAN_71 = 16'b1111101011011000,
    WEIGHT_MEAN_81 = 16'b0010000011010111,
    WEIGHT_MEAN_91 = 16'b0000001111110010,

    WEIGHT_VAR_11 = 16'b0000000011101000,
    WEIGHT_VAR_21 = 16'b1111111110100101,
    WEIGHT_VAR_31 = 16'b1111111110100110,
    WEIGHT_VAR_41 = 16'b0000000000101001,
    WEIGHT_VAR_51 = 16'b0000000001100001,
    WEIGHT_VAR_61 = 16'b1111111111000011,
    WEIGHT_VAR_71 = 16'b1111111010010110,
    WEIGHT_VAR_81 = 16'b1111111011011001,
    WEIGHT_VAR_91 = 16'b1111101001111001,

    BIAS_MEAN_1 = 16'b1111001000101101,
    BIAS_VAR_1 = 16'b1111000101100101,

    WEIGHT_MEAN_12 = 16'b1111111111101111,
    WEIGHT_MEAN_22 = 16'b0000000010010100,
    WEIGHT_MEAN_32 = 16'b1111111111110011,
    WEIGHT_MEAN_42 = 16'b0000000010010101,
    WEIGHT_MEAN_52 = 16'b1111111101100010,
    WEIGHT_MEAN_62 = 16'b0000000010010011,
    WEIGHT_MEAN_72 = 16'b0000011001010010,
    WEIGHT_MEAN_82 = 16'b1111110101100101,
    WEIGHT_MEAN_92 = 16'b0000100010011110,

    WEIGHT_VAR_12 = 16'b0000000010110010,
    WEIGHT_VAR_22 = 16'b1111111101100010,
    WEIGHT_VAR_32 = 16'b0000000010101111,
    WEIGHT_VAR_42 = 16'b1111111101101101,
    WEIGHT_VAR_52 = 16'b0000000101010010,
    WEIGHT_VAR_62 = 16'b1111111100111110,
    WEIGHT_VAR_72 = 16'b0000110111010100,
    WEIGHT_VAR_82 = 16'b0000001010101000,
    WEIGHT_VAR_92 = 16'b0000001010000101,

    BIAS_MEAN_2 = 16'b1111001000000011,
    BIAS_VAR_2 = 16'b1111010111111011,

    EPS_1 = 16'b0001001010111001,
    EPS_2 = 16'b1111010000101111
    )
    (
        input clk, rst,
        input [N_IN-1:0] in,
        output [WIDTH-1:0] a1, a2
);
    wire start;
    reg [2:0] state;
    wire [2:0] nextState;
    wire [WIDTH-1:0] in_pad_1 = {3'b000, in[0], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_2 = {3'b000, in[1], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_3 = {3'b000, in[2], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_4 = {3'b000, in[3], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_5 = {3'b000, in[4], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_6 = {3'b000, in[5], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_7 = {3'b000, in[6], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_8 = {3'b000, in[7], 12'b000000000000};
    wire [WIDTH-1:0] in_pad_9 = {3'b000, in[8], 12'b000000000000};
    wire [WIDTH-1:0] in_wc1_mult_1;
    wire [WIDTH-1:0] in_wc1_mult_2;
    wire [WIDTH-1:0] in_wc1_mult_3;
    wire [WIDTH-1:0] in_wc1_mult_4;
    wire [WIDTH-1:0] in_wc1_mult_5;
    wire [WIDTH-1:0] in_wc1_mult_6;
    wire [WIDTH-1:0] in_wc1_mult_7;
    wire [WIDTH-1:0] in_wc1_mult_8;
    wire [WIDTH-1:0] in_wc1_mult_9;
    wire [WIDTH-1:0] in_wd1_mult_1;
    wire [WIDTH-1:0] in_wd1_mult_2;
    wire [WIDTH-1:0] in_wd1_mult_3;
    wire [WIDTH-1:0] in_wd1_mult_4;
    wire [WIDTH-1:0] in_wd1_mult_5;
    wire [WIDTH-1:0] in_wd1_mult_6;
    wire [WIDTH-1:0] in_wd1_mult_7;
    wire [WIDTH-1:0] in_wd1_mult_8;
    wire [WIDTH-1:0] in_wd1_mult_9;

    wire [WIDTH-1:0] in_wc2_mult_1;
    wire [WIDTH-1:0] in_wc2_mult_2;
    wire [WIDTH-1:0] in_wc2_mult_3;
    wire [WIDTH-1:0] in_wc2_mult_4;
    wire [WIDTH-1:0] in_wc2_mult_5;
    wire [WIDTH-1:0] in_wc2_mult_6;
    wire [WIDTH-1:0] in_wc2_mult_7;
    wire [WIDTH-1:0] in_wc2_mult_8;
    wire [WIDTH-1:0] in_wc2_mult_9;
    wire [WIDTH-1:0] in_wd2_mult_1;
    wire [WIDTH-1:0] in_wd2_mult_2;
    wire [WIDTH-1:0] in_wd2_mult_3;
    wire [WIDTH-1:0] in_wd2_mult_4;
    wire [WIDTH-1:0] in_wd2_mult_5;
    wire [WIDTH-1:0] in_wd2_mult_6;
    wire [WIDTH-1:0] in_wd2_mult_7;
    wire [WIDTH-1:0] in_wd2_mult_8;
    wire [WIDTH-1:0] in_wd2_mult_9;

    wire [WIDTH-1:0] c1_temp;
    wire [WIDTH-1:0] d1_temp;
    wire [WIDTH-1:0] c2_temp;
    wire [WIDTH-1:0] d2_temp;
    wire [WIDTH-1:0] c1;
    wire [WIDTH-1:0] d1;
    wire [WIDTH-1:0] c2;
    wire [WIDTH-1:0] d2;
    wire [WIDTH-1:0] ad1;
    wire [WIDTH-1:0] ad2;
    wire [WIDTH-1:0] a1_sqrt;
    wire [WIDTH-1:0] a2_sqrt;
    wire [WIDTH-1:0] a1_mult;
    wire [WIDTH-1:0] a2_mult;
    
    wire [WIDTH-1:0] ad1_sqrt;
    wire [WIDTH-1:0] ad2_sqrt;

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_1
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_1),
        .b(WEIGHT_MEAN_11),
        .q_result(in_wc1_mult_1)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_2
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_2),
        .b(WEIGHT_MEAN_21),
        .q_result(in_wc1_mult_2)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_3
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_3),
        .b(WEIGHT_MEAN_31),
        .q_result(in_wc1_mult_3)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_4
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_4),
        .b(WEIGHT_MEAN_41),
        .q_result(in_wc1_mult_4)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_5
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_5),
        .b(WEIGHT_MEAN_51),
        .q_result(in_wc1_mult_5)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_6
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_6),
        .b(WEIGHT_MEAN_61),
        .q_result(in_wc1_mult_6)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_7
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_7),
        .b(WEIGHT_MEAN_71),
        .q_result(in_wc1_mult_7)
    );
    
    multiplier_fixed_point_16_bit #() net_in_wc1_mult_8
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_8),
        .b(WEIGHT_MEAN_81),
        .q_result(in_wc1_mult_8)
    );

    multiplier_fixed_point_16_bit #() net_in_wc1_mult_9
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_9),
        .b(WEIGHT_MEAN_91),
        .q_result(in_wc1_mult_9)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_1
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_1),
        .b(WEIGHT_VAR_11),
        .q_result(in_wd1_mult_1)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_2
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_2),
        .b(WEIGHT_VAR_21),
        .q_result(in_wd1_mult_2)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_3
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_3),
        .b(WEIGHT_VAR_31),
        .q_result(in_wd1_mult_3)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_4
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_4),
        .b(WEIGHT_VAR_41),
        .q_result(in_wd1_mult_4)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_5
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_5),
        .b(WEIGHT_VAR_51),
        .q_result(in_wd1_mult_5)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_6
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_6),
        .b(WEIGHT_VAR_61),
        .q_result(in_wd1_mult_6)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_7
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_7),
        .b(WEIGHT_VAR_71),
        .q_result(in_wd1_mult_7)
    );
    
    multiplier_fixed_point_16_bit #() net_in_wd1_mult_8
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_8),
        .b(WEIGHT_VAR_81),
        .q_result(in_wd1_mult_8)
    );

    multiplier_fixed_point_16_bit #() net_in_wd1_mult_9
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_9),
        .b(WEIGHT_VAR_91),
        .q_result(in_wd1_mult_9)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_1
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_1),
        .b(WEIGHT_MEAN_12),
        .q_result(in_wc2_mult_1)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_2
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_2),
        .b(WEIGHT_MEAN_22),
        .q_result(in_wc2_mult_2)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_3
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_3),
        .b(WEIGHT_MEAN_32),
        .q_result(in_wc2_mult_3)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_4
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_4),
        .b(WEIGHT_MEAN_42),
        .q_result(in_wc2_mult_4)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_5
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_5),
        .b(WEIGHT_MEAN_52),
        .q_result(in_wc2_mult_5)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_6
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_6),
        .b(WEIGHT_MEAN_62),
        .q_result(in_wc2_mult_6)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_7
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_7),
        .b(WEIGHT_MEAN_72),
        .q_result(in_wc2_mult_7)
    );
    
    multiplier_fixed_point_16_bit #() net_in_wc2_mult_8
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_8),
        .b(WEIGHT_MEAN_82),
        .q_result(in_wc2_mult_8)
    );

    multiplier_fixed_point_16_bit #() net_in_wc2_mult_9
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_9),
        .b(WEIGHT_MEAN_92),
        .q_result(in_wc2_mult_9)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_1
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_1),
        .b(WEIGHT_VAR_12),
        .q_result(in_wd2_mult_1)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_2
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_2),
        .b(WEIGHT_VAR_22),
        .q_result(in_wd2_mult_2)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_3
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_3),
        .b(WEIGHT_VAR_32),
        .q_result(in_wd2_mult_3)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_4
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_4),
        .b(WEIGHT_VAR_42),
        .q_result(in_wd2_mult_4)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_5
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_5),
        .b(WEIGHT_VAR_52),
        .q_result(in_wd2_mult_5)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_6
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_6),
        .b(WEIGHT_VAR_62),
        .q_result(in_wd2_mult_6)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_7
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_7),
        .b(WEIGHT_VAR_72),
        .q_result(in_wd2_mult_7)
    );
    
    multiplier_fixed_point_16_bit #() net_in_wd2_mult_8
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_8),
        .b(WEIGHT_VAR_82),
        .q_result(in_wd2_mult_8)
    );

    multiplier_fixed_point_16_bit #() net_in_wd2_mult_9
    (
        .clk(clk),
        .rst(rst),
        .a(in_pad_9),
        .b(WEIGHT_VAR_92),
        .q_result(in_wd2_mult_9)
    );

    adder_9x16_bit #() sum_1
    (
        .clk(clk),
        .rst(rst),
        .in1(in_wc1_mult_1),
        .in2(in_wc1_mult_2),
        .in3(in_wc1_mult_3),
        .in4(in_wc1_mult_4),
        .in5(in_wc1_mult_5),
        .in6(in_wc1_mult_6),
        .in7(in_wc1_mult_7),
        .in8(in_wc1_mult_8),
        .in9(in_wc1_mult_9),
        .out(c1_temp)
    );

    adder_9x16_bit #() sum_2
    (
        .clk(clk),
        .rst(rst),
        .in1(in_wd1_mult_1),
        .in2(in_wd1_mult_2),
        .in3(in_wd1_mult_3),
        .in4(in_wd1_mult_4),
        .in5(in_wd1_mult_5),
        .in6(in_wd1_mult_6),
        .in7(in_wd1_mult_7),
        .in8(in_wd1_mult_8),
        .in9(in_wd1_mult_9),
        .out(d1_temp)
    );

    adder_9x16_bit #() sum_3
    (
        .clk(clk),
        .rst(rst),
        .in1(in_wc2_mult_1),
        .in2(in_wc2_mult_2),
        .in3(in_wc2_mult_3),
        .in4(in_wc2_mult_4),
        .in5(in_wc2_mult_5),
        .in6(in_wc2_mult_6),
        .in7(in_wc2_mult_7),
        .in8(in_wc2_mult_8),
        .in9(in_wc2_mult_9),
        .out(c2_temp)
    );

    adder_9x16_bit #() sum_4
    (
        .clk(clk),
        .rst(rst),
        .in1(in_wd2_mult_1),
        .in2(in_wd2_mult_2),
        .in3(in_wd2_mult_3),
        .in4(in_wd2_mult_4),
        .in5(in_wd2_mult_5),
        .in6(in_wd2_mult_6),
        .in7(in_wd2_mult_7),
        .in8(in_wd2_mult_8),
        .in9(in_wd2_mult_9),
        .out(d2_temp)
    );

    softplus_16_bit #() softplust_1
    (
        .clk(clk),
        .rst(rst),
        .x(d1),
        .y(ad1)
    );

    softplus_16_bit #() softplust_2
    (
        .clk(clk),
        .rst(rst),
        .x(d2),
        .y(ad2)
    );

    sqrt #() sqrt_1
    (
        .clk(clk),
        .start(start),
        .rad(ad1),
        .root(ad1_sqrt)
    );

    sqrt #() sqrt_2
    (
        .clk(clk),
        .start(start),
        .rad(ad2),
        .root(ad2_sqrt)
    );

    multiplier_fixed_point_16_bit #() net_a1_mult
    (
        .clk(clk),
        .rst(rst),
        .a(a1_sqrt),
        .b(EPS_1),
        .q_result(a1_mult)
    );
    
    multiplier_fixed_point_16_bit #() net_a2_mult
    (
        .clk(clk),
        .rst(rst),
        .a(a2_sqrt),
        .b(EPS_2),
        .q_result(a2_mult)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_0;
        end else begin
            state <= nextState;
        end
    end
    assign nextState = (state==STATE_0) ? STATE_1 : (state==STATE_1) ? STATE_2 : 
        (state==STATE_2) ? STATE_3 : (state==STATE_3) ? STATE_4 : 
        (state==STATE_4) ? STATE_5 : (state==STATE_5) ? STATE_6 :
        (state==STATE_6) ? STATE_7 : STATE_0;
    assign c1 = (state==STATE_1 | state==STATE_3) ? c1_temp + BIAS_MEAN_1 : 0;
    assign d1 = (state==STATE_1 | state==STATE_3) ? d1_temp + BIAS_VAR_1 : 0;
    assign c2 = (state==STATE_1 | state==STATE_3) ? c2_temp + BIAS_MEAN_2 : 0;
    assign d2 = (state==STATE_1 | state==STATE_3) ? d2_temp + BIAS_VAR_2 : 0;
    assign start = (state==STATE_1) ? 1 : 0;
    assign a1_sqrt = (state==STATE_1) ? ad1_sqrt : 0;
    assign a2_sqrt = (state==STATE_1) ? ad2_sqrt : 0;
    assign a1 = (state==STATE_6) ? c1 + a1_mult : 0;
    assign a2 = (state==STATE_6) ? c2 + a2_mult : 0;
endmodule