module adder_bf16 (
    input  [15:0] A,   // BF16 input A
    input  [15:0] B,   // BF16 input B
    output [15:0] S    // BF16 output Sum
);

    // === Internal signals ===
    wire signA, signB, signS;
    wire [7:0] exponentA, exponentB, exponentS;
    wire [8:0] mantissaA, mantissaB;         // 1 + 7 bits
    wire [9:0] aligned_mantissaA, aligned_mantissaB;
    wire [10:0] sum_mantissa;
    wire [7:0] exponent_diff;
    wire [7:0] final_exponent;
    wire [6:0] final_mantissa;
    wire [7:0] adjusted_exponent;

    // === Special case detection ===
    wire A_is_zero = (A[14:0] == 0);
    wire B_is_zero = (B[14:0] == 0);
    wire A_is_inf  = (A[14:7] == 8'hFF) && (A[6:0] == 0);
    wire B_is_inf  = (B[14:7] == 8'hFF) && (B[6:0] == 0);
    wire A_is_nan  = (A[14:7] == 8'hFF) && (A[6:0] != 0);
    wire B_is_nan  = (B[14:7] == 8'hFF) && (B[6:0] != 0);

    // === Unpack ===
    assign signA = A[15];
    assign signB = B[15];
    assign exponentA = A[14:7];
    assign exponentB = B[14:7];
    assign mantissaA = (exponentA == 0) ? {1'b0, A[6:0]} : {1'b1, A[6:0]};
    assign mantissaB = (exponentB == 0) ? {1'b0, B[6:0]} : {1'b1, B[6:0]};

    // === Align exponents ===
    assign exponent_diff    = (exponentA > exponentB) ? (exponentA - exponentB) : (exponentB - exponentA);
    assign aligned_mantissaA = (exponentA >= exponentB) ? {mantissaA, 1'b0} : ({mantissaA, 1'b0} >> exponent_diff);
    assign aligned_mantissaB = (exponentB >= exponentA) ? {mantissaB, 1'b0} : ({mantissaB, 1'b0} >> exponent_diff);
    assign exponentS = (exponentA >= exponentB) ? exponentA : exponentB;

    // === Add or subtract mantissas ===
    assign sum_mantissa = (signA == signB) ? (aligned_mantissaA + aligned_mantissaB) :
                                             (aligned_mantissaA >= aligned_mantissaB ?
                                              (aligned_mantissaA - aligned_mantissaB) :
                                              (aligned_mantissaB - aligned_mantissaA));

    // === Final sign ===
    assign signS = (aligned_mantissaA >= aligned_mantissaB) ? signA : signB;

    // === Normalize ===
    assign adjusted_exponent = sum_mantissa[10] ? (exponentS + 1) : exponentS;
    assign final_mantissa    = sum_mantissa[10] ? sum_mantissa[9:3] : sum_mantissa[8:2];
    assign final_exponent    = adjusted_exponent;

    // === Pack result with special cases ===
    assign S = (A_is_nan | B_is_nan) ? {1'b0, 8'hFF, 7'b1} :                 // NaN
               (A_is_inf & B_is_inf & (signA != signB)) ? {1'b0, 8'hFF, 7'b1} : // Inf - Inf = NaN
               (A_is_inf) ? A :
               (B_is_inf) ? B :
               (A_is_zero & B_is_zero) ? {signA & signB, 15'b0} :
               (A_is_zero) ? B :
               (B_is_zero) ? A :
               {signS, final_exponent, final_mantissa};

endmodule
