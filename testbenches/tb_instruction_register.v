`timescale 1ns / 1ps

module tb_instruction_register;

    reg        clk;
    reg        rst;
    reg [15:0] instruction_in;

    wire [15:0] instruction_out;

    instruction_register uut (
        .clk(clk),
        .rst(rst),
        .instruction_in(instruction_in),
        .instruction_out(instruction_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        instruction_in = 16'h0000;

        // Reset
        #10;
        rst = 0;

        // Apply first instruction
        instruction_in = 16'h620A;
        #10;

        // Apply second instruction
        instruction_in = 16'h640B;
        #10;

        // Apply third instruction
        instruction_in = 16'h1650;
        #10;

        // Reset again
        rst = 1;
        #10;

        rst = 0;
        #10;

        $finish;
    end

endmodule
