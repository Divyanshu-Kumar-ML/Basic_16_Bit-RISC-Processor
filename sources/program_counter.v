`timescale 1ns / 1ps

module program_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       halt,
    input  wire       pc_en,
    output reg  [7:0] pc
);

always @(posedge clk) begin
    if (rst)
        pc <= 8'b0;
    else if (halt)
        pc <= pc;
    else if (pc_en)
        pc <= pc + 8'b1;
end

endmodule