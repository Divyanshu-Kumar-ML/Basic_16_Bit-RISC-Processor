`timescale 1ns / 1ps

module tb_register_file;

    reg        clk;
    reg        rst;
    reg [2:0]  rs1;
    reg [2:0]  rs2;
    reg [2:0]  rd;
    reg [7:0]  write_data;
    reg        reg_write;

    wire [7:0] read_data1;
    wire [7:0] read_data2;

    register_file uut (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;
        reg_write = 0;

        // Reset register file
        #10;
        rst = 0;

        // Write 10 into R1
        rd = 3'b001;
        write_data = 8'd10;
        reg_write = 1;
        #10;

        // Write 4 into R2
        rd = 3'b010;
        write_data = 8'd4;
        reg_write = 1;
        #10;

        // Stop writing
        reg_write = 0;

        // Read R1 and R2 simultaneously
        rs1 = 3'b001;
        rs2 = 3'b010;
        #10;

        // Write 40 into R5
        rd = 3'b101;
        write_data = 8'd40;
        reg_write = 1;
        #10;

        // Read R5 and R1 simultaneously
        reg_write = 0;
        rs1 = 3'b101;
        rs2 = 3'b001;
        #10;

        $finish;
    end

endmodule