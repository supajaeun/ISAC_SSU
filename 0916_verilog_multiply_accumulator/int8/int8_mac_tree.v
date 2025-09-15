module int8_mac_tree (
    input signed [7:0] in0,
    input signed [7:0] in1,
    input signed [7:0] in2,
    input signed [7:0] in3,
    input signed [7:0] in4,
    input signed [7:0] in5,
    input signed [7:0] in6,
    input signed [7:0] in7,
    input signed [7:0] in8,
    input signed [7:0] in9,
    input signed [7:0] in10,
    input signed [7:0] in11,
    input signed [7:0] in12,
    input signed [7:0] in13,
    input signed [7:0] in14,
    input signed [7:0] in15,
    output signed [31:0] out,

    // Add intermediate signals as output ports for debugging
    output signed [15:0] prod0, prod1, output signed [15:0] prod2, prod3, output signed [15:0] prod4, prod5, output signed [15:0] prod6, prod7,
    output signed [17:0] sum_level2_0, sum_level2_1
);

    // Declare wires to store intermediate results for each stage
    // Declared to match the output of adder_16bit (17-bit)
    wire signed [16:0] sum_level1_out [0:3];
    // Temporary wire for the final summation (19-bit)
    wire signed [18:0] out_temp;

    // Stage 1: Instantiate 8 multipliers (output 16-bit)
    multiplier_8bit mul0 (.A(in0), .B(in1), .P(prod0));
    multiplier_8bit mul1 (.A(in2), .B(in3), .P(prod1));
    multiplier_8bit mul2 (.A(in4), .B(in5), .P(prod2));
    multiplier_8bit mul3 (.A(in6), .B(in7), .P(prod3));
    multiplier_8bit mul4 (.A(in8), .B(in9), .P(prod4));
    multiplier_8bit mul5 (.A(in10), .B(in11), .P(prod5));
    multiplier_8bit mul6 (.A(in12), .B(in13), .P(prod6));
    multiplier_8bit mul7 (.A(in14), .B(in15), .P(prod7));

    // Stage 2: Instantiate 4 adders (16-bit adder -> output 17-bit)
    adder_16bit add_l1_0 (.A(prod0), .B(prod1), .S(sum_level1_out[0]));
    adder_16bit add_l1_1 (.A(prod2), .B(prod3), .S(sum_level1_out[1]));
    adder_16bit add_l1_2 (.A(prod4), .B(prod5), .S(sum_level1_out[2]));
    adder_16bit add_l1_3 (.A(prod6), .B(prod7), .S(sum_level1_out[3]));

    // Stage 3: Instantiate 2 adders (17-bit adder -> output 18-bit)
    adder_17bit add_l2_0 (.A(sum_level1_out[0]), .B(sum_level1_out[1]), .S(sum_level2_0));
    adder_17bit add_l2_1 (.A(sum_level1_out[2]), .B(sum_level1_out[3]), .S(sum_level2_1));

    // Stage 4: Final summation (18-bit adder -> output 19-bit)
    adder_18bit add_final (.A(sum_level2_0), .B(sum_level2_1), .S(out_temp));
    assign out = out_temp;

endmodule