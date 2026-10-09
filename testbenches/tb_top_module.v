`timescale 1ns/1ps

module tb_top_module;

    reg clk;
    reg rst;
    reg [2:0] sw;

    wire [7:0] led;
    wire flag_Z;
    wire flag_G;
    wire flag_L;


    // =========================================================
    // DUT
    // =========================================================

    top_module uut (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .led(led),
        .flag_Z(flag_Z),
        .flag_G(flag_G),
        .flag_L(flag_L)
    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin
        clk = 1'b0;

        forever
            #5 clk = ~clk;
    end


    // =========================================================
    // TEST
    // =========================================================

    initial begin

        // Initial values
        rst = 1'b1;
        sw  = 3'b000;

        // Hold reset for two clock cycles
        #20;

        rst = 1'b0;

        // Run processor
        #500;

        // Select R1
        sw = 3'b001;
        #20;

        // Select R2
        sw = 3'b010;
        #20;

        // Select R3
        sw = 3'b011;
        #20;

        // Select R4
        sw = 3'b100;
        #20;

        // Select R5
        sw = 3'b101;
        #20;

        // Select R0
        sw = 3'b000;
        #20;

        $finish;

    end

endmodule
