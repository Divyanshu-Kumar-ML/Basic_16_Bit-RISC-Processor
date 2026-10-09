`timescale 1ns / 1ps

module alu (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [1:0] ALUOp,
    output reg  [7:0] result,
    output reg        Z,
    output reg        G,
    output reg        L
);

always @(*) begin

    // Default values
    result = 8'b0;
    Z      = 1'b0;
    G      = 1'b0;
    L      = 1'b0;

    case (ALUOp)

        // ADD
        2'b00: begin
            result = A + B;
        end

        // SUB
        2'b01: begin
            result = A - B;
        end

        // CMP
        2'b10: begin
            if (A == B)
                Z = 1'b1;
            else if (A > B)
                G = 1'b1;
            else
                L = 1'b1;
        end

        // Unused
        2'b11: begin
            result = 8'b0;
        end

    endcase

end

endmodule