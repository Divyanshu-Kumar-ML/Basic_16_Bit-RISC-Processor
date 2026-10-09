`timescale 1ns / 1ps

module tb_control_unit;

    reg [3:0] opcode;

    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire [1:0] ALUOp;
    wire [1:0] WBSel;
    wire MulEn;
    wire HaltEn;

    control_unit uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .WBSel(WBSel),
        .MulEn(MulEn),
        .HaltEn(HaltEn)
    );

    initial begin

        // NOP
        opcode = 4'b0000;
        #10;

        // ADD
        opcode = 4'b0001;
        #10;

        // SUB
        opcode = 4'b0010;
        #10;

        // MUL
        opcode = 4'b0011;
        #10;

        // CMP
        opcode = 4'b0100;
        #10;

        // MOV
        opcode = 4'b0101;
        #10;

        // LOAD
        opcode = 4'b0110;
        #10;

        // STORE
        opcode = 4'b0111;
        #10;

        // HALT
        opcode = 4'b1111;
        #10;

        $finish;
    end

endmodule
