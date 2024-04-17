`timescale 1ns / 1ps


module DamageDecoder(
	input [4:0] unitDamageSelect,
	input [4:0] enemyDamageSelect,
	input [8:0] totalUnitDamage,
	input [8:0] totalEnemyDamage,
	output reg [8:0] unitAppliedDamage0,
	output reg [8:0] unitAppliedDamage1,
	output reg [8:0] unitAppliedDamage2,
	output reg [8:0] unitAppliedDamage3,
	output reg [8:0] unitAppliedDamage4,
	output reg [8:0] unitAppliedDamage5,
	output reg [8:0] unitAppliedDamage6,
	output reg [8:0] unitAppliedDamage7,
	output reg [8:0] unitAppliedDamage8,
	output reg [8:0] unitAppliedDamage9,
	output reg [8:0] unitAppliedDamage10,
	output reg [8:0] unitAppliedDamage11,
	output reg [8:0] unitAppliedDamage12,
	output reg [8:0] unitAppliedDamage13,
	output reg [8:0] unitAppliedDamage14,
	output reg [8:0] unitAppliedDamage15,
	output reg [8:0] enemyAppliedDamage0,
	output reg [8:0] enemyAppliedDamage1,
	output reg [8:0] enemyAppliedDamage2,
	output reg [8:0] enemyAppliedDamage3,
	output reg [8:0] enemyAppliedDamage4,
	output reg [8:0] enemyAppliedDamage5,
	output reg [8:0] enemyAppliedDamage6,
	output reg [8:0] enemyAppliedDamage7,
	output reg [8:0] enemyAppliedDamage8,
	output reg [8:0] enemyAppliedDamage9,
	output reg [8:0] enemyAppliedDamage10,
	output reg [8:0] enemyAppliedDamage11,
	output reg [8:0] enemyAppliedDamage12,
	output reg [8:0] enemyAppliedDamage13,
	output reg [8:0] enemyAppliedDamage14,
	output reg [8:0] enemyAppliedDamage15,
	output reg [8:0] friendlyTowerAppliedDamage,
	output reg [8:0] enemyTowerAppliedDamage
   );
	
	// 17 to 1 decoder for applying damage to the correct unit (or tower)
	always @(*)
	begin: Unit_Mux_17_1
        unitAppliedDamage0 = 0;
        unitAppliedDamage1 = 0;
        unitAppliedDamage2 = 0;
        unitAppliedDamage3 = 0;
        unitAppliedDamage4 = 0;
        unitAppliedDamage5 = 0;
        unitAppliedDamage6 = 0;
        unitAppliedDamage7 = 0;
        unitAppliedDamage8 = 0;
        unitAppliedDamage9 = 0;
        unitAppliedDamage10 = 0;
        unitAppliedDamage11 = 0;
        unitAppliedDamage12 = 0;
        unitAppliedDamage13 = 0;
        unitAppliedDamage14 = 0;
        unitAppliedDamage15 = 0;
		friendlyTowerAppliedDamage = 0;
		case(unitDamageSelect)
			5'b00000:
			begin
				unitAppliedDamage0 = totalUnitDamage;
			end
			5'b00001:
			begin
				unitAppliedDamage1 = totalUnitDamage;
			end
			5'b00010:
			begin
				unitAppliedDamage2 = totalUnitDamage;
			end 
			5'b00011:
			begin
				unitAppliedDamage3 = totalUnitDamage;
			end  
			5'b00100:
			begin
				unitAppliedDamage4 = totalUnitDamage;
			end
			5'b00101:
			begin
				unitAppliedDamage5 = totalUnitDamage;
			end
			5'b00110:
			begin
				unitAppliedDamage6 = totalUnitDamage;
			end 
			5'b00111:
			begin
				unitAppliedDamage7 = totalUnitDamage;
			end
			5'b01000:
			begin
				unitAppliedDamage8 = totalUnitDamage;
			end
			5'b01001:
			begin
				unitAppliedDamage9 = totalUnitDamage;
			end
			5'b01010:
			begin
				unitAppliedDamage10 = totalUnitDamage;
			end 
			5'b01011:
			begin
				unitAppliedDamage11 = totalUnitDamage;
			end
			5'b01100:
			begin
				unitAppliedDamage12 = totalUnitDamage;
			end
			5'b01101:
			begin
				unitAppliedDamage13 = totalUnitDamage;
			end
			5'b01110:
			begin
				unitAppliedDamage14 = totalUnitDamage;
			end 
			5'b01111:
			begin
				unitAppliedDamage15 = totalUnitDamage;
			end 
			default:
            begin
                friendlyTowerAppliedDamage = totalUnitDamage;
            end		
		endcase
	end
	
	// 17 to 1 decoder for applying damage to the correct enemy (or tower)
	always @(*)
	begin: Enemy_Mux_17_1
        enemyAppliedDamage0 = 0;
        enemyAppliedDamage1 = 0;
        enemyAppliedDamage2 = 0;
        enemyAppliedDamage3 = 0;
        enemyAppliedDamage4 = 0;
        enemyAppliedDamage5 = 0;
        enemyAppliedDamage6 = 0;
        enemyAppliedDamage7 = 0;
        enemyAppliedDamage8 = 0;
        enemyAppliedDamage9 = 0;
        enemyAppliedDamage10 = 0;
        enemyAppliedDamage11 = 0;
        enemyAppliedDamage12 = 0;
        enemyAppliedDamage13 = 0;
        enemyAppliedDamage14 = 0;
        enemyAppliedDamage15 = 0;
		enemyTowerAppliedDamage = 0;
		case(enemyDamageSelect)
			5'b00000:
			begin
				enemyAppliedDamage0 = totalEnemyDamage;
			end
			5'b00001:
			begin
				enemyAppliedDamage1 = totalEnemyDamage;
			end
			5'b00010:
			begin
				enemyAppliedDamage2 = totalEnemyDamage;
			end 
			5'b00011:
			begin
				enemyAppliedDamage3 = totalEnemyDamage;
			end  
			5'b00100:
			begin
				enemyAppliedDamage4 = totalEnemyDamage;
			end
			5'b00101:
			begin
				enemyAppliedDamage5 = totalEnemyDamage;
			end
			5'b00110:
			begin
				enemyAppliedDamage6 = totalEnemyDamage;
			end 
			5'b00111:
			begin
				enemyAppliedDamage7 = totalEnemyDamage;
			end
			5'b01000:
			begin
				enemyAppliedDamage8 = totalEnemyDamage;
			end
			5'b01001:
			begin
				enemyAppliedDamage9 = totalEnemyDamage;
			end
			5'b01010:
			begin
				enemyAppliedDamage10 = totalEnemyDamage;
			end 
			5'b01011:
			begin
				enemyAppliedDamage11 = totalEnemyDamage;
			end
			5'b01100:
			begin
				enemyAppliedDamage12 = totalEnemyDamage;
			end
			5'b01101:
			begin
				enemyAppliedDamage13 = totalEnemyDamage;
			end
			5'b01110:
			begin
				enemyAppliedDamage14 = totalEnemyDamage;
			end 
			5'b01111:
			begin
				enemyAppliedDamage15 = totalEnemyDamage;
			end 
            default:
            begin
                enemyTowerAppliedDamage = totalEnemyDamage;
            end		
		endcase
	end
	
endmodule
