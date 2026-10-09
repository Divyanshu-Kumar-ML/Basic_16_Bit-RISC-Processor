module control_unit (
    input wire [3:0] opcode,

    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       ALUSrc,
    output reg [1:0] ALUOp,
    output reg [1:0] WBSel,
    output reg       MulEn,
    output reg       HaltEn
);

always @(*) begin

    // Default values
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    ALUSrc   = 1'b0;
    ALUOp    = 2'b00;
    WBSel    = 2'b00;
    MulEn    = 1'b0;
    HaltEn   = 1'b0;

    case (opcode)

        4'b0000: begin
            // NOP
        end

        4'b0001: begin
            // ADD
            RegWrite = 1'b1;
            ALUOp    = 2'b00;
            WBSel    = 2'b00;
        end

        4'b0010: begin
            // SUB
            RegWrite = 1'b1;
            ALUOp    = 2'b01;
            WBSel    = 2'b00;
        end

        4'b0011: begin
            // MUL
            RegWrite = 1'b1;
            WBSel    = 2'b01;
            MulEn    = 1'b1;
        end

        4'b0100: begin
            // CMP
            ALUOp = 2'b10;
        end

        4'b0101: begin
            // MOV
            RegWrite = 1'b1;
            WBSel    = 2'b11;
        end

        4'b0110: begin
            // LOAD
            RegWrite = 1'b1;
            MemRead  = 1'b1;
            WBSel    = 2'b10;
        end

        4'b0111: begin
            // STORE
            MemWrite = 1'b1;
        end

        4'b1111: begin
            // HALT
            HaltEn = 1'b1;
        end

        default: begin
            // All control signals remain at default values
        end

    endcase
end

endmodule
