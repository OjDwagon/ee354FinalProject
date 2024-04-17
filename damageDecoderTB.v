`timescale 1ns / 1ps

module DamageDecoderTB;
	
	// Inputs
	reg [4:0] unitDamageSelect;
	reg [4:0] enemyDamageSelect;
	reg [8:0] totalUnitDamage;
	reg [8:0] totalEnemyDamage;
	
	
	// Outputs
	wire [8:0] unitAppliedDamage0, unitAppliedDamage1, unitAppliedDamage2,
		unitAppliedDamage3, unitAppliedDamage4, unitAppliedDamage5,
		unitAppliedDamage6, unitAppliedDamage7, unitAppliedDamage8,
		unitAppliedDamage9, unitAppliedDamage10, unitAppliedDamage11,
		unitAppliedDamage12, unitAppliedDamage13, unitAppliedDamage14,
		unitAppliedDamage15, enemyAppliedDamage0, enemyAppliedDamage1,
		enemyAppliedDamage2, enemyAppliedDamage3, enemyAppliedDamage4,
		enemyAppliedDamage5, enemyAppliedDamage6, enemyAppliedDamage7,
		enemyAppliedDamage8, enemyAppliedDamage9, enemyAppliedDamage10,
		enemyAppliedDamage11, enemyAppliedDamage12, enemyAppliedDamage13,
		enemyAppliedDamage14, enemyAppliedDamage15, friendlyTowerAppliedDamage, 
		enemyTowerAppliedDamage;
	
	// Test bench parameters;
	integer file_fd;
	reg [4:0] tempUnitDamageSelect;
	reg [4:0] tempEnemyDamageSelect;
	
	// Inputs
	
	// Instantiate the Unit Under Test (UUT)	
   DamageDecoder uut (
	.unitDamageSelect(unitDamageSelect),
	.enemyDamageSelect(enemyDamageSelect),
	.totalUnitDamage(totalUnitDamage),
	.totalEnemyDamage(totalEnemyDamage),
	.unitAppliedDamage0(unitAppliedDamage0),
	.unitAppliedDamage1(unitAppliedDamage1),
	.unitAppliedDamage2(unitAppliedDamage2),
	.unitAppliedDamage3(unitAppliedDamage3),
	.unitAppliedDamage4(unitAppliedDamage4),
	.unitAppliedDamage5(unitAppliedDamage5),
	.unitAppliedDamage6(unitAppliedDamage6),
	.unitAppliedDamage7(unitAppliedDamage7),
	.unitAppliedDamage8(unitAppliedDamage8),
	.unitAppliedDamage9(unitAppliedDamage9),
	.unitAppliedDamage10(unitAppliedDamage10),
	.unitAppliedDamage11(unitAppliedDamage11),
	.unitAppliedDamage12(unitAppliedDamage12),
	.unitAppliedDamage13(unitAppliedDamage13),
	.unitAppliedDamage14(unitAppliedDamage14),
	.unitAppliedDamage15(unitAppliedDamage15),
	.enemyAppliedDamage0(enemyAppliedDamage0),
	.enemyAppliedDamage1(enemyAppliedDamage1),
	.enemyAppliedDamage2(enemyAppliedDamage2),
	.enemyAppliedDamage3(enemyAppliedDamage3),
	.enemyAppliedDamage4(enemyAppliedDamage4),
	.enemyAppliedDamage5(enemyAppliedDamage5),
	.enemyAppliedDamage6(enemyAppliedDamage6),
	.enemyAppliedDamage7(enemyAppliedDamage7),
	.enemyAppliedDamage8(enemyAppliedDamage8),
	.enemyAppliedDamage9(enemyAppliedDamage9),
	.enemyAppliedDamage10(enemyAppliedDamage10),
	.enemyAppliedDamage11(enemyAppliedDamage11),
	.enemyAppliedDamage12(enemyAppliedDamage12),
	.enemyAppliedDamage13(enemyAppliedDamage13),
	.enemyAppliedDamage14(enemyAppliedDamage14),
	.enemyAppliedDamage15(enemyAppliedDamage15),
	.friendlyTowerAppliedDamage(friendlyTowerAppliedDamage),
	.enemyTowerAppliedDamage(enemyTowerAppliedDamage)
   );
		
		
		
		initial begin
		// Initialize Inputs
		tempUnitDamageSelect = 0;
		tempEnemyDamageSelect = 0;

		file_fd = $fopen("damageDecoderTbOutput.txt", "w");

		// Wait 100 ns for global reset to finish
		#103;
			
		for(tempUnitDamageSelect = 0; tempUnitDamageSelect <= 16; tempUnitDamageSelect = tempUnitDamageSelect + 1)
		begin
			for(tempEnemyDamageSelect = 0; tempEnemyDamageSelect <= 16; tempEnemyDamageSelect = tempEnemyDamageSelect + 1)
			begin
				APPLY_STIMULUS(tempUnitDamageSelect, tempEnemyDamageSelect, 8'b1111_1111, 8'b1111_1111);
			end
		end

					
		$fclose(file_fd);
		$display("All things processed.");
		
				


	end
	
	task APPLY_STIMULUS;
	input [4:0] unitDamageSelectIn;
	input [4:0] enemyDamageSelectIn;
	input [8:0] totalUnitDamageIn;
	input [8:0] totalEnemyDamageIn;
	begin
		// Assign the Inputs
		unitDamageSelect = unitDamageSelectIn;
		enemyDamageSelect = enemyDamageSelectIn;
		totalUnitDamage = totalUnitDamageIn;
		totalEnemyDamage = totalEnemyDamageIn;
		
		#5;
		
		// $fdisplay(file_fd, "In test number %d the friendlyFront is %d and the enemyFront is %d", testNum, friendlyFront, enemyFront);
		// $fdisplay(file_fd, "It took %d clock(s) to compute the battlefront for test number %d", clocks_taken, testNum);
		#20;
	end
	endtask
	 
endmodule

