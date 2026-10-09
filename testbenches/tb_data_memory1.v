`timescale 1ns / 1ps

module tb_data_memory;

    reg clk;
    reg [8:0] address;
    reg [7:0] data_in;
    reg MemRead;
    reg MemWrite;

    wire [7:0] data_out;

    data_memory uut (
        .clk(clk),
        .address(address),
        .data_in(data_in),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .data_out(data_out)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initial values
        address = 9'd0;
        data_in = 8'd0;
        MemRead = 1'b0;
        MemWrite = 1'b0;

        // Read MEM[10] = 6
        #10;
        address = 9'd10;
        MemRead = 1'b1;
        #10;

        // Read MEM[11] = 4
        address = 9'd11;
        #10;

        // Write 40 to MEM[20]
        MemRead = 1'b0;
        MemWrite = 1'b1;
        address = 9'd20;
        data_in = 8'd40;
        #10;

        // Read MEM[20]
        MemWrite = 1'b0;
        MemRead = 1'b1;
        #10;

        $finish;
    end

endmodule