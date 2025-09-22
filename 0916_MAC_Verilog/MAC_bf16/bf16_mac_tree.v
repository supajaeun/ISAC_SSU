module bf16_mac_tree (
    input clk,
    input reset,
    input [15:0] in0, in1, in2, in3,
    input [15:0] in4, in5, in6, in7,
    input [15:0] in8, in9, in10, in11,
    input [15:0] in12, in13, in14, in15,
    output reg [15:0] out
);

    reg [15:0] in_reg[0:15];
    wire [15:0] prod[0:7];
    wire [15:0] sum[0:6];
    wire [15:0] final_sum;

    // Register input
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in_reg[0]  <= 0; in_reg[1]  <= 0; in_reg[2]  <= 0; in_reg[3]  <= 0;
            in_reg[4]  <= 0; in_reg[5]  <= 0; in_reg[6]  <= 0; in_reg[7]  <= 0;
            in_reg[8]  <= 0; in_reg[9]  <= 0; in_reg[10] <= 0; in_reg[11] <= 0;
            in_reg[12] <= 0; in_reg[13] <= 0; in_reg[14] <= 0; in_reg[15] <= 0;
        end else begin
            in_reg[0]  <= in0;  in_reg[1]  <= in1;  in_reg[2]  <= in2;  in_reg[3]  <= in3;
            in_reg[4]  <= in4;  in_reg[5]  <= in5;  in_reg[6]  <= in6;  in_reg[7]  <= in7;
            in_reg[8]  <= in8;  in_reg[9]  <= in9;  in_reg[10] <= in10; in_reg[11] <= in11;
            in_reg[12] <= in12; in_reg[13] <= in13; in_reg[14] <= in14; in_reg[15] <= in15;
        end
    end

    // Multiply
    multiplier_bf16 m0 (.A(in_reg[0]), .B(in_reg[1]), .P(prod[0]));
    multiplier_bf16 m1 (.A(in_reg[2]), .B(in_reg[3]), .P(prod[1]));
    multiplier_bf16 m2 (.A(in_reg[4]), .B(in_reg[5]), .P(prod[2]));
    multiplier_bf16 m3 (.A(in_reg[6]), .B(in_reg[7]), .P(prod[3]));
    multiplier_bf16 m4 (.A(in_reg[8]), .B(in_reg[9]), .P(prod[4]));
    multiplier_bf16 m5 (.A(in_reg[10]), .B(in_reg[11]), .P(prod[5]));
    multiplier_bf16 m6 (.A(in_reg[12]), .B(in_reg[13]), .P(prod[6]));
    multiplier_bf16 m7 (.A(in_reg[14]), .B(in_reg[15]), .P(prod[7]));

    // Add tree
    adder_bf16 a0 (.A(prod[0]), .B(prod[1]), .S(sum[0]));
    adder_bf16 a1 (.A(prod[2]), .B(prod[3]), .S(sum[1]));
    adder_bf16 a2 (.A(prod[4]), .B(prod[5]), .S(sum[2]));
    adder_bf16 a3 (.A(prod[6]), .B(prod[7]), .S(sum[3]));

    adder_bf16 a4 (.A(sum[0]), .B(sum[1]), .S(sum[4]));
    adder_bf16 a5 (.A(sum[2]), .B(sum[3]), .S(sum[5]));

    adder_bf16 a6 (.A(sum[4]), .B(sum[5]), .S(final_sum));

    // Output
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 16'b0;
        else
            out <= final_sum;
    end

endmodule
