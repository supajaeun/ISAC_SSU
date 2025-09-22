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

    // 1. sign bit
    assign sign = A[15] ^ B[15]; 

    // 2. exponent sum with bias adjustment
    assign exponent_sum = A[14:7] + B[14:7] - 8'd127; 

    // 3. mantissa multiplication
    assign mantissa_product = {1'b1, A[6:0]} * {1'b1, B[6:0]}; 

    assign normalized = mantissa_product[15]; // Check if normalization is needed (leading 1 in bit 15)
    assign mantissa   = normalized ? mantissa_product[14:8] : mantissa_product[13:7]; //mantissa extraction
    assign exponent   = normalized ? exponent_sum + 1 : exponent_sum; // Adjust exponent if normalized

    // Result
    assign P = (A_is_nan | B_is_nan) ? {1'b0, 8'hFF, 7'b1} :    // NaN (if any input is NaN)
               ((A_is_inf & B_is_zero) | (B_is_inf & A_is_zero)) ? {1'b0, 8'hFF, 7'b1} : //  Inf*0 = NaN (if one input is Inf and the other is 0)
               (A_is_inf | B_is_inf) ? {sign, 8'hFF, 7'b0} :  // Infinity (if any input is Inf)
               (A_is_zero | B_is_zero) ? {sign, 15'b0} :     // Zero (if any input is 0)
               {sign, exponent[7:0], mantissa};             // final result for normal cases

endmodule
