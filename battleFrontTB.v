`timescale 1ns / 1ps

module BattleFrontTB;
	
	// Inputs
	reg clk, rst;
	reg Start, Ack;
	reg [8:0] unitLoc0, unitLoc1, unitLoc2, unitLoc3, unitLoc4; 
    reg [8:0] unitLoc5, unitLoc6, unitLoc7, unitLoc8, unitLoc9;
    reg [8:0] unitLoc10, unitLoc11, unitLoc12, unitLoc13, unitLoc14;
    reg [8:0] unitLoc15;
    reg [1:0] unitType0, unitType1, unitType2, unitType3, unitType4;
    reg [1:0] unitType5, unitType6, unitType7, unitType8, unitType9;
    reg [1:0] unitType10, unitType11, unitType12, unitType13, unitType14;
    reg [1:0] unitType15;
    reg [8:0] enemyLoc0, enemyLoc1, enemyLoc2, enemyLoc3, enemyLoc4;
    reg [8:0] enemyLoc5, enemyLoc6, enemyLoc7, enemyLoc8, enemyLoc9;
    reg [8:0] enemyLoc10, enemyLoc11, enemyLoc12, enemyLoc13, enemyLoc14;
    reg [8:0] enemyLoc15;
    reg [1:0] enemyType0, enemyType1, enemyType2, enemyType3, enemyType4;
    reg [1:0] enemyType5, enemyType6, enemyType7, enemyType8, enemyType9;
    reg [1:0] enemyType10, enemyType11, enemyType12, enemyType13, enemyType14;
    reg [1:0] enemyType15;
	
	// Outputs
	wire [8:0] friendlyFront, enemyFront;
	wire Done;
	
	// Test bench parameters
	integer clk_cnt, start_clk_cnt, clocks_taken;
	integer file_fd;
	
	// Inputs
	
	// Instantiate the Unit Under Test (UUT)	
   BattleFront uut (
	.clk(clk),
	.rst(rst),
	.Start(Start),
	.Ack(Ack),
	.unitLoc0(unitLoc0),
	.unitLoc1(unitLoc1),
	.unitLoc2(unitLoc2),
	.unitLoc3(unitLoc3),
	.unitLoc4(unitLoc4),
	.unitLoc5(unitLoc5),
	.unitLoc6(unitLoc6),
	.unitLoc7(unitLoc7),
	.unitLoc8(unitLoc8),
	.unitLoc9(unitLoc9),
	.unitLoc10(unitLoc10),
	.unitLoc11(unitLoc11),
	.unitLoc12(unitLoc12),
	.unitLoc13(unitLoc13),
	.unitLoc14(unitLoc14),
	.unitLoc15(unitLoc15),
	.unitType0(unitType0),
	.unitType1(unitType1),
	.unitType2(unitType2),
	.unitType3(unitType3),
	.unitType4(unitType4),
	.unitType5(unitType5),
	.unitType6(unitType6),
	.unitType7(unitType7),
	.unitType8(unitType8),
	.unitType9(unitType9),
	.unitType10(unitType10),
	.unitType11(unitType11),
	.unitType12(unitType12),
	.unitType13(unitType13),
	.unitType14(unitType14),
	.unitType15(unitType15),
	.enemyLoc0(enemyLoc0),
	.enemyLoc1(enemyLoc1),
	.enemyLoc2(enemyLoc2),
	.enemyLoc3(enemyLoc3),
	.enemyLoc4(enemyLoc4),
	.enemyLoc5(enemyLoc5),
	.enemyLoc6(enemyLoc6),
	.enemyLoc7(enemyLoc7),
	.enemyLoc8(enemyLoc8),
	.enemyLoc9(enemyLoc9),
	.enemyLoc10(enemyLoc10),
	.enemyLoc11(enemyLoc11),
	.enemyLoc12(enemyLoc12),
	.enemyLoc13(enemyLoc13),
	.enemyLoc14(enemyLoc14),
	.enemyLoc15(enemyLoc15),
	.enemyType0(enemyType0),
	.enemyType1(enemyType1),
	.enemyType2(enemyType2),
	.enemyType3(enemyType3),
	.enemyType4(enemyType4),
	.enemyType5(enemyType5),
	.enemyType6(enemyType6),
	.enemyType7(enemyType7),
	.enemyType8(enemyType8),
	.enemyType9(enemyType9),
	.enemyType10(enemyType10),
	.enemyType11(enemyType11),
	.enemyType12(enemyType12),
	.enemyType13(enemyType13),
	.enemyType14(enemyType14),
	.enemyType15(enemyType15),
	.friendlyFront(friendlyFront),
	.enemyFront(enemyFront),
	.Done(Done)
   );
		
		initial begin
			begin: CLOCK_GENERATOR
				clk = 0;
				forever begin
					#5 clk = ~ clk;
				end
			end
		end
		initial begin
			#0 rst = 0;
			#20 rst = 1;
			#20 rst = 0;
		end
		
		/*-------- clock counter --------*/
		always @(posedge clk) begin
			if(rst) begin
				clk_cnt = 0;
			end
			else begin
				clk_cnt = clk_cnt + 1;
			end
		end
		
		initial begin
		// Initialize Inputs
		Start = 0;
		Ack = 0;
		start_clk_cnt = 0;
		clocks_taken = 0;

		
		file_fd = $fopen("battleFrontTbOutput.txt", "w");

		// Wait 100 ns for global reset to finish
		#103;
			
		
		// Run the tests (run for 350 ns per test to run all)
		// No enemies or units
		APPLY_STIMULUS(0,
						0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Unit Locs
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // Unit types
						0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Enemy Locs
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Enemy types 
						
		APPLY_STIMULUS(0, // Expect Friendly Front = 474 and Enemy Front = 39
				0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Unit Locs
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, // Unit types
				0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Enemy Locs
				0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Enemy types 
				
				
		APPLY_STIMULUS(0, // Expect Friendly Front = 58 and Enemy Front = 487
				0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Unit Locs
				0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, // Unit types
				0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Enemy Locs
				0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0); // Enemy types 

					
		$fclose(file_fd);
		$display("All things processed.");
		
				


	end
	
	task APPLY_STIMULUS;
	input [5:0] testNum;
	input [8:0] unitLoc0in;
	input [8:0] unitLoc1in;
	input [8:0] unitLoc2in;
	input [8:0] unitLoc3in;
	input [8:0] unitLoc4in;
	input [8:0] unitLoc5in;
	input [8:0] unitLoc6in;
	input [8:0] unitLoc7in;
	input [8:0] unitLoc8in;
	input [8:0] unitLoc9in;
	input [8:0] unitLoc10in;
	input [8:0] unitLoc11in;
	input [8:0] unitLoc12in;
	input [8:0] unitLoc13in;
	input [8:0] unitLoc14in;
	input [8:0] unitLoc15in;
	input [1:0] unitType0in;
	input [1:0] unitType1in;
	input [1:0] unitType2in;
	input [1:0] unitType3in;
	input [1:0] unitType4in;
	input [1:0] unitType5in;
	input [1:0] unitType6in;
	input [1:0] unitType7in;
	input [1:0] unitType8in;
	input [1:0] unitType9in;
	input [1:0] unitType10in;
	input [1:0] unitType11in;
	input [1:0] unitType12in;
	input [1:0] unitType13in;
	input [1:0] unitType14in;
	input [1:0] unitType15in;
	input [8:0] enemyLoc0in;
	input [8:0] enemyLoc1in;
	input [8:0] enemyLoc2in;
	input [8:0] enemyLoc3in;
	input [8:0] enemyLoc4in;
	input [8:0] enemyLoc5in;
	input [8:0] enemyLoc6in;
	input [8:0] enemyLoc7in;
	input [8:0] enemyLoc8in;
	input [8:0] enemyLoc9in;
	input [8:0] enemyLoc10in;
	input [8:0] enemyLoc11in;
	input [8:0] enemyLoc12in;
	input [8:0] enemyLoc13in;
	input [8:0] enemyLoc14in;
	input [8:0] enemyLoc15in;
	input [1:0] enemyType0in;
	input [1:0] enemyType1in;
	input [1:0] enemyType2in;
	input [1:0] enemyType3in;
	input [1:0] enemyType4in;
	input [1:0] enemyType5in;
	input [1:0] enemyType6in;
	input [1:0] enemyType7in;
	input [1:0] enemyType8in;
	input [1:0] enemyType9in;
	input [1:0] enemyType10in;
	input [1:0] enemyType11in;
	input [1:0] enemyType12in;
	input [1:0] enemyType13in;
	input [1:0] enemyType14in;
	input [1:0] enemyType15in;
	begin
		// Assign the Inputs
		unitLoc0 = unitLoc0in;
		unitLoc1 = unitLoc1in;
		unitLoc2 = unitLoc2in;
		unitLoc3 = unitLoc3in;
		unitLoc4 = unitLoc4in;
		unitLoc5 = unitLoc5in;
		unitLoc6 = unitLoc6in;
		unitLoc7 = unitLoc7in;
		unitLoc8 = unitLoc8in;
		unitLoc9 = unitLoc9in;
		unitLoc10 = unitLoc10in;
		unitLoc11 = unitLoc11in;
		unitLoc12 = unitLoc12in;
		unitLoc13 = unitLoc13in;
		unitLoc14 = unitLoc14in;
		unitLoc15 = unitLoc15in;
		unitType0 = unitType0in;
		unitType1 = unitType1in;
		unitType2 = unitType2in;
		unitType3 = unitType3in;
		unitType4 = unitType4in;
		unitType5 = unitType5in;
		unitType6 = unitType6in;
		unitType7 = unitType7in;
		unitType8 = unitType8in;
		unitType9 = unitType9in;
		unitType10 = unitType10in;
		unitType11 = unitType11in;
		unitType12 = unitType12in;
		unitType13 = unitType13in;
		unitType14 = unitType14in;
		unitType15 = unitType15in;
		enemyLoc0 = enemyLoc0in;
		enemyLoc1 = enemyLoc1in;
		enemyLoc2 = enemyLoc2in;
		enemyLoc3 = enemyLoc3in;
		enemyLoc4 = enemyLoc4in;
		enemyLoc5 = enemyLoc5in;
		enemyLoc6 = enemyLoc6in;
		enemyLoc7 = enemyLoc7in;
		enemyLoc8 = enemyLoc8in;
		enemyLoc9 = enemyLoc9in;
		enemyLoc10 = enemyLoc10in;
		enemyLoc11 = enemyLoc11in;
		enemyLoc12 = enemyLoc12in;
		enemyLoc13 = enemyLoc13in;
		enemyLoc14 = enemyLoc14in;
		enemyLoc15 = enemyLoc15in;
		enemyType0 = enemyType0in;
		enemyType1 = enemyType1in;
		enemyType2 = enemyType2in;
		enemyType3 = enemyType3in;
		enemyType4 = enemyType4in;
		enemyType5 = enemyType5in;
		enemyType6 = enemyType6in;
		enemyType7 = enemyType7in;
		enemyType8 = enemyType8in;
		enemyType9 = enemyType9in;
		enemyType10 = enemyType10in;
		enemyType11 = enemyType11in;
		enemyType12 = enemyType12in;
		enemyType13 = enemyType13in;
		enemyType14 = enemyType14in;
		enemyType15 = enemyType15in;
	
		@(posedge clk);									
		
		// generate a Start pulse
		Start = 1;
		@(posedge clk);	
		Start = 0;
		
		// Start the clock
		start_clk_cnt = clk_cnt;
			
		// Wait until done
		wait(Done);
		clocks_taken = clk_cnt - start_clk_cnt;

		// generate and Ack pulse
		#5;
		Ack = 1;
		@(posedge clk);		
		Ack = 0;
		$fdisplay(file_fd, "In test number %d the friendlyFront is %d and the enemyFront is %d", testNum, friendlyFront, enemyFront);
		$fdisplay(file_fd, "It took %d clock(s) to compute the battlefront for test number %d", clocks_taken, testNum);
		#20;
	end
	endtask
	 
endmodule

