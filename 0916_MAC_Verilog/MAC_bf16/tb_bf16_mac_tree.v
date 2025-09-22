module tb_bf16_mac_tree;

    reg clk;
    reg reset;
    reg [15:0] in0, in1, in2, in3;
    reg [15:0] in4, in5, in6, in7;
    reg [15:0] in8, in9, in10, in11;
    reg [15:0] in12, in13, in14, in15;
    wire [15:0] out;

    // === DUT ===
    bf16_mac_tree uut (
        .clk(clk),
        .reset(reset),
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .in4(in4), .in5(in5), .in6(in6), .in7(in7),
        .in8(in8), .in9(in9), .in10(in10), .in11(in11),
        .in12(in12), .in13(in13), .in14(in14), .in15(in15),
        .out(out)
    );

    // === Clock generation ===
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    // === Expected value queue ===
    reg [15:0] expected_queue[0:31];  // 최대 32개 테스트
    reg [127:0] msg_queue[0:31];
    integer q_head = 0, q_tail = 0;

    // enqueue
    task push_expected(input [15:0] val, input [127:0] msg);
    begin
        expected_queue[q_tail] = val;
        msg_queue[q_tail] = msg;
        q_tail = q_tail + 1;
    end
    endtask

    // === 매 클럭마다 출력 확인 ===
    always @(posedge clk) begin
        if (!reset && q_head < q_tail) begin
            $display("%s", msg_queue[q_head]);
            $display("   Expected = %h, Got = %h", expected_queue[q_head], out);
            if (out === expected_queue[q_head])
                $display("   ✅ PASS\n");
            else
                $display("   ❌ FAIL\n");
            q_head = q_head + 1;
        end
    end

    // === Helper task (입력+expected enq, 2클럭 지연) ===
    task run_test(
        input [15:0] a0, a1, a2, a3,
        input [15:0] expected,
        input [127:0] msg
    );
    begin
        // 입력값 로드
        in0 = a0; in1 = a1;
        in2 = a2; in3 = a3;
        in4 = 0; in5 = 0; in6 = 0; in7 = 0;
        in8 = 0; in9 = 0; in10 = 0; in11 = 0;
        in12 = 0; in13 = 0; in14 = 0; in15 = 0;

        // 입력이 레지스터에 들어가고 파이프라인 latency = 2클럭 반영
        @(posedge clk);
        @(posedge clk);
        push_expected(expected, msg);
    end
    endtask

    // === Test sequence ===
    initial begin
        // Reset
        reset = 1;
        @(posedge clk);
        reset = 0;

        // === Test 1: Normal positive numbers ===
        run_test(16'h3f80, 16'h4000, 16'h4040, 16'h4080, 16'h4140, "Test 1: 1*2 + 3*4");

        // === Test 2: Negative numbers ===
        run_test(16'hbf80, 16'h4000, 16'h0000, 16'h0000, 16'hc000, "Test 2: -1*2 + 0*0");

        // === Test 3: Zero result ===
        run_test(16'h0000, 16'h40a0, 16'h0000, 16'h40c0, 16'h0000, "Test 3: Zero result");

        // === Test 4: Infinity ===
        run_test(16'h7f80, 16'h3f80, 16'h0000, 16'h0000, 16'h7f80, "Test 4: Inf*1");

        // === Test 5: NaN case (Inf - Inf) ===
        run_test(16'h7f80, 16'h3f80, 16'hff80, 16'h3f80, 16'h7fc1, "Test 5: Inf - Inf = NaN");

        // 출력이 다 나올 때까지 대기
        repeat(5) @(posedge clk);

        $display("=== All tests completed ===");
        $stop;
    end

endmodule
