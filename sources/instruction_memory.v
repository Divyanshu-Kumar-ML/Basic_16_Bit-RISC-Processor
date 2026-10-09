`timescale 1ns / 1ps

module instruction_memory (
    input  wire [7:0]  address,
    output reg  [15:0] instruction
);

    reg [15:0] memory [0:255];

    initial begin
        memory[0] = 16'b0110001000001010; // LOAD R1,10
        memory[1] = 16'b0110010000001011; // LOAD R2,11
        memory[2] = 16'b0001011001010000; // ADD R3,R1,R2
        memory[3] = 16'b0010100001010000; // SUB R4,R1,R2
        memory[4] = 16'b0011101011010000; // MUL R5,R3,R2
        memory[5] = 16'b0111101000010100; // STORE R5,20
        memory[6] = 16'b0100000011100000; // CMP R3,R4
        memory[7] = 16'b1111000000000000; // HALT
    end

    always @(*) begin
        instruction = memory[address];
    end

endmodule
