`timescale 1ns/1ps

module tb_int8_mac_tree;

    // DUT의 입력 신호는 reg 타입으로 선언
    reg signed [7:0] in [0:15];
    // DUT의 출력 신호는 wire 타입으로 선언
    wire signed [31:0] out;

    // 추가된 중간 결과를 위한 wire 선언
    wire signed [15:0] prod0, prod1, prod2, prod3, prod4, prod5, prod6, prod7;
    wire signed [17:0] sum_level2_0, sum_level2_1;

    // 자체 검증을 위한 변수
    reg signed [31:0] expected_result;
    integer i; // for loop를 위한 변수

    // DUT (Design Under Test) 인스턴스화
    int8_mac_tree dut (
        .in0(in[0]), .in1(in[1]), .in2(in[2]), .in3(in[3]),
        .in4(in[4]), .in5(in[5]), .in6(in[6]), .in7(in[7]),
        .in8(in[8]), .in9(in[9]), .in10(in[10]), .in11(in[11]),
        .in12(in[12]), .in13(in[13]), .in14(in[14]), .in15(in[15]),
        .out(out),
        .prod0(prod0), .prod1(prod1), .prod2(prod2), .prod3(prod3),
        .prod4(prod4), .prod5(prod5), .prod6(prod6), .prod7(prod7),
        .sum_level2_0(sum_level2_0), .sum_level2_1(sum_level2_1)
    );

    initial begin
        $display("----------------------------------");
        $display("Starting Testbench");
        $display("----------------------------------");

        // 총 10개의 랜덤 테스트 케이스 실행
        for (i = 0; i < 10; i = i + 1) begin
            // 모든 입력에 랜덤 값 할당
            in[0] = $random; in[1] = $random;
            in[2] = $random; in[3] = $random;
            in[4] = $random; in[5] = $random;
            in[6] = $random; in[7] = $random;
            in[8] = $random; in[9] = $random;
            in[10] = $random; in[11] = $random;
            in[12] = $random; in[13] = $random;
            in[14] = $random; in[15] = $random;

            expected_result = (in[0] * in[1]) + (in[2] * in[3]) + (in[4] * in[5]) + (in[6] * in[7])
                            + (in[8] * in[9]) + (in[10] * in[11]) + (in[12] * in[13]) + (in[14] * in[15]);
            
            #10; // 연산 완료를 위한 충분한 시간 대기

        // 자체 검증 (출력 메시지 수정)
            if (out == expected_result) begin
                $display("Test Case %d: PASSED! Expected: %d, Got: %d", i, expected_result, out);
            end else begin
                $display("Test Case %d: FAILED! Expected: %d, Got: %d", i, expected_result, out);
            end
        end

        $display("----------------------------------");
        $display("All Tests Completed.");
        $display("----------------------------------");
        $finish;
    end
endmodule