# 16-bit RISC Processor on FPGA (Boolean Board – Spartan-7)

A basic RISC processor with a **16-bit fixed instruction width and 8-bit datapath**, written in **Verilog**, simulated and implemented in **Xilinx Vivado**, and demonstrated on the **Boolean Board (XC7S50 Spartan-7)**.

Execution is sequential (non-pipelined) with no branch or jump instructions.
**Supported operations:** `NOP`, `ADD`, `SUB`, `MUL`, `CMP`, `MOV`, `LOAD`, `STORE`, `HALT`

## Specifications

| Parameter | Value |
|---|---|
| Data width | 8-bit |
| Instruction width | 16-bit fixed |
| Registers | R0–R7 (8-bit each) |
| Instruction memory | ROM/BRAM, addressed by PC |
| Data memory | 512 × 8-bit RAM (9-bit address) |
| Flags | Z, G, L (updated by `CMP` only) |
| Tool / Language | Vivado 2020.x / 2023.x, Verilog HDL |

## Modules

PC · Instruction Memory · Instruction Register · Register File (2 read, 1 write) · ALU (ADD/SUB/CMP) · Multiplier (8×8, lower 8 bits) · Data Memory · Control Unit · Processor Top (`risc_processor`)

## Instruction Set

**R-Type** (ADD, SUB, MUL, CMP, MOV, NOP)

| [15:12] | [11:9] | [8:6] | [5:3] | [2:0] |
|---|---|---|---|---|
| opcode | rd | rs1 | rs2 | `000` |

**M-Type** (LOAD, STORE)

| [15:12] | [11:9] | [8:0] |
|---|---|---|
| opcode | rd / rs | 9-bit address |

| Opcode | Mnemonic | Operation |
|---|---|---|
| `0000` | NOP | No operation |
| `0001` | ADD | `Rd <= Rs1 + Rs2` |
| `0010` | SUB | `Rd <= Rs1 - Rs2` |
| `0011` | MUL | `Rd <= (Rs1 × Rs2)[7:0]` |
| `0100` | CMP | Sets Z (equal), G (Rs1 > Rs2), L (Rs1 < Rs2) |
| `0101` | MOV | `Rd <= Rs1` |
| `0110` | LOAD | `Rd <= MEM[addr]` |
| `0111` | STORE | `MEM[addr] <= Rs` |
| `1111` | HALT | Freeze PC until reset |

## Execution Flow

Each instruction goes through six stages, one clock cycle each:
**Fetch → Decode → Read Operands → Execute → Memory Access → Write Back**, then `PC <= PC + 1`.

## Top-Level Ports

```verilog
module risc_processor (
    input        clk,      // positive-edge clock
    input        rst,      // synchronous active-HIGH reset
    input  [2:0] SW,       // register select for display
    output [7:0] LED,      // selected register value
    output       flag_Z,
    output       flag_G,
    output       flag_L
);
```

## Test Program

Initial data memory: `MEM[10] = 6`, `MEM[11] = 4`

| PC | Instruction | Encoding | Result |
|---|---|---|---|
| 0 | `LOAD R1, 10` | `0110_001_000001010` | R1 = 6 |
| 1 | `LOAD R2, 11` | `0110_010_000001011` | R2 = 4 |
| 2 | `ADD R3, R1, R2` | `0001_011_001_010_000` | R3 = 10 |
| 3 | `SUB R4, R1, R2` | `0010_100_001_010_000` | R4 = 2 |
| 4 | `MUL R5, R3, R2` | `0011_101_011_010_000` | R5 = 40 |
| 5 | `STORE R5, 20` | `0111_101_000010100` | MEM[20] = 40 |
| 6 | `CMP R3, R4` | `0100_000_011_100_000` | G=1, Z=0, L=0 |
| 7 | `HALT` | `1111_000_000_000_000` | PC frozen |


## Simulation

1. Add `src/` as design sources and `sim/` as simulation sources in Vivado.
2. Set `tb_risc_processor` as the simulation top.
3. Run **Behavioral Simulation** and check that PC counts 0 → 7 and freezes, registers hold R1=6, R2=4, R3=10, R4=2, R5=40, `MEM[20]=40`, and flags show `G=1, Z=0, L=0`.

<!-- ![Waveform](docs/waveform.png) -->

## FPGA Implementation

1. Add the `.xdc` file and map `clk`, `rst`, `SW[2:0]`, `LED[7:0]`, `flag_Z`, `flag_G`, `flag_L` to board pins.
2. Run **Synthesis → Implementation → Generate Bitstream**, then program the board.
3. Reset, let the program reach HALT, and use `SW[2:0]` to view each register on the LEDs. `flag_G` should be ON; `flag_Z` and `flag_L` OFF.


## Author

**Divyanshu** · Roll No: 23EC8032  
  Dept : ECE
[GitHub](https://github.com/Divyanshu-Kumar-ML)
