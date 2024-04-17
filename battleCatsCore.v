`timescale 1ns / 1ps


// Generates a gameSCEN which causes the game to advance a frame
// Has a synchronous reset
module BattleCatsCore(
	input clk,
	input gameSCEN,
	input rst,
	input battleFrontsDone,
	output moveSCEN,
	output damageCalcSCEN,
	output damageSCEN,
	
	output reg [8:0] friendlyFront,
	output reg [8:0] enemyFront,
	output Done
   );
	
	reg [3:0] I;
	reg [3:0] state;
	reg [8:0] currUnitLoc; 
	reg [1:0] currUnitType;
	reg [8:0] currEnemyLoc; 
	reg [1:0] currEnemyType;
	
	localparam
	INITIAL	= 4'b0001,
	UPDATE = 4'b0010,
    ADJUST	= 4'b0100,
	DONE = 4'b1000;  
	
	assign Done = state[3];
	
	// 16 to 1 mux for going selecting different enemies and units
	always @(*)
	begin: Mux_16_1
		case(I)
			4'b0000:
			begin
				currUnitLoc = unitLoc0;
				currUnitType = unitType0;
                currEnemyLoc = enemyLoc8;
                currEnemyType = enemyType8;
			end
			4'b0001:
			begin
				currUnitLoc = unitLoc1;
				currUnitType = unitType1;
                currEnemyLoc = enemyLoc1;
                currEnemyType = enemyType1;
			end
			4'b0010:
			begin
				currUnitLoc = unitLoc2;
				currUnitType = unitType2;
                currEnemyLoc = enemyLoc2;
                currEnemyType = enemyType2;
			end 
			4'b0011:
			begin
				currUnitLoc = unitLoc3;
				currUnitType = unitType3;
                currEnemyLoc = enemyLoc3;
                currEnemyType = enemyType3;
			end  
			4'b0100:
			begin
				currUnitLoc = unitLoc4;
				currUnitType = unitType4;
                currEnemyLoc = enemyLoc4;
                currEnemyType = enemyType4;
			end
			4'b0101:
			begin
				currUnitLoc = unitLoc5;
				currUnitType = unitType5;
                currEnemyLoc = enemyLoc5;
                currEnemyType = enemyType5;
			end
			4'b0110:
			begin
				currUnitLoc = unitLoc6;
				currUnitType = unitType6;
                currEnemyLoc = enemyLoc6;
                currEnemyType = enemyType6;
			end 
			4'b0111:
			begin
				currUnitLoc = unitLoc7;
				currUnitType = unitType7;
                currEnemyLoc = enemyLoc7;
                currEnemyType = enemyType7;
			end
			4'b1000:
			begin
				currUnitLoc = unitLoc8;
				currUnitType = unitType8;
                currEnemyLoc = enemyLoc8;
                currEnemyType = enemyType8;
			end
			4'b1001:
			begin
				currUnitLoc = unitLoc9;
				currUnitType = unitType9;
                currEnemyLoc = enemyLoc9;
                currEnemyType = enemyType9;
			end
			4'b1010:
			begin
				currUnitLoc = unitLoc10;
				currUnitType = unitType10;
                currEnemyLoc = enemyLoc10;
                currEnemyType = enemyType10;
			end 
			4'b1011:
			begin
				currUnitLoc = unitLoc11;
				currUnitType = unitType11;
                currEnemyLoc = enemyLoc11;
                currEnemyType = enemyType11;
			end
			4'b1100:
			begin
				currUnitLoc = unitLoc12;
				currUnitType = unitType12;
                currEnemyLoc = enemyLoc12;
                currEnemyType = enemyType12;
			end
			4'b1101:
			begin
				currUnitLoc = unitLoc13;
				currUnitType = unitType13;
                currEnemyLoc = enemyLoc13;
                currEnemyType = enemyType13;
			end
			4'b1110:
			begin
				currUnitLoc = unitLoc14;
				currUnitType = unitType14;
                currEnemyLoc = enemyLoc14;
                currEnemyType = enemyType14;
			end 
			4'b1111:
			begin
				currUnitLoc = unitLoc15;
				currUnitType = unitType15;
                currEnemyLoc = enemyLoc15;
                currEnemyType = enemyType15;
			end 		
		endcase
	end
	
	// State machine and datapath
	always @(posedge clk)
	begin
		if(rst)
		begin
			state <= INITIAL;
			I <= 4'bXXXX;
			enemyFront <= 9'bXXXX_XXXX_X;
			friendlyFront <= 9'bXXXX_XXXX_X;
		end
		else
		begin
			case(state)				
				INITIAL:
				begin
					if(Start) state <= UPDATE;
					I <= 1;
					
					// If the first enemy doesn't exist, use the tower lcoation
					if(enemyType0 != 2'b00) enemyFront <= enemyLoc0;
					else enemyFront <= 9'b0000_0000_0;
					
					// If the first unit doesn't exist, use the tower location
					if(unitType0 != 2'b00) friendlyFront <= unitLoc0;
					else friendlyFront <= 9'b1111_1111_1;
				end
				
				UPDATE:
				begin
					if(I == 15) state <= ADJUST;
					
					I <= I + 1;
					
					if(currEnemyType != 2'b00 && currEnemyLoc > enemyFront) enemyFront <= currEnemyLoc;
					if(currUnitType != 2'b00 && currUnitLoc < friendlyFront) friendlyFront <= currUnitLoc;
					
				end
				ADJUST:
				begin
					state <= DONE;
					friendlyFront <= friendlyFront - 6;
					enemyFront <= enemyFront + 7;
				end
				DONE:
				begin
					if(Ack) state <= INITIAL;
				end
				
				default:
				begin
					state <= 4'bXXXX;
					I <= 4'bXXXX;
				end
				
			
			endcase
		end
	end
	
endmodule
