`timescale 1ns / 1ps


// Generates a gameSCEN which causes the game to advance a frame
// Has a synchronous reset
module BattleFront(
	input clk,
	input rst,
	input Start,
	input Ack,
	input [8:0] unitLoc0,
	input [8:0] unitLoc1,
	input [8:0] unitLoc2,
	input [8:0] unitLoc3,
	input [8:0] unitLoc4,
	input [8:0] unitLoc5,
	input [8:0] unitLoc6,
	input [8:0] unitLoc7,
	input [8:0] unitLoc8,
	input [8:0] unitLoc9,
	input [8:0] unitLoc10,
	input [8:0] unitLoc11,
	input [8:0] unitLoc12,
	input [8:0] unitLoc13,
	input [8:0] unitLoc14,
	input [8:0] unitLoc15,
	input [1:0] unitType0,
	input [1:0] unitType1,
	input [1:0] unitType2,
	input [1:0] unitType3,
	input [1:0] unitType4,
	input [1:0] unitType5,
	input [1:0] unitType6,
	input [1:0] unitType7,
	input [1:0] unitType8,
	input [1:0] unitType9,
	input [1:0] unitType10,
	input [1:0] unitType11,
	input [1:0] unitType12,
	input [1:0] unitType13,
	input [1:0] unitType14,
	input [1:0] unitType15,
	input [8:0] enemyLoc0,
	input [8:0] enemyLoc1,
	input [8:0] enemyLoc2,
	input [8:0] enemyLoc3,
	input [8:0] enemyLoc4,
	input [8:0] enemyLoc5,
	input [8:0] enemyLoc6,
	input [8:0] enemyLoc7,
	input [8:0] enemyLoc8,
	input [8:0] enemyLoc9,
	input [8:0] enemyLoc10,
	input [8:0] enemyLoc11,
	input [8:0] enemyLoc12,
	input [8:0] enemyLoc13,
	input [8:0] enemyLoc14,
	input [8:0] enemyLoc15,
	input [1:0] enemyType0,
	input [1:0] enemyType1,
	input [1:0] enemyType2,
	input [1:0] enemyType3,
	input [1:0] enemyType4,
	input [1:0] enemyType5,
	input [1:0] enemyType6,
	input [1:0] enemyType7,
	input [1:0] enemyType8,
	input [1:0] enemyType9,
	input [1:0] enemyType10,
	input [1:0] enemyType11,
	input [1:0] enemyType12,
	input [1:0] enemyType13,
	input [1:0] enemyType14,
	input [1:0] enemyType15,
	output reg [8:0] friendlyFront,
	output reg [8:0] enemyFront,
	output reg [4:0] unitDamageSelect,
	output reg [4:0] enemyDamageSelect,
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
                currEnemyLoc = enemyLoc0;
                currEnemyType = enemyType0;
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
			unitDamageSelect <= 5'bXXXX_X;
			enemyDamageSelect <= 5'bXXXX_X;
		end
		else
		begin
			case(state)				
				INITIAL:
				begin
					if(Start) state <= UPDATE;
					I <= 1;
					
					// If the first enemy doesn't exist, use the tower lcoation
					if(enemyType0 != 2'b00)
					begin
						enemyFront <= enemyLoc0;
						enemyDamageSelect <= 5'b0000_0;
					end
					else 
					begin
						enemyFront <= 9'b0000_0000_0;
						enemyDamageSelect <= 5'b1000_0;
					end
					
					// If the first unit doesn't exist, use the tower location
					if(unitType0 != 2'b00)
					begin	
						friendlyFront <= unitLoc0;
						unitDamageSelect <= 5'b0000_0;
					end
					else
					begin
						friendlyFront <= 9'b1111_1111_1;
						unitDamageSelect <= 5'b1000_0;
					end
				end
				
				UPDATE:
				begin
					if(I == 15) state <= ADJUST;
					
					I <= I + 1;
					
					if(currEnemyType != 2'b00 && currEnemyLoc > enemyFront)
					begin
						enemyFront <= currEnemyLoc;
						enemyDamageSelect <= I;
					end
					if(currUnitType != 2'b00 && currUnitLoc < friendlyFront)
					begin
						friendlyFront <= currUnitLoc;
						unitDamageSelect <= I;
					end
					
				end
				ADJUST:
				begin
					state <= DONE;
					friendlyFront <= friendlyFront - 10;
					enemyFront <= enemyFront + 10;
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
