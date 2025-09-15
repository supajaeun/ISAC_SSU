module adder_18bit (
    input signed [17:0] A,
    input signed [17:0] B,
    output signed [18:0] S
);
    assign S = A + B;
endmodule