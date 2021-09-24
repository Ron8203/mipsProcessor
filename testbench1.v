`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:08:15 09/06/2021
// Design Name:   main
// Module Name:   C:/Users/rohan/Desktop/Work/Verilog/Processor/testbench1.v
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

//****** Load value from memory location 120 and add 45 to its data store the result in 121
module testbench1;

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
	  
	 mips.Mem[0] = 32'h28010078;  //ADDI R1,R0,120
    mips.Mem[1] = 32'h0ce77800;  //OR R7,R7,R7	Dummy instruction
	 mips.Mem[2] = 32'h20220000;  //LW R2, 0(R1)
    mips.Mem[3] = 32'h0ce77800;  //OR R7,R7,R7	Dummy instruction   
	 mips.Mem[4] = 32'h2842002d;  //ADDI R2,R2,45
	 mips.Mem[5] = 32'h0ce77800;  //OR R7,R7,R7	Dummy instruction
	 mips.Mem[6] = 32'h24220001;  //SW R2,1(R1)
	 mips.Mem[8] = 32'hfc000000;  //Hlt
	 
	 mips.Mem[120] = 85;
	 
	 mips.HALTED = 1'b0;
	 mips.PC = 1'b0;
	 mips.TAKEN_BRANCH = 1'b0;
	 
	 #200
	   $display("Mem[120] = %d  \nMem[121] = %d", mips.Mem[120], mips.Mem[121]);
	 #300 $finish; 		 
	end
	
	
      
endmodule

