`include "../sqrt/sqrt.v"
`include "../adder_9x16_bit/adder_9x16_bit.v"
`include "../multiplier_fp_9x16_bit/multiplier_fp_9x16_bit.v"
`include "../softplus_16_bit/softplus_16_bit.v"

module encoder
#(parameter 
    WIDTH = 16,
    N_IN = 9,

    STATE_0 = 4'h0,
    STATE_1 = 4'h1,
    STATE_2 = 4'h2,
    STATE_3 = 4'h3,
    STATE_4 = 4'h4,
    STATE_5 = 4'h5,
    STATE_6 = 4'h6,
    STATE_7 = 4'h7,
    STATE_8 = 4'h8,

    WEIGHT_MEAN_11 = 16'h003e,
    WEIGHT_MEAN_21 = 16'hffed,
    WEIGHT_MEAN_31 = 16'hffb7,
    WEIGHT_MEAN_41 = 16'h0002,
    WEIGHT_MEAN_51 = 16'hffb8,
    WEIGHT_MEAN_61 = 16'h0032,
    WEIGHT_MEAN_71 = 16'hfad7,
    WEIGHT_MEAN_81 = 16'h20d8,
    WEIGHT_MEAN_91 = 16'h03f3,

    WEIGHT_VAR_11 = 16'h00e8,
    WEIGHT_VAR_21 = 16'hffa4,
    WEIGHT_VAR_31 = 16'hffa5,
    WEIGHT_VAR_41 = 16'h0029,
    WEIGHT_VAR_51 = 16'h0061,
    WEIGHT_VAR_61 = 16'hffc3,
    WEIGHT_VAR_71 = 16'hfe95,
    WEIGHT_VAR_81 = 16'hfed8,
    WEIGHT_VAR_91 = 16'hfa79,

    BIAS_MEAN_1 = 16'hf22d,
    BIAS_VAR_1 = 16'hf165,

    WEIGHT_MEAN_12 = 16'hffef,
    WEIGHT_MEAN_22 = 16'h0095,
    WEIGHT_MEAN_32 = 16'hfff2,
    WEIGHT_MEAN_42 = 16'h0095,
    WEIGHT_MEAN_52 = 16'hff61,
    WEIGHT_MEAN_62 = 16'h0093,
    WEIGHT_MEAN_72 = 16'h0652,
    WEIGHT_MEAN_82 = 16'hfd64,
    WEIGHT_MEAN_92 = 16'h089f,

    WEIGHT_VAR_12 = 16'h00b3,
    WEIGHT_VAR_22 = 16'hff62,
    WEIGHT_VAR_32 = 16'h00b0,
    WEIGHT_VAR_42 = 16'hff6d,
    WEIGHT_VAR_52 = 16'h0153,
    WEIGHT_VAR_62 = 16'hff3d,
    WEIGHT_VAR_72 = 16'h0dd5,
    WEIGHT_VAR_82 = 16'h02a8,
    WEIGHT_VAR_92 = 16'h0286,

    BIAS_MEAN_2 = 16'hf22d,
    BIAS_VAR_2 = 16'hf5fa,

    EPS_1 = 16'h12ba,
    EPS_2 = 16'hf42e
    )
    (
        input clk, rst,
        input [N_IN-1:0] in,
        output [WIDTH-1:0] a1, a2
);
    wire en_mult_in, en_mult_a1, en_mult_a2, en_sqrt, en_softplus;
    reg [3:0] state;
    wire [3:0] nextState;
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
    wire [WIDTH-1:0] a1_mult;
    wire [WIDTH-1:0] a2_mult;
    wire [WIDTH-1:0] ad1_sqrt;
    wire [WIDTH-1:0] ad2_sqrt;

    wire busy_sqrt_1, busy_sqrt_2, busy_mult_in_1, busy_mult_in_2, busy_mult_in_3, busy_mult_in_4, busy_mult_a1, busy_mult_a2;

    multiplier_fp_9x16_bit #() mult_1
    (
        .clk(clk),
        .start(en_mult_in),
        .a1(in_pad_1),
        .a2(in_pad_2),
        .a3(in_pad_3),
        .a4(in_pad_4),
        .a5(in_pad_5),
        .a6(in_pad_6),
        .a7(in_pad_7),
        .a8(in_pad_8),
        .a9(in_pad_9),
        .b1(WEIGHT_MEAN_11),
        .b2(WEIGHT_MEAN_21),
        .b3(WEIGHT_MEAN_31),
        .b4(WEIGHT_MEAN_41),
        .b5(WEIGHT_MEAN_51),
        .b6(WEIGHT_MEAN_61),
        .b7(WEIGHT_MEAN_71),
        .b8(WEIGHT_MEAN_81),
        .b9(WEIGHT_MEAN_91),
        .o1(in_wc1_mult_1),
        .o2(in_wc1_mult_2),
        .o3(in_wc1_mult_3),
        .o4(in_wc1_mult_4),
        .o5(in_wc1_mult_5),
        .o6(in_wc1_mult_6),
        .o7(in_wc1_mult_7),
        .o8(in_wc1_mult_8),
        .o9(in_wc1_mult_9),
        .busy(busy_mult_in_1)
    );

    multiplier_fp_9x16_bit #() mult_2
    (
        .clk(clk),
        .start(en_mult_in),
        .a1(in_pad_1),
        .a2(in_pad_2),
        .a3(in_pad_3),
        .a4(in_pad_4),
        .a5(in_pad_5),
        .a6(in_pad_6),
        .a7(in_pad_7),
        .a8(in_pad_8),
        .a9(in_pad_9),
        .b1(WEIGHT_VAR_11),
        .b2(WEIGHT_VAR_21),
        .b3(WEIGHT_VAR_31),
        .b4(WEIGHT_VAR_41),
        .b5(WEIGHT_VAR_51),
        .b6(WEIGHT_VAR_61),
        .b7(WEIGHT_VAR_71),
        .b8(WEIGHT_VAR_81),
        .b9(WEIGHT_VAR_91),
        .o1(in_wd1_mult_1),
        .o2(in_wd1_mult_2),
        .o3(in_wd1_mult_3),
        .o4(in_wd1_mult_4),
        .o5(in_wd1_mult_5),
        .o6(in_wd1_mult_6),
        .o7(in_wd1_mult_7),
        .o8(in_wd1_mult_8),
        .o9(in_wd1_mult_9),
        .busy(busy_mult_in_2)
    );

    multiplier_fp_9x16_bit #() mult_3
    (
        .clk(clk),
        .start(en_mult_in),
        .a1(in_pad_1),
        .a2(in_pad_2),
        .a3(in_pad_3),
        .a4(in_pad_4),
        .a5(in_pad_5),
        .a6(in_pad_6),
        .a7(in_pad_7),
        .a8(in_pad_8),
        .a9(in_pad_9),
        .b1(WEIGHT_VAR_12),
        .b2(WEIGHT_VAR_22),
        .b3(WEIGHT_VAR_32),
        .b4(WEIGHT_VAR_42),
        .b5(WEIGHT_VAR_52),
        .b6(WEIGHT_VAR_62),
        .b7(WEIGHT_VAR_72),
        .b8(WEIGHT_VAR_82),
        .b9(WEIGHT_VAR_92),
        .o1(in_wd2_mult_1),
        .o2(in_wd2_mult_2),
        .o3(in_wd2_mult_3),
        .o4(in_wd2_mult_4),
        .o5(in_wd2_mult_5),
        .o6(in_wd2_mult_6),
        .o7(in_wd2_mult_7),
        .o8(in_wd2_mult_8),
        .o9(in_wd2_mult_9),
        .busy(busy_mult_in_3)
    );

    multiplier_fp_9x16_bit #() mult_4
    (
        .clk(clk),
        .start(en_mult_in),
        .a1(in_pad_1),
        .a2(in_pad_2),
        .a3(in_pad_3),
        .a4(in_pad_4),
        .a5(in_pad_5),
        .a6(in_pad_6),
        .a7(in_pad_7),
        .a8(in_pad_8),
        .a9(in_pad_9),
        .b1(WEIGHT_MEAN_12),
        .b2(WEIGHT_MEAN_22),
        .b3(WEIGHT_MEAN_32),
        .b4(WEIGHT_MEAN_42),
        .b5(WEIGHT_MEAN_52),
        .b6(WEIGHT_MEAN_62),
        .b7(WEIGHT_MEAN_72),
        .b8(WEIGHT_MEAN_82),
        .b9(WEIGHT_MEAN_92),
        .o1(in_wc2_mult_1),
        .o2(in_wc2_mult_2),
        .o3(in_wc2_mult_3),
        .o4(in_wc2_mult_4),
        .o5(in_wc2_mult_5),
        .o6(in_wc2_mult_6),
        .o7(in_wc2_mult_7),
        .o8(in_wc2_mult_8),
        .o9(in_wc2_mult_9),
        .busy(busy_mult_in_4)
    );

    adder_9x16_bit #() sum_1
    (
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
        .start(en_softplus),
        .x(d1),
        .y(ad1)
    );

    softplus_16_bit #() softplust_2
    (
        .clk(clk),
        .start(en_softplus),
        .x(d2),
        .y(ad2)
    );

    sqrt #() sqrt_1
    (
        .clk(clk),
        .start(en_sqrt),
        .rad(ad1),
        .root(ad1_sqrt),
        .busy(busy_sqrt_1)
    );

    sqrt #() sqrt_2
    (
        .clk(clk),
        .start(en_sqrt),
        .rad(ad2),
        .root(ad2_sqrt),
        .busy(busy_sqrt_2)
    );

    multiplier_fixed_point_16_bit #() net_a1_mult
    (
        .clk(clk),
        .start(en_mult_a1),
        .a(ad1_sqrt),
        .b(EPS_1),
        .busy(busy_mult_a1),
        .q_result(a1_mult)
    );
    
    multiplier_fixed_point_16_bit #() net_a2_mult
    (
        .clk(clk),
        .start(en_mult_a2),
        .a(ad2_sqrt),
        .b(EPS_2),
        .busy(busy_mult_a2),
        .q_result(a2_mult)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_0;
        end else if (busy_sqrt_1 || busy_sqrt_2 || busy_mult_in_1 
            || busy_mult_in_2 || busy_mult_in_3 || busy_mult_in_4 
            || busy_mult_a1 || busy_mult_a2) begin
            state <= state;
        end else begin
            state <= nextState;
        end
    end
    assign nextState = (state==STATE_0) ? STATE_1 : (state==STATE_1) ? STATE_2 : 
        (state==STATE_2) ? STATE_3 : (state==STATE_3) ? STATE_4 : 
        (state==STATE_4) ? STATE_5 : (state==STATE_5) ? STATE_6 :
        (state==STATE_6) ? STATE_7 : (state==STATE_7) ? STATE_8 : STATE_0;
    assign en_mult_in = (state==STATE_1) ? 1 : 0;
    assign c1 = (state==STATE_1 || state==STATE_2) ? c1_temp + BIAS_MEAN_1 : c1;
    assign d1 = (state==STATE_1 || state==STATE_2) ? d1_temp + BIAS_VAR_1 : d1;
    assign c2 = (state==STATE_1 || state==STATE_2) ? c2_temp +  BIAS_MEAN_2 : c2;
    assign d2 = (state==STATE_1 || state==STATE_2) ? d2_temp + BIAS_VAR_2 : d2;
    
    assign en_softplus = (state==STATE_2) ? 1 : 0;
    assign en_sqrt = (state==STATE_5) ? 1 : 0;
    assign en_mult_a1 = (state==STATE_7) ? 1 : 0;
    assign en_mult_a2 = (state==STATE_7) ? 1 : 0;
    assign a1 = (state==STATE_8) ? c1 + a1_mult : a1;
    assign a2 = (state==STATE_8) ? c2 + a2_mult : a2;
endmodule