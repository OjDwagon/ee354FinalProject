`timescale 1ns / 1ps

module DamageCalcTB;
	
	// Inputs
	reg clk, rst;
	reg Start, Ack; 
	reg [7:0] unitAttack0, unitAttack1, unitAttack2,
			unitAttack3, unitAttack4, unitAttack5, 
			unitAttack6, unitAttack7, unitAttack8, 
			unitAttack9, unitAttack10, unitAttack11, 
			unitAttack12, unitAttack13, unitAttack14, 
			unitAttack15, enemyAttack0, enemyAttack1, 
			enemyAttack2, enemyAttack3, enemyAttack4, 
			enemyAttack5, enemyAttack6, enemyAttack7, 
			enemyAttack8, enemyAttack9, enemyAttack10, 
			enemyAttack11, enemyAttack12, enemyAttack13, 
			enemyAttack14, enemyAttack15;
	
	// Outputs
	wire [11:0] totalUnitDamage, totalEnemyDamage;
	wire Done;
	
	// Test bench parameters
	integer clk_cnt, start_clk_cnt, clocks_taken;
	integer file_fd;
	
	// Inputs
	
	// Instantiate the Unit Under Test (UUT)	
   DamageCalc uut (
	.clk(clk),
	.rst(rst),
	.Start(Start),
	.Ack(Ack),
	.unitAttack0(unitAttack0),
	.unitAttack1(unitAttack1),
	.unitAttack2(unitAttack2),
	.unitAttack3(unitAttack3),
	.unitAttack4(unitAttack4),
	.unitAttack5(unitAttack5),
	.unitAttack6(unitAttack6),
	.unitAttack7(unitAttack7),
	.unitAttack8(unitAttack8),
	.unitAttack9(unitAttack9),
	.unitAttack10(unitAttack10),
	.unitAttack11(unitAttack11),
	.unitAttack12(unitAttack12),
	.unitAttack13(unitAttack13),
	.unitAttack14(unitAttack14),
	.unitAttack15(unitAttack15),
	.enemyAttack0(enemyAttack0),
	.enemyAttack1(enemyAttack1),
	.enemyAttack2(enemyAttack2),
	.enemyAttack3(enemyAttack3),
	.enemyAttack4(enemyAttack4),
	.enemyAttack5(enemyAttack5),
	.enemyAttack6(enemyAttack6),
	.enemyAttack7(enemyAttack7),
	.enemyAttack8(enemyAttack8),
	.enemyAttack9(enemyAttack9),
	.enemyAttack10(enemyAttack10),
	.enemyAttack11(enemyAttack11),
	.enemyAttack12(enemyAttack12),
	.enemyAttack13(enemyAttack13),
	.enemyAttack14(enemyAttack14),
	.enemyAttack15(enemyAttack15),
	.totalUnitDamage(totalUnitDamage),
	.totalEnemyDamage(totalEnemyDamage),
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

		
		file_fd = $fopen("damageCalcTbOutput.txt", "w");

		// Wait 100 ns for global reset to finish
		#103;
			
		
		// Run the tests (run for 350 ns per test to run all)
		// Nominal test
		APPLY_STIMULUS(0,
						0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, // Unit Damages
						0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 0, 10, 10, 10); // Enemy Damages
		
		// No damage test
		APPLY_STIMULUS(0,
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // Unit Damages
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Enemy Damages
				
		/*	
		APPLY_STIMULUS(2, // Expect Friendly Front = 58 and Enemy Front = 487
				0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Unit Locs
				0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, // Unit types
				0, 32, 64, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 511, // Enemy Locs
				0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0); // Enemy types 
		*/
					
		$fclose(file_fd);
		$display("All things processed.");
		
				


	end
	
	task APPLY_STIMULUS;
	input [5:0] testNum;
	input [7:0] unitAttack0in;
	input [7:0] unitAttack1in;
	input [7:0] unitAttack2in;
	input [7:0] unitAttack3in;
	input [7:0] unitAttack4in;
	input [7:0] unitAttack5in;
	input [7:0] unitAttack6in;
	input [7:0] unitAttack7in;
	input [7:0] unitAttack8in;
	input [7:0] unitAttack9in;
	input [7:0] unitAttack10in;
	input [7:0] unitAttack11in;
	input [7:0] unitAttack12in;
	input [7:0] unitAttack13in;
	input [7:0] unitAttack14in;
	input [7:0] unitAttack15in;
	input [7:0] enemyAttack0in;
	input [7:0] enemyAttack1in;
	input [7:0] enemyAttack2in;
	input [7:0] enemyAttack3in;
	input [7:0] enemyAttack4in;
	input [7:0] enemyAttack5in;
	input [7:0] enemyAttack6in;
	input [7:0] enemyAttack7in;
	input [7:0] enemyAttack8in;
	input [7:0] enemyAttack9in;
	input [7:0] enemyAttack10in;
	input [7:0] enemyAttack11in;
	input [7:0] enemyAttack12in;
	input [7:0] enemyAttack13in;
	input [7:0] enemyAttack14in;
	input [7:0] enemyAttack15in;
	begin
		// Assign the Inputs
		unitAttack0 = unitAttack0in;
		unitAttack1 = unitAttack1in;
		unitAttack2 = unitAttack2in;
		unitAttack3 = unitAttack3in;
		unitAttack4 = unitAttack4in;
		unitAttack5 = unitAttack5in;
		unitAttack6 = unitAttack6in;
		unitAttack7 = unitAttack7in;
		unitAttack8 = unitAttack8in;
		unitAttack9 = unitAttack9in;
		unitAttack10 = unitAttack10in;
		unitAttack11 = unitAttack11in;
		unitAttack12 = unitAttack12in;
		unitAttack13 = unitAttack13in;
		unitAttack14 = unitAttack14in;
		unitAttack15 = unitAttack15in;
		enemyAttack0 = enemyAttack0in;
		enemyAttack1 = enemyAttack1in;
		enemyAttack2 = enemyAttack2in;
		enemyAttack3 = enemyAttack3in;
		enemyAttack4 = enemyAttack4in;
		enemyAttack5 = enemyAttack5in;
		enemyAttack6 = enemyAttack6in;
		enemyAttack7 = enemyAttack7in;
		enemyAttack8 = enemyAttack8in;
		enemyAttack9 = enemyAttack9in;
		enemyAttack10 = enemyAttack10in;
		enemyAttack11 = enemyAttack11in;
		enemyAttack12 = enemyAttack12in;
		enemyAttack13 = enemyAttack13in;
		enemyAttack14 = enemyAttack14in;
		enemyAttack15 = enemyAttack15in;
	
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
		$fdisplay(file_fd, "In test number %d the totalUnitDamage is %d and the totalEnemyDamage is %d", testNum, totalUnitDamage, totalEnemyDamage);
		$fdisplay(file_fd, "It took %d clock(s) to compute the damages for test number %d", clocks_taken, testNum);
		#20;
	end
	endtask
	 
endmodule

