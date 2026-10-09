module multiplier (
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] product
);

assign product = A * B;

endmodule
