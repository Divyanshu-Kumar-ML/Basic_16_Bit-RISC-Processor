`timescale 1ns / 1ps

module processor_fsm (
    input wire clk,
    input wire rst,
    input wire halt,
    output reg [2:0] state
);

localparam FETCH         = 3'b000;
localparam DECODE        = 3'b001;
localparam READ_OPERANDS = 3'b010;
localparam EXECUTE       = 3'b011;
localparam MEMORY_ACCESS = 3'b100;
localparam WRITE_BACK    = 3'b101;
localparam HALT_STATE    = 3'b110;

always @(posedge clk) begin

    if (rst)
        state <= FETCH;

    else begin
        case (state)

            FETCH:
                state <= DECODE;

            DECODE:
                state <= READ_OPERANDS;

            READ_OPERANDS:
                state <= EXECUTE;

            EXECUTE:
                state <= MEMORY_ACCESS;

            MEMORY_ACCESS:
                state <= WRITE_BACK;

            WRITE_BACK: begin
                if (halt)
                    state <= HALT_STATE;
                else
                    state <= FETCH;
            end

            HALT_STATE:
                state <= HALT_STATE;

            default:
                state <= FETCH;

        endcase
    end
end

endmodule