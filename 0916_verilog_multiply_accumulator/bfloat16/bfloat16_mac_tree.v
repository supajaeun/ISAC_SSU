module bfloat16_mac_tree (
    input [15:0] in0, in1, in2, in3, in4, in5, in6, in7,
    input [15:0] in8, in9, in10, in11, in12, in13, in14, in15,
    output [15:0] out
);

    wire [15:0] prod0, prod1, prod2, prod3, prod4, prod5, prod6, prod7;
    wire [15:0] sum_level1_0, sum_level1_1, sum_level1_2, sum_level1_3;
    wire [15:0] sum_level2_0, sum_level2_1;

    bfloat16_multiplier mul0 (.A(in0), .B(in1), .P(prod0));
    bfloat16_multiplier mul1 (.A(in2), .B(in3), .P(prod1));
    bfloat16_multiplier mul2 (.A(in4), .B(in5), .P(prod2));
    bfloat16_multiplier mul3 (.A(in6), .B(in7), .P(prod3));
    bfloat16_multiplier mul4 (.A(in8), .B(in9), .P(prod4));
    bfloat16_multiplier mul5 (.A(in10), .B(in11), .P(prod5));
    bfloat16_multiplier mul6 (.A(in12), .B(in13), .P(prod6));
    bfloat16_multiplier mul7 (.A(in14), .B(in15), .P(prod7));

    // 'S' 포트로 변경된 bfloat16_adder 모듈 인스턴스화
    bfloat16_adder add_l1_0 (.A(prod0), .B(prod1), .S(sum_level1_0));
    bfloat16_adder add_l1_1 (.A(prod2), .B(prod3), .S(sum_level1_1));
    bfloat16_adder add_l1_2 (.A(prod4), .B(prod5), .S(sum_level1_2));
    bfloat16_adder add_l1_3 (.A(prod6), .B(prod7), .S(sum_level1_3));

    bfloat16_adder add_l2_0 (.A(sum_level1_0), .B(sum_level1_1), .S(sum_level2_0));
    bfloat16_adder add_l2_1 (.A(sum_level1_2), .B(sum_level1_3), .S(sum_level2_1));

    bfloat16_adder add_l3_0 (.A(sum_level2_0), .B(sum_level2_1), .S(out));
endmodule