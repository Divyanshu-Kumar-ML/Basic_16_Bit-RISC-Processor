module top_module (
    input wire clk,
    input wire rst,
    input wire [2:0] sw,
    output wire [7:0] led,
    output wire flag_Z,
    output wire flag_G,
    output wire flag_L
);

    // =========================================================
    // 1. INTERNAL SIGNALS
    // =========================================================

    // FSM
    wire [2:0] state;

    // Program Counter
    wire [7:0] pc;
    wire pc_en;

    // Instruction Memory
    wire [15:0] instruction_mem;

    // Instruction Register
    wire [15:0] ir;
    wire [15:0] ir_input;

    // Instruction fields
    wire [3:0] opcode;

    // Register File
    wire [2:0] rs1_addr;
    wire [2:0] rs2_addr;
    wire [2:0] rd_addr;

    wire [7:0] reg_data1;
    wire [7:0] reg_data2;

    wire reg_write_actual;

    // Control Unit
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire [1:0] ALUOp;
    wire [1:0] WBSel;
    wire MulEn;
    wire HaltEn;

    // ALU
    wire [7:0] alu_result;
    wire alu_Z;
    wire alu_G;
    wire alu_L;

    // Multiplier
    wire [7:0] mul_result;

    // Data Memory
    wire [8:0] mem_address;
    wire [7:0] mem_write_data;
    wire [7:0] mem_read_data;

    wire mem_read_actual;
    wire mem_write_actual;

    // Write-back
    reg [7:0] write_data;

    // Stored CMP flags
    reg flag_Z_reg;
    reg flag_G_reg;
    reg flag_L_reg;


    // =========================================================
    // 2. INSTRUCTION FIELD EXTRACTION
    // =========================================================

    assign opcode = ir[15:12];

    assign rd_addr = ir[11:9];

    /*
       For normal R-type instructions:
           rs1 = IR[8:6]

       For STORE:
           source register = IR[11:9]

       Therefore, select the correct source register here.
    */
    assign rs1_addr = (opcode == 4'b0111) ?
                      ir[11:9] :
                      ir[8:6];


    /*
       For normal R-type instructions:
           rs2 = IR[5:3]

       During HALT, the processor does not need operands.
       Therefore SW[2:0] can be used to select a register
       for LED display.
    */
    assign rs2_addr = (state == 3'b110) ?
                      sw :
                      ir[5:3];


    // =========================================================
    // 3. FSM
    // =========================================================

    processor_fsm fsm_unit (
        .clk(clk),
        .rst(rst),
        .halt(HaltEn),
        .state(state)
    );


    // =========================================================
    // 4. PROGRAM COUNTER
    // =========================================================

    /*
       PC increments only during WRITE_BACK.

       State:
           101 = WRITE_BACK

       HALT instruction does not increment PC.
    */
    assign pc_en = (state == 3'b101) && !HaltEn;

    program_counter pc_unit (
        .clk(clk),
        .rst(rst),
        .halt(HaltEn),
        .pc_en(pc_en),
        .pc(pc)
    );


    // =========================================================
    // 5. INSTRUCTION MEMORY
    // =========================================================

    instruction_memory instruction_mem_unit (
        .address(pc),
        .instruction(instruction_mem)
    );


    // =========================================================
    // 6. INSTRUCTION REGISTER
    // =========================================================

    /*
       IR loads the instruction only during FETCH.

       During all other stages, IR feeds its own current
       value back to its input so that the instruction
       remains stable.
    */
    assign ir_input = (state == 3'b000) ?
                      instruction_mem :
                      ir;

    instruction_register ir_unit (
        .clk(clk),
        .rst(rst),
        .instruction_in(ir_input),
        .instruction_out(ir)
    );


    // =========================================================
    // 7. CONTROL UNIT
    // =========================================================

    control_unit control_unit_unit (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .WBSel(WBSel),
        .MulEn(MulEn),
        .HaltEn(HaltEn)
    );


    // =========================================================
    // 8. REGISTER FILE
    // =========================================================

    /*
       Register writing is allowed only during WRITE_BACK.
    */
    assign reg_write_actual =
           RegWrite && (state == 3'b101);

    register_file reg_file_unit (
        .clk(clk),
        .rst(rst),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .rd(rd_addr),
        .write_data(write_data),
        .reg_write(reg_write_actual),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );


    // =========================================================
    // 9. ALU
    // =========================================================

    /*
       Current ISA uses only register operands for arithmetic.

       ALUSrc is therefore 0 for all currently defined
       instructions.
    */
    alu alu_unit (
        .A(reg_data1),
        .B(reg_data2),
        .ALUOp(ALUOp),
        .result(alu_result),
        .Z(alu_Z),
        .G(alu_G),
        .L(alu_L)
    );


    // =========================================================
    // 10. MULTIPLIER
    // =========================================================

    multiplier multiplier_unit (
        .A(reg_data1),
        .B(reg_data2),
        .product(mul_result)
    );


    // =========================================================
    // 11. DATA MEMORY
    // =========================================================

    /*
       M-type instructions contain a 9-bit memory address.
    */
    assign mem_address = ir[8:0];

    /*
       STORE writes the value from the source register.
       For STORE, rs1_addr has already been selected as
       IR[11:9].
    */
    assign mem_write_data = reg_data1;

    /*
       Memory operations are allowed only during
       MEMORY_ACCESS stage.
    */
    assign mem_read_actual =
           MemRead && (state == 3'b100);

    assign mem_write_actual =
           MemWrite && (state == 3'b100);

    data_memory data_memory_unit (
        .clk(clk),
        .address(mem_address),
        .data_in(mem_write_data),
        .MemRead(mem_read_actual),
        .MemWrite(mem_write_actual),
        .data_out(mem_read_data)
    );


    // =========================================================
    // 12. WRITE-BACK MULTIPLEXER
    // =========================================================

    /*
       WBSel encoding:

           00 -> ALU result
           01 -> Multiplier result
           10 -> Data Memory result
           11 -> Register value (MOV)
    */
    always @(*) begin

        case (WBSel)

            2'b00:
                write_data = alu_result;

            2'b01:
                write_data = mul_result;

            2'b10:
                write_data = mem_read_data;

            2'b11:
                write_data = reg_data1;

            default:
                write_data = 8'b0;

        endcase

    end


    // =========================================================
    // 13. CMP FLAG REGISTER
    // =========================================================

    /*
       CMP is executed during EXECUTE stage.

       The ALU generates Z/G/L combinationally.
       These flags are stored here so that they remain
       unchanged until the next CMP instruction.
    */
    always @(posedge clk) begin

        if (rst) begin

            flag_Z_reg <= 1'b0;
            flag_G_reg <= 1'b0;
            flag_L_reg <= 1'b0;

        end

        else if ((state == 3'b011) &&
                 (opcode == 4'b0100)) begin

            flag_Z_reg <= alu_Z;
            flag_G_reg <= alu_G;
            flag_L_reg <= alu_L;

        end

    end


    // =========================================================
    // 14. OUTPUT FLAGS
    // =========================================================

    assign flag_Z = flag_Z_reg;
    assign flag_G = flag_G_reg;
    assign flag_L = flag_L_reg;


    // =========================================================
    // 15. LED OUTPUT
    // =========================================================

    /*
       During HALT, SW[2:0] selects one of R0-R7.

       rs2_addr is connected to SW during HALT,
       therefore reg_data2 contains the selected register.
    */
    assign led = (state == 3'b110) ?
                 reg_data2 :
                 8'b0;


endmodule
