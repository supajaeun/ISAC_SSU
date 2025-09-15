module adder_17bit (
    input signed [16:0] A,
    input signed [16:0] B,
    output signed [17:0] S
);

    assign S = A + B;

endmodule