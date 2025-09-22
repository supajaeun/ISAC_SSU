module int8_mac_tree (
    input clk, // clock signal
    input reset, // reset signal

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
    
    // 최종 출력 포트
    output reg signed [31:0] out,
    
    // 중간 결과 디버깅을 위한 출력 포트들을 다시 추가
    output signed [15:0] prod0, prod1, prod2, prod3, prod4, prod5, prod6, prod7,
    output signed [17:0] sum_level2_0, sum_level2_1
); // <- Make sure the parenthesis is here without a semicolon.

    // Wires for the combinational logic
    wire signed [16:0] sum_level1_out [0:3];
    wire signed [18:0] out_temp;

    // Registers for the inputs
    reg signed [7:0] in0_reg, in1_reg, in2_reg, in3_reg, in4_reg, in5_reg, in6_reg, in7_reg, 
                     in8_reg, in9_reg, in10_reg, in11_reg, in12_reg, in13_reg, in14_reg, in15_reg;

    // Register inputs on the positive clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in0_reg <= 8'h0; in1_reg <= 8'h0; in2_reg <= 8'h0; in3_reg <= 8'h0;
            in4_reg <= 8'h0; in5_reg <= 8'h0; in6_reg <= 8'h0; in7_reg <= 8'h0;
            in8_reg <= 8'h0; in9_reg <= 8'h0; in10_reg <= 8'h0; in11_reg <= 8'h0;
            in12_reg <= 8'h0; in13_reg <= 8'h0; in14_reg <= 8'h0; in15_reg <= 8'h0;
        end else begin
            in0_reg <= in0; in1_reg <= in1; in2_reg <= in2; in3_reg <= in3;
            in4_reg <= in4; in5_reg <= in5; in6_reg <= in6; in7_reg <= in7;
            in8_reg <= in8; in9_reg <= in9; in10_reg <= in10; in11_reg <= in11;
            in12_reg <= in12; in13_reg <= in13; in14_reg <= in14; in15_reg <= in15;
        end
    end

    // Stage 1: Instantiate 8 multipliers (output 16-bit)
    multiplier_8bit mul0 (.A(in0_reg), .B(in1_reg), .P(prod0));
    multiplier_8bit mul1 (.A(in2_reg), .B(in3_reg), .P(prod1));
    multiplier_8bit mul2 (.A(in4_reg), .B(in5_reg), .P(prod2));
    multiplier_8bit mul3 (.A(in6_reg), .B(in7_reg), .P(prod3));
    multiplier_8bit mul4 (.A(in8_reg), .B(in9_reg), .P(prod4));
    multiplier_8bit mul5 (.A(in10_reg), .B(in11_reg), .P(prod5));
    multiplier_8bit mul6 (.A(in12_reg), .B(in13_reg), .P(prod6));
    multiplier_8bit mul7 (.A(in14_reg), .B(in15_reg), .P(prod7));

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

    // Register the final output on the positive clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 32'h0;
        else
            out <= out_temp;
    end
endmodule