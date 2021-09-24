`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:29 09/05/2021 
// Design Name: 
// Module Name:    main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main( clk1, clk2 );

input clk1, clk2;

reg [31:0] PC, IF_ID_NPC, IF_ID_IR;

reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;

reg [2:0]  ID_EX_type, EX_Mem_type, Mem_WB_type; 
//Here type is used to find the type of instruction weather it is register, immediate, branch,store ,load type

reg [31:0] EX_Mem_IR, EX_Mem_ALUout, EX_Mem_B;

reg EX_Mem_cond;

reg [31:0] Mem_WB_IR, Mem_WB_ALUout, Mem_WB_LMD;

// Memory and Regbank
reg [31:0] Reg[0:31];
reg [31:0] Mem[0:1023];

//Definiing opcode values
parameter ADD= 6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011, SLT=6'b000100, MUL=6'b000101, HLT=6'b111111, LW=6'b001000,
          SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011, SLTI=6'b001100, BNEQZ=6'b001101, BEQZ=6'b001110;
			 
//types
parameter RR_ALU=3'b000, RM_ALU=3'b001, Load=3'b010, Store= 3'b011, Branch = 3'b100, Halt=3'b101;

reg HALTED;
  // Set after hlt instruction is completed(in wb stage)

reg TAKEN_BRANCH;
  


// *****Instruction Fetch*****

always @(posedge clk1)

if(HALTED == 0)
 begin
 if(((EX_Mem_IR[31:26] == BEQZ) && (EX_Mem_cond == 1)) || ((EX_Mem_IR[31:26] == BNEQZ) && (EX_Mem_cond == 0)))
    begin
	 IF_ID_IR     <= #2 Mem[EX_Mem_ALUout];
	 TAKEN_BRANCH <= #2 1'b1;
	 IF_ID_NPC    <= #2 EX_Mem_ALUout + 1;
	 PC           <= #2 EX_Mem_ALUout + 1;
	 
	 // Here we need to give both npc and pc the address calculated by aluout as we are doing pipeling  
	 end
 
 else 
    begin
	 IF_ID_IR  <= #2 Mem[PC]; 
	 PC        <= #2 PC+1;
	 IF_ID_NPC <= #2 PC+1;
 	 end
 end

// ***** Instruction Decode****

always @(posedge clk2)
if(HALTED == 0)
 begin
 if (IF_ID_IR[26:21] == 5'b00000) ID_EX_A <=0; //r0=0 always
 else ID_EX_A <= #2 Reg[IF_ID_IR[25:21]]; //rs
 // Here Reg[IF_ID_IR[25:21]] means we are accessing the data stored in register IR whose value is given in bit [25:21] and give it to A
 
 if (IF_ID_IR[20:16] == 5'b00000) ID_EX_B <=0;
 else ID_EX_B <= #2 Reg[IF_ID_IR[20:16]]; //rt
 
 ID_EX_NPC <= #2 IF_ID_NPC;
 ID_EX_IR  <= #2 IF_ID_IR;
 ID_EX_Imm <= #2 {{16{IF_ID_IR[15]}} , {IF_ID_IR[15:0]}};
 // here we sign extend the 15th bit of IR to make Imm 32 bit 
 
 case(IF_ID_IR[31:26])
  ADD,SUB,MUL,OR,SLT,MUL: ID_EX_type <= #2 RR_ALU;
  ADDI,SUBI,SLTI:         ID_EX_type <= #2 RM_ALU;
  LW:                     ID_EX_type <= #2 Load;
  SW:                     ID_EX_type <= #2 Store;
  BNEQZ,BEQZ:             ID_EX_type <= #2 Branch;
  HLT:                    ID_EX_type <= #2 Halt;
  default:                ID_EX_type <= #2 Halt;
  
 endcase
 end
 
//*****Execution Stage****

always  @(posedge clk1 )
if (HALTED == 0 )
 begin
 EX_Mem_IR   <= #2 ID_EX_IR;
 EX_Mem_type <= #2 ID_EX_type;
 TAKEN_BRANCH <=#2 1'b0;
// WE need to disable instructions for 2 clk cycles if we use branch
 
 case (ID_EX_type)
  RR_ALU: begin
           case(ID_EX_IR[31:26])
			  ADD:     EX_Mem_ALUout <= #2 ID_EX_A + ID_EX_B;
           SUB:     EX_Mem_ALUout <= #2 ID_EX_A - ID_EX_B;
           AND:     EX_Mem_ALUout <= #2 ID_EX_A & ID_EX_B;
           OR:      EX_Mem_ALUout <= #2 ID_EX_A | ID_EX_B;
           SLT:     EX_Mem_ALUout <= #2 ID_EX_A < ID_EX_B;			  
			  MUL:     EX_Mem_ALUout <= #2 ID_EX_A * ID_EX_B;
			  default: EX_Mem_ALUout <= #2 32'hxxxxxxxx;  
			  endcase
			  end
			  
  RM_ALU:begin
           case(ID_EX_IR[31:26])
			  ADDI:     EX_Mem_ALUout <= #2 ID_EX_A + ID_EX_Imm;
           SUBI:     EX_Mem_ALUout <= #2 ID_EX_A - ID_EX_Imm;
           SLTI:     EX_Mem_ALUout <= #2 ID_EX_A & ID_EX_Imm;
           default: EX_Mem_ALUout <= #2 32'hxxxxxxxx;  
			  endcase
			  end
			  
   Load, Store:begin
                EX_Mem_ALUout <= #2 ID_EX_A + ID_EX_Imm;
					 EX_Mem_B      <= #2 ID_EX_B; 
			      end
					
	Branch:begin
	       EX_Mem_ALUout <= ID_EX_NPC + ID_EX_Imm;
			 EX_Mem_cond   <= (ID_EX_A == 0);
	       end
			  
 endcase			  
 end
 
 //*****MEM stage*****
 
 always @(posedge clk2)
 if (HALTED == 0)
 begin
 Mem_WB_type <= #2 EX_Mem_type;
 Mem_WB_IR   <= #2 EX_Mem_IR;
 
 case (EX_Mem_type)
  RR_ALU,RM_ALU:  Mem_WB_ALUout <= #2 EX_Mem_ALUout;
  
  Load:           Mem_WB_LMD    <= #2 Mem[EX_Mem_ALUout];
  
  Store:         if(TAKEN_BRANCH == 0) 
                  Mem[EX_Mem_ALUout] <= #2 EX_Mem_B;
        
  
                
 endcase
 end
 
always @(posedge clk1)
 begin
 if(TAKEN_BRANCH == 0)
 case(Mem_WB_type)
 RR_ALU: Reg[Mem_WB_IR[15:11]] <= #2 Mem_WB_ALUout;
 
 RM_ALU: Reg[Mem_WB_IR[20:16]] <= #2 Mem_WB_ALUout;
 
 Load:   Reg[Mem_WB_IR[20:16]] <= #2 Mem_WB_LMD;
 
 Halt:   HALTED                <=#2 1'b1;
 endcase
 end
 






endmodule
