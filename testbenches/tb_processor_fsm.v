`timescale 1ns / 1ps

module tb_processor_fsm;

    reg clk;
    reg rst;
    reg halt;

    wire [2:0] state;

    processor_fsm uut (
        .clk(clk),
        .rst(rst),
        .halt(halt),
        .state(state)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initial values
        rst  = 1;
        halt = 0;

        // Reset
        #10;
        rst = 0;

        // Normal FSM operation
        #60;

        // Assert HALT
        halt = 1;

        // Allow FSM to reach HALT_STATE
        #60;

        // Reset from HALT_STATE
        rst = 1;
        #10;

        rst = 0;

        // Verify FSM starts again from FETCH
        #30;

        $finish;

    end

endmodule