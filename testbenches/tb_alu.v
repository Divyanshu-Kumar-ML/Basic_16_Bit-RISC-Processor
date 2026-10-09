`timescale 1ns / 1ps

module tb_alu;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  [1:0] ALUOp;

    wire [7:0] result;
    wire Z, G, L;

    alu uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .result(result),
        .Z(Z),
        .G(G),
        .L(L)
    );

    initial begin

        // ADD: 6 + 4 = 10
        A = 8'd6;
        B = 8'd4;
        ALUOp = 2'b00;
        #10;

        // SUB: 6 - 4 = 2
        ALUOp = 2'b01;
        #10;

        // CMP: 10 > 2
        A = 8'd10;
        B = 8'd2;
        ALUOp = 2'b10;
        #10;

        // CMP: 2 < 10
        A = 8'd2;
        B = 8'd10;
        #10;

        // CMP: 5 == 5
        A = 8'd5;
        B = 8'd5;
        #10;

        $finish;
    end

endmodule
