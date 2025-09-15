module bfloat16_multiplier (
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] P
);
    wire signA = A[15];
    wire signB = B[15];
    wire [7:0] expA = A[14:7];
    wire [7:0] expB = B[14:7];
    wire [6:0] mantA = A[6:0];
    wire [6:0] mantB = B[6:0];

    // 1. 부호 비트 연산
    wire signP = signA ^ signB;

    // 2. 지수 연산
    wire [8:0] sum_exp = expA + expB;
    wire [7:0] expP_unnormalized = sum_exp - 8'd127;

    // 3. 가수 연산
    wire [7:0] mantA_with_implicit = {1'b1, mantA};
    wire [7:0] mantB_with_implicit = {1'b1, mantB};
    wire [14:0] product_mant = mantA_with_implicit * mantB_with_implicit;

    // 4. 정규화 및 최종 결과 조합 (always 블록 사용)
    reg [7:0] normalized_exp;
    reg [6:0] normalized_mant;

    always @(*) begin
        // 오버플로우 발생 시 지수 1 증가, 가수 오른쪽 시프트
        if (product_mant[14] == 1'b1) begin
            normalized_exp = expP_unnormalized + 1;
            normalized_mant = product_mant[13:7];
        end else begin
            normalized_exp = expP_unnormalized;
            normalized_mant = product_mant[12:6];
        end
        // 최종 결과 조합 시 비트 폭 명시
        P = {signP, normalized_exp, normalized_mant};
    end
endmodule