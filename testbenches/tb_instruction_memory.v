`timescale 1ns / 1ps

module tb_instruction_memory;

    reg  [7:0]  address;
    wire [15:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        address = 8'd0;
        #10;

        address = 8'd1;
        #10;

        address = 8'd2;
        #10;

        address = 8'd3;
        #10;

        address = 8'd4;
        #10;

        address = 8'd5;
        #10;

        address = 8'd6;
        #10;

        address = 8'd7;
        #10;

        $finish;
    end

endmodule
