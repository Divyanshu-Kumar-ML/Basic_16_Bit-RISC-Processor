module data_memory (
    input wire clk,
    input wire [8:0] address,
    input wire [7:0] data_in,
    input wire MemRead,
    input wire MemWrite,
    output reg [7:0] data_out
);

reg [7:0] memory [0:511];

initial begin
    memory[10] = 8'd6;
    memory[11] = 8'd4;
end

always @(posedge clk) begin

    if (MemWrite)
        memory[address] <= data_in;

    if (MemRead)
        data_out <= memory[address];
    else
        data_out <= 8'b0;

end

endmodule
