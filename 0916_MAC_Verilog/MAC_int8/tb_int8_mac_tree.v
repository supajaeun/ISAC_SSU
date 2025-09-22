`timescale 1ns/1ps

module tb_int8_mac_tree;

    // Clock and Reset signals
    reg clk;
    reg reset;

    // DUT inputs
    reg signed [7:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
    
    // DUT outputs
    wire signed [31:0] out;
    wire signed [15:0] prod0, prod1, prod2, prod3, prod4, prod5, prod6, prod7;
    wire signed [17:0] sum_level2_0, sum_level2_1;

    // A variable for the loop counter, declared in the Verilog way.
    integer i;
    
    // Expected result variable
    reg signed [31:0] expected_result;
    
    // 파이프라인 지연을 위한 레지스터
    reg signed [31:0] expected_result_reg [0:1];

    // UUT (Unit Under Test) Instantiation
    int8_mac_tree dut (
        .clk(clk),
        .reset(reset),
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .in4(in4), .in5(in5), .in6(in6), .in7(in7),
        .in8(in8), .in9(in9), .in10(in10), .in11(in11),
        .in12(in12), .in13(in13), .in14(in14), .in15(in15),
        .out(out),
        .prod0(prod0), .prod1(prod1), .prod2(prod2), .prod3(prod3),
        .prod4(prod4), .prod5(prod5), .prod6(prod6), .prod7(prod7),
        .sum_level2_0(sum_level2_0), .sum_level2_1(sum_level2_1)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Clock period is 20ns
    end

    // Apply Reset and Test Inputs
    initial begin
        reset = 1;
        @(posedge clk);
        reset = 0;

        // Run 10 test cases using a synchronous approach
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk); // Synchronize input changes to the clock edge

            // Assign random inputs and calculate expected result
            in0 = $urandom % 256 - 128; in1 = $urandom % 256 - 128;
            in2 = $urandom % 256 - 128; in3 = $urandom % 256 - 128;
            in4 = $urandom % 256 - 128; in5 = $urandom % 256 - 128;
            in6 = $urandom % 256 - 128; in7 = $urandom % 256 - 128;
            in8 = $urandom % 256 - 128; in9 = $urandom % 256 - 128;
            in10 = $urandom % 256 - 128; in11 = $urandom % 256 - 128;
            in12 = $urandom % 256 - 128; in13 = $urandom % 256 - 128;
            in14 = $urandom % 256 - 128; in15 = $urandom % 256 - 128;
            
            expected_result = (in0 * in1) + (in2 * in3) + (in4 * in5) + (in6 * in7)
                            + (in8 * in9) + (in10 * in11) + (in12 * in13) + (in14 * in15);

            // Pipeline the expected result to match the DUT's latency
            expected_result_reg[0] <= expected_result;
            expected_result_reg[1] <= expected_result_reg[0];

            // Wait for one clock cycle for the DUT's combinational logic to propagate
            @(posedge clk); 
            
            #1; // Wait for the final output to be stable

            // Display and check for correctness
            if (i >= 2) begin // The first valid output appears after 2 cycles
                $display("----------------------------------");
                $display("Iteration %0d:", i + 1);
                $display("Expected Result: %d", expected_result_reg[1]);
                $display("Final Result: %d", out);

                if (out == expected_result_reg[1]) begin
                    $display("Test PASSED! ✅");
                end else begin
                    $display("Test FAILED! ❌");
                end
            end
        end

        $stop;
    end
endmodule