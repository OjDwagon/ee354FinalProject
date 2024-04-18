`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:00 12/14/2017 
// Design Name: 
// Module Name:    vga_top 
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
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module BattleCatsTop(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnR,
	input BtnL,
	input BtnD,
	input Sw1,
	input Sw2, // these need to be Sw instead of SW
	input Sw3,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
	);
	wire Reset;
	assign Reset=BtnC;
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire up,down,left,right;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire rst;
	
	reg [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  	SSD_CATHODES;
	wire [1:0] 	ssdscan_clk;
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	// wire move_clk;
	// assign move_clk=DIV_CLK[0]; //slower clock to drive the movement of objects on the vga screen
	wire [11:0] background;
	
	// Stuff I'm adding
	
	// Core signals
	wire gameSCEN;
	wire damageCalcDone;
	wire battlefrontDone;
	wire battlefrontACK;
	wire damageCalcACK;
	wire moveSCEN, damageSCEN;
	
	// Unit and enemy location and type signals
	wire [8:0] unitLoc0, unitLoc1, unitLoc2, 
        unitLoc3, unitLoc4, unitLoc5, 
        unitLoc6, unitLoc7, unitLoc8, 
        unitLoc9, unitLoc10, unitLoc11, 
        unitLoc12, unitLoc13, unitLoc14, 
        unitLoc15, unitType0, unitType1, 
        unitType2, unitType3, unitType4, 
        unitType5, unitType6, unitType7, 
        unitType8, unitType9, unitType10, 
        unitType11, unitType12, unitType13, 
        unitType14, unitType15, enemyLoc0, 
        enemyLoc1, enemyLoc2, enemyLoc3, 
        enemyLoc4, enemyLoc5, enemyLoc6, 
        enemyLoc7, enemyLoc8, enemyLoc9, 
        enemyLoc10, enemyLoc11, enemyLoc12, 
        enemyLoc13, enemyLoc14, enemyLoc15, 
        enemyType0, enemyType1, enemyType2,
        enemyType3, enemyType4, enemyType5, 
        enemyType6, enemyType7, enemyType8, 
        enemyType9, enemyType10, enemyType11, 
        enemyType12, enemyType13, enemyType14, 
        enemyType15;
	
	
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
		
	// Attack signals comming from units and enemies
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
	
	assign purchase = 1'b1;
	
	
	GameEngine engine(.clk(ClkPort), .rst(rst), .gameSCEN(gameSCEN));
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
	.reset(rst),
	.damageCalcDone(damageCalcDone), 
	.battlefrontDone(battlefrontDone), 
	.gameSCEN(gameSEN), 
	.battlefrontACK(battlefrontACK),
	.damageCalcACK(damageCalcACK),
	.moveSCEN(moveSCEN), 
	.damageSCEN(damageSCEN));
	
	BattleFront battlefrontCalc(	
	.clk(ClkPort),
	.rst(rst),
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
		.rst(rst),
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
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage0),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc0),
		.damageOut(damageOut),
		.unitType(unitType0)
	);
	Unit unit1(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage1),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc1),
		.damageOut(damageOut),
		.unitType(unitType1)
	);
	Unit unit2(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage2),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc2),
		.damageOut(damageOut),
		.unitType(unitType2)
	);
	Unit unit3(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage3),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc3),
		.damageOut(damageOut),
		.unitType(unitType3)
	);
	Unit unit4(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage4),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc4),
		.damageOut(damageOut),
		.unitType(unitType4)
	);
	Unit unit5(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage5),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc5),
		.damageOut(damageOut),
		.unitType(unitType5)
	);
	Unit unit6(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage6),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc6),
		.damageOut(damageOut),
		.unitType(unitType6)
	);
	Unit unit7(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage7),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc7),
		.damageOut(damageOut),
		.unitType(unitType7)
	);	
	Unit unit8(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage8),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc8),
		.damageOut(damageOut),
		.unitType(unitType8)
	);
	Unit unit9(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage9),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc9),
		.damageOut(damageOut),
		.unitType(unitType9)
	);
	Unit unit10(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage10),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc10),
		.damageOut(damageOut),
		.unitType(unitType10)
	);
	Unit unit11(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage11),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc11),
		.damageOut(damageOut),
		.unitType(unitType11)
	);
	Unit unit12(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage12),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc12),
		.damageOut(damageOut),
		.unitType(unitType12)
	);
	Unit unit13(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage13),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc13),
		.damageOut(damageOut),
		.unitType(unitType13)
	);
	Unit unit14(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage14),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc14),
		.damageOut(damageOut),
		.unitType(unitType14)
	);
	Unit unit15(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(unitAppliedDamage15),
		.SW1(Sw1),
		.SW2(Sw2),
		.SW3(Sw3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		.position(unitLoc15),
		.damageOut(damageOut),
		.unitType(unitType15)
	);	

	Enemy enemy0(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage0),

		
		.unitFront(friendlyFront),
		.position(enemyLoc0),
		.damageOut(damageOut),
		.enemyType(enemyType0)
	);
	Enemy enemy1(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage1),

		
		.unitFront(friendlyFront),
		.position(enemyLoc1),
		.damageOut(damageOut),
		.enemyType(enemyType1)
	);
	Enemy enemy2(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage2),

		
		.unitFront(friendlyFront),
		.position(enemyLoc2),
		.damageOut(damageOut),
		.enemyType(enemyType2)
	);
	Enemy enemy3(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage3),

		
		.unitFront(friendlyFront),
		.position(enemyLoc3),
		.damageOut(damageOut),
		.enemyType(enemyType3)
	);
	Enemy enemy4(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage4),

		
		.unitFront(friendlyFront),
		.position(enemyLoc4),
		.damageOut(damageOut),
		.enemyType(enemyType4)
	);
	Enemy enemy5(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage5),

		
		.unitFront(friendlyFront),
		.position(enemyLoc5),
		.damageOut(damageOut),
		.enemyType(enemyType5)
	);
	Enemy enemy6(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage6),

		
		.unitFront(friendlyFront),
		.position(enemyLoc6),
		.damageOut(damageOut),
		.enemyType(enemyType6)
	);
	Enemy enemy7(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage7),

		
		.unitFront(friendlyFront),
		.position(enemyLoc7),
		.damageOut(damageOut),
		.enemyType(enemyType7)
	);	
	Enemy enemy8(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage8),

		
		.unitFront(friendlyFront),
		.position(enemyLoc8),
		.damageOut(damageOut),
		.enemyType(enemyType8)
	);
	Enemy enemy9(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage9),

		
		.unitFront(friendlyFront),
		.position(enemyLoc9),
		.damageOut(damageOut),
		.enemyType(enemyType9)
	);
	Enemy enemy10(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage10),

		
		.unitFront(friendlyFront),
		.position(enemyLoc10),
		.damageOut(damageOut),
		.enemyType(enemyType10)
	);
	Enemy enemy11(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage11),

		
		.unitFront(friendlyFront),
		.position(enemyLoc11),
		.damageOut(damageOut),
		.enemyType(enemyType11)
	);
	Enemy enemy12(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage12),

		
		.unitFront(friendlyFront),
		.position(enemyLoc12),
		.damageOut(damageOut),
		.enemyType(enemyType12)
	);
	Enemy enemy13(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage13),

		
		.unitFront(friendlyFront),
		.position(enemyLoc13),
		.damageOut(damageOut),
		.enemyType(enemyType13)
	);
	Enemy enemy14(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage14),

		
		.unitFront(friendlyFront),
		.position(enemyLoc14),
		.damageOut(damageOut),
		.enemyType(enemyType14)
	);
	Enemy enemy15(
		.clk(ClkPort), 
		//.gameClk(gameSCEN),
		.reset(rst),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(enemyAppliedDamage15),

		
		.unitFront(friendlyFront),
		.position(enemyLoc15),
		.damageOut(damageOut),
		.enemyType(enemyType15)
	);	

	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	// disable mamory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	
	//------------
// SSD (Seven Segment Display)
	// reg [3:0]	SSD;
	// wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	
	//SSDs display 
	//to show how we can interface our "game" module with the SSD's, we output the 12-bit rgb background value to the SSD's
	assign SSD3 = 4'b0000;
	assign SSD2 = background[11:8];
	assign SSD1 = background[7:4];
	assign SSD0 = background[3:0];


	// need a scan clk for the seven segment display 
	
	// 100 MHz / 2^18 = 381.5 cycles/sec ==> frequency of DIV_CLK[17]
	// 100 MHz / 2^19 = 190.7 cycles/sec ==> frequency of DIV_CLK[18]
	// 100 MHz / 2^20 =  95.4 cycles/sec ==> frequency of DIV_CLK[19]
	
	// 381.5 cycles/sec (2.62 ms per digit) [which means all 4 digits are lit once every 10.5 ms (reciprocal of 95.4 cycles/sec)] works well.
	
	//                  --|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |   
    //                    |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 
	//  DIV_CLK[17]       |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
	//
	//               -----|     |-----|     |-----|     |-----|     |
    //                    |  0  |  1  |  0  |  1  |     |     |     |     
	//  DIV_CLK[18]       |_____|     |_____|     |_____|     |_____|
	//
	//         -----------|           |-----------|           |
    //                    |  0     0  |  1     1  |           |           
	//  DIV_CLK[19]       |___________|           |___________|
	//

	assign ssdscan_clk = DIV_CLK[19:18];
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	=  !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	=  !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	// Turn off another 4 anodes
	assign {An7, An6, An5, An4} = 4'b1111;
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD = SSD0;
				  2'b01: SSD = SSD1;
				  2'b10: SSD = SSD2;
				  2'b11: SSD = SSD3;
		endcase 
	end

	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
		    //                                                                abcdefg,Dp
			4'b0000: SSD_CATHODES = 8'b00000010; // 0
			4'b0001: SSD_CATHODES = 8'b10011110; // 1
			4'b0010: SSD_CATHODES = 8'b00100100; // 2
			4'b0011: SSD_CATHODES = 8'b00001100; // 3
			4'b0100: SSD_CATHODES = 8'b10011000; // 4
			4'b0101: SSD_CATHODES = 8'b01001000; // 5
			4'b0110: SSD_CATHODES = 8'b01000000; // 6
			4'b0111: SSD_CATHODES = 8'b00011110; // 7
			4'b1000: SSD_CATHODES = 8'b00000000; // 8
			4'b1001: SSD_CATHODES = 8'b00001000; // 9
			4'b1010: SSD_CATHODES = 8'b00010000; // A
			4'b1011: SSD_CATHODES = 8'b11000000; // B
			4'b1100: SSD_CATHODES = 8'b01100010; // C
			4'b1101: SSD_CATHODES = 8'b10000100; // D
			4'b1110: SSD_CATHODES = 8'b01100000; // E
			4'b1111: SSD_CATHODES = 8'b01110000; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
	// reg [7:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

endmodule
