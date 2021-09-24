`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:03:45 09/06/2021
// Design Name:   main
// Module Name:   C:/Users/rohan/Desktop/Work/Verilog/Processor/testbench2.v
// Project Name:  Processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

//*****Add 3 numbers 10,20,25 and store in R5
module testbench2;

	// Inputs
	reg clk1;
	reg clk2;
   integer k;
	// Instantiate the Unit Under Test (UUT)
	main mips (
		.clk1(clk1), 
		.clk2(clk2)
	);

	initial
	begin
		// Initialize Inputs
		clk1 = 1'b0;
		clk2 = 1'b0;
		repeat(20)
		begin
       #5 clk1=1'b1 ; #5 clk1=1'b0;
       #5 clk2=1'b1;  #5 clk2=1'b0;		 
      end	
	end
	
	initial 
	begin
	for (k=0; k<31; k=k+1)
	  mips.Reg[k] = k;
	  
	 mips.Mem[0] = 32'h2801000a;  //ADDI R1,R0,10
    mips.Mem[1] = 32'h28020014;  //ADDI R2,R0,20
	 mips.Mem[2] = 32'h28030019;  //ADDI R3,R0,25
    mips.Mem[3] = 32'h0ce77800;  //OR R7,R7,R7	Dummy instruction   
	 mips.Mem[4] = 32'h0ce77800;  //OR R7,R7,R7  Dummy  instruction
	 mips.Mem[5] = 32'h00222000;  //ADD R4,R1,R2
	 mips.Mem[6] = 32'h0ce77800;  //OR R7,R7,R7
//	Here we need dummy instruction as we are using R4 again in the next step so we need some clock cycles to update the register R4 so we use dummy inst 
	 mips.Mem[7] = 32'h00832800;  //ADD R5,R4,R3
 	 mips.Mem[8] = 32'hfc000000;  //Hlt
	 
	 mips.HALTED = 1'b0;
	 mips.PC = 1'b0;
	 mips.TAKEN_BRANCH = 1'b0;
	 
	 #200
	 for (k=0; k<6; k=k+1)
	   $display( "R%d = %d", k , mips.Reg[k]);
		
		
			 
	end
	
      
endmodule
