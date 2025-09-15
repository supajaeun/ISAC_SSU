`timescale 1ns/1ps

module tb_bfloat16_mac_tree;

    reg [15:0] in0, in1, in2, in3, in4, in5, in6, in7;
    reg [15:0] in8, in9, in10, in11, in12, in13, in14, in15;
    wire [15:0] out;

    // DUT 인스턴스화
    bfloat16_mac_tree dut (
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .in4(in4), .in5(in5), .in6(in6), .in7(in7),
        .in8(in8), .in9(in9), .in10(in10), .in11(in11),
        .in12(in12), .in13(in13), .in14(in14), .in15(in15),
        .out(out)
    );

    initial begin
        $display("----------------------------------");
        $display("Starting bfloat16 Testbench");
        $display("----------------------------------");

        // 나경 학생 자료의 fp32 예시를 bfloat16으로 변환한 값 사용
        // (참고: bfloat16은 가수부가 7비트이므로 정밀도 손실이 발생합니다.)
        in0 = 16'h3F40; // 0.75
        in1 = 16'hBF40; // -0.75
        in2 = 16'hBCC1; // -0.1
        in3 = 16'h3F80; // 1.0
        in4 = 16'h4190; // 18.0
        in5 = 16'h3E4D; // 0.2
        in6 = 16'h3C23; // 0.01
        in7 = 16'h4120; // 10.0
        in8 = 16'h3F80; // 1.0
        in9 = 16'hBCB0; // -0.02
        in10 = 16'hBEBF; // -0.375
        in11 = 16'hBFF3; // -0.9
        in12 = 16'hBD40; // -0.05
        in13 = 16'h4120; // 10.0
        in14 = 16'h3D23; // 0.08
        in15 = 16'hBD40; // -0.05
        
        #10; // 충분한 지연 시간

        $display("--- Final Result ---");
        $display("Final Result (Hex): %h", out);
       // $display("Final Result (Decimal): %f", $bitstoshortreal(out));

        $finish;
    end
endmodule