//////////////////////////////////////////////////////////////////////////////////
// Author:			Shideh Shahidi, Bilal Zafar, Gandhi Puvvada
// Create Date:   02/25/08, 10/13/08
// File Name:		ee201_GCD_tb.v 
// Description: 
//
//
// Revision: 		2.1
// Additional Comments:  
// 10/13/2008 Clock Enable (CEN) has been added by Gandhi
// 3/1/2010 Signal names are changed in line with the divider_verilog design
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module walletTB;

	// Inputs
	reg Clk, gameClk;
	reg Reset;
	reg purchase;
	reg [11:0] unitCost;

	// Outputs
	reg [1:0] level;
	reg [10:0] balance;
	reg maxed;
	reg buySucc;
	
	// Instantiate the Unit Under Test (UUT)
	Wallet (
		.Clk(Clk), 
		.gameClk(gameClk),
		.rst(Reset), 
		.purchase(purchase), 
		.unitCost(unitCost), 
		.level(level), 
		.balance(balance), 
		.maxed(maxed),
		.buySucc(buySucc),
	);
	
		initial begin
			begin: CLOCK_GENERATOR
				Clk = 0;
				forever begin
					#5 Clk = ~ Clk;
				end
			end
		end
		initial begin
			#0 Reset = 0;
			#20 Reset = 1;
			#20 Reset = 0;
		end
		
		/*-------- clock counter --------*/
		integer clk_cnt, start_clk_cnt, clocks_taken;
		always @(posedge Clk) begin
			if(Reset) begin
				clk_cnt = 0;
			end
			else begin
				clk_cnt = clk_cnt + 1;
			end
		end
		
		
		initial begin
		// Initialize Inputs
		CEN = 1; // ****** in Part 2 ******
				 // Here, in Part 1, we are enabling clock permanently by making CEN a '1' constantly.
				 // In Part 2, your TOP design provides single-stepping through SCEN control.
				 // We are not planning to write a testbench for the part 2 design. However, if we were 
				 // to write one, we will remove this line, and make CEN enabled and disabled to test 
				 // single stepping.
				 // One of the things you make sure in your core design (DUT) is that when state 
				 // transitions are stopped by making CEN = 0,
				 // the data transformations are also stopped.
		Start = 0;
		Ack = 0;
		Ain = 0;
		Bin = 0;
		start_clk_cnt = 0;
		clocks_taken = 0;
		tempA = 0;
		tempB = 0;


		// Wait 100 ns for global reset to finish
		#103;
			
		
		
		for(tempA = 2; tempA <= 63; tempA = tempA + 1)
		begin
			for(tempB = 2; tempB <= 63; tempB = tempB + 1)
			begin
				APPLY_STIMULUS(tempA, tempB);
			end
		end

		//APPLY_STIMULUS(36, 24);
		// Initialize Inputs
					


		
		//APPLY_STIMULUS(5, 15);
		// Initialize Inputs
				


	end
	
	task TICK_WALLET;
	begin
		@(posedge Clk);									
		
		// generate a Start pulse
		gameClk = 1;
		@(posedge Clk);
		# 1;
		gameClk = 0;

			
		wait(q_Done);
		clocks_taken = clk_cnt - start_clk_cnt;

		// generate and Ack pulse
		#5;
		Ack = 1;
		@(posedge Clk);		
		Ack = 0;
		$display("Ain: %d Bin: %d, GCD: %d", AinVal, BinVal, AB_GCD);
		$display("It took %d clock(s) to compute the GCD", clocks_taken);
		#20;
	end
	endtask
	
	always @(*)
		begin
			case ({q_I, q_Sub, q_Mult, q_Done})    // Note the concatenation operator {}
				4'b1000: state_string = "q_I   ";  // ****** TODO ******
				4'b0100: state_string = "q_Sub ";  // Fill-in the three lines
				4'b0010: state_string = "q_Mult";
				4'b0001: state_string = "q_Done";			
			endcase
		end
 
      
endmodule
