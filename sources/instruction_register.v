`timescale 1ns / 1ps

module instruction_register (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] instruction_in,
    output reg  [15:0] instruction_out
);

always @(posedge clk) begin
    if (rst)
        instruction_out <= 16'b0;
    else
        instruction_out <= instruction_in;
end

endmodule
