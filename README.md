## Verilog code for a 32-bit pipelined MIPS processor.

 Combination of gate-level, dataflow and behavioural modelling.
 
 So I have made this 32-bit mips processor using verilog the software that I have used here is Xilinx<br>
 

Remarks:

- Instruction Memory for 32 32-bit MIPS instructions.
- 32 32-bit Data Memory locations.
- Instruction Memory consisting of arithmetic, logical, branch, jump, and memory-access instructions. Immediate arguments and argument registers are hard-coded.<br>**5-stage pipelining; stages are:**
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Writeback (WB)


