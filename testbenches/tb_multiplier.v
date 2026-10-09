`timescale 1ns / 1ps

module tb_multiplier;

    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] product;

    multiplier uut (
        .A(A),
        .B(B),
        .product(product)
    );

    initial begin

        // Test 1: 10 × 4 = 40
        A = 8'd10;
        B = 8'd4;
        #10;

        // Test 2: 6 × 4 = 24
        A = 8'd6;
        B = 8'd4;
        #10;

        // Test 3: 15 × 10 = 150
        A = 8'd15;
        B = 8'd10;
        #10;

        // Test 4: demonstrate lower 8-bit behavior
        A = 8'd200;
        B = 8'd2;
        #10;

        $finish;
    end

endmodule