module multiplier_8bit (
    input signed [7:0] A,
    input signed [7:0] B,
    output signed [15:0] P
);

    assign P = A * B;

endmodule