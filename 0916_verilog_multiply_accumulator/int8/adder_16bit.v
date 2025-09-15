module adder_16bit (
    input signed [15:0] A,
    input signed [15:0] B,
    output signed [16:0] S
);
    
    assign S = A + B;

endmodule