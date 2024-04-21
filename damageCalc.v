`timescale 1ns / 1ps


// Generates a gameSCEN which causes the game to advance a frame
// Has a synchronous reset
module DamageCalc(
	input clk,
	input rst,
	input Start,
	input Ack,
	input [7:0] unitAttack0,
	input [7:0] unitAttack1,
	input [7:0] unitAttack2,
	input [7:0] unitAttack3,
	input [7:0] unitAttack4,
	input [7:0] unitAttack5,
	input [7:0] unitAttack6,
	input [7:0] unitAttack7,
	input [7:0] unitAttack8,
	input [7:0] unitAttack9,
	input [7:0] unitAttack10,
	input [7:0] unitAttack11,
	input [7:0] unitAttack12,
	input [7:0] unitAttack13,
	input [7:0] unitAttack14,
	input [7:0] unitAttack15,
	input [7:0] enemyAttack0,
	input [7:0] enemyAttack1,
	input [7:0] enemyAttack2,
	input [7:0] enemyAttack3,
	input [7:0] enemyAttack4,
	input [7:0] enemyAttack5,
	input [7:0] enemyAttack6,
	input [7:0] enemyAttack7,
	input [7:0] enemyAttack8,
	input [7:0] enemyAttack9,
	input [7:0] enemyAttack10,
	input [7:0] enemyAttack11,
	input [7:0] enemyAttack12,
	input [7:0] enemyAttack13,
	input [7:0] enemyAttack14,
	input [7:0] enemyAttack15,
	output reg [11:0] totalUnitDamage,
	output reg [11:0] totalEnemyDamage,
	output Done
   );
	
	reg [3:0] I;
	reg [2:0] state;
	reg [7:0] currUnitDamage; 
	reg [7:0] currEnemyDamage; 
	
	localparam
	INITIAL	= 3'b001,
	SUM = 3'b010,
    DONE	= 3'b100;
	
	assign Done = state[2];
	
	// 16 to 1 mux for going selecting different enemies and units
	always @(*)
	begin: Mux_16_1
		case(I)
			4'b0000:
			begin
				currUnitDamage = unitAttack0;
                currEnemyDamage = enemyAttack0;
			end
			4'b0001:
			begin
				currUnitDamage = unitAttack1;
                currEnemyDamage = enemyAttack1;
			end
			4'b0010:
			begin
				currUnitDamage = unitAttack2;
                currEnemyDamage = enemyAttack2;
			end 
			4'b0011:
			begin
				currUnitDamage = unitAttack3;
                currEnemyDamage = enemyAttack3;
			end  
			4'b0100:
			begin
				currUnitDamage = unitAttack4;
                currEnemyDamage = enemyAttack4;
			end
			4'b0101:
			begin
				currUnitDamage = unitAttack5;
                currEnemyDamage = enemyAttack5;
			end
			4'b0110:
			begin
				currUnitDamage = unitAttack6;
                currEnemyDamage = enemyAttack6;
			end 
			4'b0111:
			begin
				currUnitDamage = unitAttack7;
                currEnemyDamage = enemyAttack7;
			end
			4'b1000:
			begin
				currUnitDamage = unitAttack8;
                currEnemyDamage = enemyAttack8;
			end
			4'b1001:
			begin
				currUnitDamage = unitAttack9;
                currEnemyDamage = enemyAttack9;
			end
			4'b1010:
			begin
				currUnitDamage = unitAttack10;
                currEnemyDamage = enemyAttack10;
			end 
			4'b1011:
			begin
				currUnitDamage = unitAttack11;
                currEnemyDamage = enemyAttack11;
			end
			4'b1100:
			begin
				currUnitDamage = unitAttack12;
                currEnemyDamage = enemyAttack12;
			end
			4'b1101:
			begin
				currUnitDamage = unitAttack13;
                currEnemyDamage = enemyAttack13;
			end
			4'b1110:
			begin
				currUnitDamage = unitAttack14;
                currEnemyDamage = enemyAttack14;
			end 
			4'b1111:
			begin
				currUnitDamage = unitAttack15;
                currEnemyDamage = enemyAttack15;
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
			totalUnitDamage <= 9'bXXXX_XXXX_X;
			totalUnitDamage <= 9'bXXXX_XXXX_X;
		end
		else
		begin
			case(state)				
				INITIAL:
				begin
					if(Start) state <= SUM;
					I <= 1;
					
					totalUnitDamage <= unitAttack0;
					totalEnemyDamage <= enemyAttack0;
				end
				
				SUM:
				begin
					if(I == 15) state <= DONE;
					
					I <= I + 1;
					
					totalUnitDamage <= totalUnitDamage + {4'b0000, currUnitDamage};
					totalEnemyDamage <= totalEnemyDamage + {4'b0000, currEnemyDamage};
					
				end
				DONE:
				begin
					if(Ack) state <= INITIAL;
				end
				
				default:
				begin
					state <= 3'bXXX;
					I <= 3'bXXX;
				end
				
			
			endcase
		end
	end
	
endmodule
