`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:43:11 09/06/2021
// Design Name:   main
// Module Name:   C:/Users/rohan/Desktop/Work/Verilog/Processor/testbench3.v
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

//*****Find the factorial of number N store in location 200 and store result in 196
module testbench3;

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
		repeat(40)
		begin
       #5 clk1=1'b1 ; #5 clk1=1'b0;
       #5 clk2=1'b1;  #5 clk2=1'b0;		 
      end	
	end
	
	initial 
	begin
	for (k=0; k<31; k=k+1)
	  mips.Reg[k] = k;
	  
	 mips.Mem[0] = 32'h280a00c8; // ADDI R10,R0,200
    mips.Mem[1] = 32'h28020001; // ADDI R2,R0,1
	 mips.Mem[2] = 32'h0ce77800; //OR R7,R7,R7
    mips.Mem[3] = 32'h21430000; // LW R3,0(R10)   
	 mips.Mem[4] = 32'h0ce77800; // OR R7,R7,R7
	 mips.Mem[5] = 32'h14431000; //Loop: MUL R2,R2,R3
	 mips.Mem[6] = 32'h2c630001; //SUBI R3,R3,1
	 mips.Mem[7] = 32'h0ce77800; //OR R7,R7,R7
	 mips.Mem[8] = 32'h3460fffc; //BNEQZ R3,Loop 
	 // Here when we reach branch inst PC=9 so we need to go back to 5th stage so value of loop=-4  
	 mips.Mem[9] = 32'h2542fffe; //SW R2,-2(R10)
	 mips.Mem[10]= 32'hfc000000; //Hlt
	 
	 mips.Mem[200] = 5;
	 
	 mips.HALTED = 1'b0;
	 mips.PC = 1'b0;
	 mips.TAKEN_BRANCH = 1'b0;
	 
	 #800
	   $display("Mem[200] = %d  \nMem[198] = %d", mips.Mem[200], mips.Mem[198]);
      	 
	// #1000 $finish; 		 
	end
	initial begin
	$monitor( $time, "R2 = %d", mips.Reg[2]);
	end
	
	
      
endmodule

