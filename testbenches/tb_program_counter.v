`timescale 1ns / 1ps

`timescale 1ns / 1ps

module tb_program_counter;

    reg clk;
    reg rst;
    reg halt;
    reg pc_en;

    wire [7:0] pc;

    program_counter uut (
        .clk(clk),
        .rst(rst),
        .halt(halt),
        .pc_en(pc_en),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk   = 0;
        rst   = 1;
        halt  = 0;
        pc_en = 0;

        // Reset
        #10;
        rst = 0;

        // Normal execution
        pc_en = 1;

        // Increment for a few cycles
        #30;

        // Disable PC increment
        pc_en = 0;
        #10;

        // Test HALT
        halt = 1;
        pc_en = 1;
        #20;

        // Reset again
        halt = 0;
        rst = 1;
        #10;

        rst = 0;
        #10;

        $finish;
    end

endmodule