module multiplier_bf16 (
    input  [15:0] A,
    input  [15:0] B,
    output [15:0] P
);

    wire sign;
    wire [8:0] exponent_sum;
    wire [7:0] exponent;
    wire [15:0] mantissa_product;
    wire [6:0] mantissa;
    wire normalized;

    // Special cases
    wire A_is_zero = (A[14:0] == 15'b0);
    wire B_is_zero = (B[14:0] == 15'b0);
    wire A_is_inf  = (A[14:7] == 8'hFF) && (A[6:0] == 0);
    wire B_is_inf  = (B[14:7] == 8'hFF) && (B[6:0] == 0);
    wire A_is_nan  = (A[14:7] == 8'hFF) && (A[6:0] != 0);
    wire B_is_nan  = (B[14:7] == 8'hFF) && (B[6:0] != 0);

    // Normal ops
    assign sign = A[15] ^ B[15];
    assign exponent_sum = A[14:7] + B[14:7] - 8'd127;
    assign mantissa_product = {1'b1, A[6:0]} * {1'b1, B[6:0]};

    assign normalized = mantissa_product[15];
    assign mantissa   = normalized ? mantissa_product[14:8] : mantissa_product[13:7];
    assign exponent   = normalized ? exponent_sum + 1 : exponent_sum;

    // Result
    assign P = (A_is_nan | B_is_nan) ? {1'b0, 8'hFF, 7'b1} :        // NaN
               ((A_is_inf & B_is_zero) | (B_is_inf & A_is_zero)) ? {1'b0, 8'hFF, 7'b1} : // Inf*0 = NaN
               (A_is_inf | B_is_inf) ? {sign, 8'hFF, 7'b0} :        // Infinity
               (A_is_zero | B_is_zero) ? {sign, 15'b0} :             // Zero
               {sign, exponent[7:0], mantissa};

endmodule
