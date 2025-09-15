module bfloat16_adder (
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] S // output reg로 선언
);

    wire signA = A[15];
    wire signB = B[15];
    wire [7:0] expA = A[14:7];
    wire [7:0] expB = B[14:7];
    wire [6:0] mantA = A[6:0];
    wire [6:0] mantB = B[6:0];

    // always 블록 내에서 사용될 변수들을 reg로 선언
    reg [7:0] exp_diff;
    reg [7:0] aligned_mantA, aligned_mantB;
    reg [8:0] sum_mantissa;
    reg final_sign;
    reg [7:0] final_exp;
    reg [6:0] normalized_mantissa;
    
    always @(*) begin
        // 1. 지수 비교 및 정렬
        if (expA > expB) begin
            exp_diff = expA - expB;
            aligned_mantA = {1'b1, mantA};
            aligned_mantB = {1'b1, mantB} >> exp_diff;
            final_exp = expA;
        end else begin
            exp_diff = expB - expA;
            aligned_mantA = {1'b1, mantA} >> exp_diff;
            aligned_mantB = {1'b1, mantB};
            final_exp = expB;
        end

        // 2. 부호에 따른 덧셈/뺄셈
        if (signA == signB) begin
            sum_mantissa = aligned_mantA + aligned_mantB;
            final_sign = signA;
        end else begin
            if (aligned_mantA > aligned_mantB) begin
                sum_mantissa = aligned_mantA - aligned_mantB;
                final_sign = signA;
            end else begin
                sum_mantissa = aligned_mantB - aligned_mantA;
                final_sign = signB;
            end
        end

        // 3. 정규화
        if (sum_mantissa[8] == 1'b1) begin
            normalized_mantissa = sum_mantissa[7:1];
            final_exp = final_exp + 1;
        end else begin
            normalized_mantissa = sum_mantissa[6:0];
        end
        
        // 최종 결과 조합 시 비트 폭 명시
        S = {final_sign, final_exp, normalized_mantissa};
    end
endmodule