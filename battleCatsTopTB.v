`timescale 1ns / 1ps

module BattleCatsTopTB;
	reg ClkPort;
	reg BtnC, BtnU, BtnR, BtnL, BtnD;

	wire [3:0] vgaR, vgaG, vgaB;
	
	reg Reset;
	wire bright;
	wire[9:0] hc, vc;
	wire [11:0] rgb;
	integer gameTickClock;
	integer I;
	
	assign bright = 1'b1;


	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
	initial begin
		begin: CLOCK_GENERATOR
			ClkPort = 0;
			forever begin
				#5 ClkPort = ~ ClkPort;
			end
		end
	end
	initial begin
		#0 Reset = 0;
		#20 Reset = 1;
		#20 Reset = 0;
	end
	
	wire [11:0] background;
	
	// Stuff I'm adding
	
	// Core signals
	reg gameSCEN;
	wire damageCalcDone;
	wire battlefrontDone;
	wire battlefrontACK;
	wire damageCalcACK;
	wire moveSCEN, damageSCEN;
	
		// Generate gameSCEN 
	reg [5:0] gameCounter;
	always @(posedge ClkPort, posedge Reset)
	begin
		if(Reset)
		begin
			gameCounter <= 0;
			gameSCEN <= 0;
		end
		else
		begin
			gameCounter <= gameCounter + 1;
			if(gameCounter == 6'b1111_11) gameSCEN <= 1;
			else gameSCEN <= 0;
		end
	end
	
	// Unit and enemy location signals
	wire [8:0] unitLoc0, unitLoc1, unitLoc2, 
        unitLoc3, unitLoc4, unitLoc5, 
        unitLoc6, unitLoc7, unitLoc8, 
        unitLoc9, unitLoc10, unitLoc11, 
        unitLoc12, unitLoc13, unitLoc14, 
        unitLoc15, enemyLoc0, enemyLoc1,
		enemyLoc2, enemyLoc3, enemyLoc4, enemyLoc5, enemyLoc6, 
        enemyLoc7, enemyLoc8, enemyLoc9, 
        enemyLoc10, enemyLoc11, enemyLoc12, 
        enemyLoc13, enemyLoc14, enemyLoc15;
	
	
	// Damage select, total damage, and front signals
	wire [8:0] friendlyFront, enemyFront;
	wire [4:0] unitDamageSelect, enemyDamageSelect;
	wire [11:0] totalUnitDamage, totalEnemyDamage;
	
	// Damage application signals (into units and enemies)
	wire [7:0] unitAppliedDamage0, unitAppliedDamage1, unitAppliedDamage2, 
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
		
	// Attack signals coming from units and enemies
	wire [7:0] unitAttack0, unitAttack1, unitAttack2, 
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
	
	// enemy and unit wiring (changed to 2 bits)
	wire [1:0] unitType0, unitType1, unitType2, unitType3,
	unitType4, unitType5, unitType6, unitType7, unitType8,
	unitType9, unitType10, unitType11, unitType12, unitType13,
	unitType14, unitType15, enemyType0, enemyType1, enemyType2,
	enemyType3, enemyType4, enemyType5, enemyType6, enemyType7,
	enemyType8, enemyType9, enemyType10, enemyType11, enemyType12,
	enemyType13, enemyType14, enemyType15;
	
	// Debouncer SCEN signals
	wire pauseCCEN;
	wire leftSCEN;
	wire rightSCEN;
	wire downSCEN;
	
	// the #(.N_dc(25)) part sets values for parameters inside the module definition for the debouncer.
	// separater from input/output wiring!
	ee201_debouncer #(.N_dc(5)) pause_debouncer(.CLK(ClkPort), .RESET(Reset), .PB(BtnU), .DPB(), .SCEN(), .MCEN(), .CCEN(pauseCCEN));
	ee201_debouncer #(.N_dc(5)) left_debouncer(.CLK(ClkPort), .RESET(Reset), .PB(BtnL), .DPB(), .SCEN(leftSCEN), .MCEN(), .CCEN());
	ee201_debouncer #(.N_dc(5)) right_debouncer(.CLK(ClkPort), .RESET(Reset), .PB(BtnR), .DPB(), .SCEN(rightSCEN), .MCEN(), .CCEN());
	ee201_debouncer #(.N_dc(5)) down_debouncer(.CLK(ClkPort), .RESET(Reset), .PB(BtnD), .DPB(), .SCEN(downSCEN), .MCEN(), .CCEN());
	
	// changing this to a cool down counter, so basically, you can only spawn a troop once you've reached 100
	
	reg enoughMoney;
	reg [15:0] money_counter;
	
	always@(posedge DIV_CLK[5], posedge Reset, posedge BtnR, posedge BtnL, posedge BtnD)
	begin : MONEY_COUNTER
		if(Reset) money_counter <= 0;
		else
			begin
				if(~pauseCCEN) begin // pausing the game should also pause the counter
					if(money_counter != 100) // stop incrementing when we reach the top
						money_counter <= money_counter + 1'b1;
						
					if(money_counter >= 100) enoughMoney <= 1'b1;
					else enoughMoney <= 1'b0;
					
					if((BtnR || BtnL || BtnD) && money_counter >= 100) money_counter <= 0;
					
				end
			end
	end
	
	wire [6:0] ssdOut;
	wire [3:0] anode;
	counter cnt(.clk(ClkPort), .displayNumber(money_counter), .anode(anode), .ssdOut(ssdOut));
	
	assign Dp = 1;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};
	
	wire [15:0] dead;
	wire [15:0] canSpawn;
	wire [15:0] unitGrants;
	
	assign canSpawn = unitGrants;
	
	PriorityResolver priorityresolver(.requestSignals(dead), .grantSignals(unitGrants));
	
	// GameEngine engine(.clk(ClkPort), .rst(Reset), .gameSCEN(gameSCEN), .debouncedBtnU(pauseCCEN));
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	renderer sc(.clk(ClkPort), .bright(bright), .gameSCEN(gameSCEN), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb), .background(background),
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
	.enemyType15(enemyType15));

	TopCore core(.clk(ClkPort),
	.reset(Reset),
	.damageCalcDone(damageCalcDone), 
	.battlefrontDone(battlefrontDone), 
	.gameSCEN(gameSCEN), 
	.battlefrontACK(battlefrontACK),
	.damageCalcACK(damageCalcACK),
	.moveSCEN(moveSCEN), 
	.damageSCEN(damageSCEN)
	);
	
	BattleFront battlefrontCalc(	
	.clk(ClkPort),
	.rst(Reset),
	.Start(gameSCEN),
	.Ack(battlefrontACK),
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
	.unitDamageSelect(unitDamageSelect),
	.enemyDamageSelect(enemyDamageSelect),
	.Done(battlefrontDone));
	
	DamageDecoder damageDecoder(
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
	
	DamageCalc damageCalc(
		.clk(ClkPort),
		.rst(Reset),
		.Start(damageSCEN),
		.Ack(damageCalcACK),
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
		.Done(damageCalcDone)
   );
   
	Unit unit0(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage0),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[0]), .dead(dead[0]),
		.enemyFront(enemyFront),
		.position(unitLoc0),
		.damageOut(unitAttack0),
		.unitType(unitType0)
	);
	Unit unit1(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage1),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[1]), .dead(dead[1]),
		.enemyFront(enemyFront),
		.position(unitLoc1),
		.damageOut(unitAttack1),
		.unitType(unitType1)
	);
	Unit unit2(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage2),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[2]), .dead(dead[2]),
		.enemyFront(enemyFront),
		.position(unitLoc2),
		.damageOut(unitAttack2),
		.unitType(unitType2)
	);
	Unit unit3(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage3),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[3]), .dead(dead[3]),
		.enemyFront(enemyFront),
		.position(unitLoc3),
		.damageOut(unitAttack3),
		.unitType(unitType3)
	);
	Unit unit4(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage4),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[4]), .dead(dead[4]),
		.enemyFront(enemyFront),
		.position(unitLoc4),
		.damageOut(unitAttack4),
		.unitType(unitType4)
	);
	Unit unit5(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage5),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[5]), .dead(dead[5]),
		.enemyFront(enemyFront),
		.position(unitLoc5),
		.damageOut(unitAttack5),
		.unitType(unitType5)
	);
	Unit unit6(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage6),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[6]), .dead(dead[6]),
		.enemyFront(enemyFront),
		.position(unitLoc6),
		.damageOut(unitAttack6),
		.unitType(unitType6)
	);
	Unit unit7(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage7),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[7]), .dead(dead[7]),
		.enemyFront(enemyFront),
		.position(unitLoc7),
		.damageOut(unitAttack7),
		.unitType(unitType7)
	);	
	Unit unit8(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage8),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[8]), .dead(dead[8]),
		.enemyFront(enemyFront),
		.position(unitLoc8),
		.damageOut(unitAttack8),
		.unitType(unitType8)
	);
	Unit unit9(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage9),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[9]), .dead(dead[9]),
		.enemyFront(enemyFront),
		.position(unitLoc9),
		.damageOut(unitAttack9),
		.unitType(unitType9)
	);
	Unit unit10(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage10),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[10]), .dead(dead[10]),
		.enemyFront(enemyFront),
		.position(unitLoc10),
		.damageOut(unitAttack10),
		.unitType(unitType10)
	);
	Unit unit11(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage11),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[11]), .dead(dead[11]),
		.enemyFront(enemyFront),
		.position(unitLoc11),
		.damageOut(unitAttack11),
		.unitType(unitType11)
	);
	Unit unit12(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage12),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[12]), .dead(dead[12]),
		.enemyFront(enemyFront),
		.position(unitLoc12),
		.damageOut(unitAttack12),
		.unitType(unitType12)
	);
	Unit unit13(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage13),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[13]), .dead(dead[13]),
		.enemyFront(enemyFront),
		.position(unitLoc13),
		.damageOut(unitAttack13),
		.unitType(unitType13)
	);
	Unit unit14(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage14),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[14]), .dead(dead[14]),
		.enemyFront(enemyFront),
		.position(unitLoc14),
		.damageOut(unitAttack14),
		.unitType(unitType14)
	);
	Unit unit15(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage15),
		.leftSCEN(leftSCEN),
		.rightSCEN(rightSCEN),
		.downSCEN(downSCEN),
		.canSpawn(canSpawn[15]), .dead(dead[15]),
		.enemyFront(enemyFront),
		.position(unitLoc15),
		.damageOut(unitAttack15),
		.unitType(unitType15)
	);

	wire [15:0] enemyDead;
	wire [15:0] enemyCanSpawn;
	wire [15:0] enemyGrants;
	
	PriorityResolver enemy_priorityresolver(.requestSignals(enemyDead), .grantSignals(enemyGrants));
	
	/*
	assign enemyCanSpawn = enemyGrants & 
	{DIV_CLK[22], DIV_CLK[5], DIV_CLK[4], DIV_CLK[3],
	DIV_CLK[20], DIV_CLK[6], DIV_CLK[7], DIV_CLK[27],
	DIV_CLK[19], DIV_CLK[10], DIV_CLK[8], DIV_CLK[21],
	DIV_CLK[24], DIV_CLK[16], DIV_CLK[26], DIV_CLK[25]};
	*/
	assign enemyCanSpawn = 16'hffff;
	Enemy enemy0(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage0),
		.unitFront(friendlyFront),
		.position(enemyLoc0),
		.damageOut(enemyAttack0),
		.enemyType(enemyType0),
		.dead(enemyDead[0]), .canSpawn(enemyCanSpawn[0])
	);
	Enemy enemy1(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage1),
		.unitFront(friendlyFront),
		.position(enemyLoc1),
		.damageOut(enemyAttack1),
		.enemyType(enemyType1),
		.dead(enemyDead[1]), .canSpawn(enemyCanSpawn[1])
	);
	Enemy enemy2(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage2),		
		.unitFront(friendlyFront),
		.position(enemyLoc2),
		.damageOut(enemyAttack2),
		.enemyType(enemyType2),
		.dead(enemyDead[2]), .canSpawn(enemyCanSpawn[2])
	);
	Enemy enemy3(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage3),
		.unitFront(friendlyFront),
		.position(enemyLoc3),
		.damageOut(enemyAttack3),
		.enemyType(enemyType3),
		.dead(enemyDead[3]), .canSpawn(enemyCanSpawn[3])
	);
	Enemy enemy4(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage4),
		.unitFront(friendlyFront),
		.position(enemyLoc4),
		.damageOut(enemyAttack4),
		.enemyType(enemyType4),
		.dead(enemyDead[4]), .canSpawn(enemyCanSpawn[4])
	);
	Enemy enemy5(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage5),		
		.unitFront(friendlyFront),
		.position(enemyLoc5),
		.damageOut(enemyAttack5),
		.enemyType(enemyType5),
		.dead(enemyDead[5]), .canSpawn(enemyCanSpawn[5])
	);
	Enemy enemy6(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage6),		
		.unitFront(friendlyFront),
		.position(enemyLoc6),
		.damageOut(enemyAttack6),
		.enemyType(enemyType6),
		.dead(enemyDead[6]), .canSpawn(enemyCanSpawn[6])
	);
	Enemy enemy7(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage7),	
		.unitFront(friendlyFront),
		.position(enemyLoc7),
		.damageOut(enemyAttack7),
		.enemyType(enemyType7),
		.dead(enemyDead[7]), .canSpawn(enemyCanSpawn[7])
	);	
	Enemy enemy8(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage8),		
		.unitFront(friendlyFront),
		.position(enemyLoc8),
		.damageOut(enemyAttack8),
		.enemyType(enemyType8),
		.dead(enemyDead[8]), .canSpawn(enemyCanSpawn[8])
	);
	Enemy enemy9(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage9),		
		.unitFront(friendlyFront),
		.position(enemyLoc9),
		.damageOut(enemyAttack9),
		.enemyType(enemyType9),
		.dead(enemyDead[9]), .canSpawn(enemyCanSpawn[9])
	);
	Enemy enemy10(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage10),		
		.unitFront(friendlyFront),
		.position(enemyLoc10),
		.damageOut(enemyAttack10),
		.enemyType(enemyType10),
		.dead(enemyDead[10]), .canSpawn(enemyCanSpawn[10])
	);
	Enemy enemy11(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage11),
		.unitFront(friendlyFront),
		.position(enemyLoc11),
		.damageOut(enemyAttack11),
		.enemyType(enemyType11),
		.dead(enemyDead[11]), .canSpawn(enemyCanSpawn[11])
	);
	Enemy enemy12(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage12),
		.unitFront(friendlyFront),
		.position(enemyLoc12),
		.damageOut(enemyAttack12),
		.enemyType(enemyType12),
		.dead(enemyDead[12]), .canSpawn(enemyCanSpawn[12])
	);
	Enemy enemy13(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage13),
		.unitFront(friendlyFront),
		.position(enemyLoc13),
		.damageOut(enemyAttack13),
		.enemyType(enemyType13),
		.dead(enemyDead[13]), .canSpawn(enemyCanSpawn[13])
	);
	Enemy enemy14(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage14),
		.unitFront(friendlyFront),
		.position(enemyLoc14),
		.damageOut(enemyAttack14),
		.enemyType(enemyType14),
		.dead(enemyDead[14]), .canSpawn(enemyCanSpawn[14])
	);
	Enemy enemy15(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(Reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage15),		
		.unitFront(friendlyFront),
		.position(enemyLoc15),
		.damageOut(enemyAttack15),
		.enemyType(enemyType15),
		.dead(enemyDead[15]), .canSpawn(enemyCanSpawn[15])
	);	
	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	initial begin
		BtnC = 1'b0;
		BtnU = 1'b0;
		BtnR = 1'b0;
		BtnL = 1'b0;
		BtnD = 1'b0;
		SPAWN_UNIT();
		for(gameTickClock = 0; gameTickClock < 520; gameTickClock = gameTickClock + 1)
		begin
			@(posedge gameSCEN);
		end
		$display("%d game ticks have passed.", gameTickClock);
		for(I = 0; I < 10; I = I + 1)
		begin
			SPAWN_UNIT();
		end
		$display("Units have been spawned");
		
	end
	
	
	task SPAWN_UNIT;
	begin
		@(posedge gameSCEN);									
		#1;
		BtnD = 1'b1;
		@(posedge downSCEN);
		#1;
		BtnD = 1'b0;
		#100;
	end
	endtask
	
endmodule
