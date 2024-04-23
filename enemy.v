`timescale 1ns/1ps

module Enemy(
	input clk, 
	input reset,
	input moveSCEN,
	input damageSCEN,
	input canSpawn,
	input [1:0] spawnType,
	input [7:0] damageIn,
	input [8:0] unitFront, // location of the frontmost unit
	output reg [8:0] position, // choose how many bits we need for position
	output reg [7:0] damageOut, // choose how many bits we need for damage
	output reg [1:0] enemyType,
	output reg dead
);

reg [7:0] power; // determines how strong an enemy's attack is
reg [7:0] health; // internal to the unit, keeps track how much health they have left
reg [6:0] state;

localparam
	QI =       5'b10000,
	QDeploy1 = 5'b01000,
	QDeploy2 = 5'b00100,
	QDeploy3 = 5'b00010,
	QAlive   = 5'b00001,
	UNK =      5'bXXXXX;
	
always@(posedge clk, posedge reset)
begin
	if(reset) state <= QI;
	else
	begin
		case(state)
			QI:
				begin
					// state transition
					enemyType <= 2'b00;
					dead <= 1'b1;
					
					if(canSpawn) begin
						case(spawnType) 
							2'b00: state <= QDeploy1;
							2'b01: state <= QDeploy1;
							2'b10: state <= QDeploy2;
							2'b11: state <= QDeploy3;
						endcase
					end
					
					// RTL
					position <= 9'b0000_0000_0; // CHANGED FROM PLAYER
					damageOut <= 8'b0000_0000;
					power <= 8'b0000_0000;
					
				end
			QDeploy1:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b0000_0001;
					enemyType <= 2'b01;
					dead <= 1'b0;
				end
			QDeploy2:
				begin
					state <= QAlive;
					health <= 8'b0000_0001;
					power <= 8'b0001_0000;
					enemyType <= 2'b10;
					dead <= 1'b0;
				end
			QDeploy3:
				begin
					state <= QAlive;
					health <= 8'b0000_0001;
					power <= 8'b1000_0101;
					enemyType <= 2'b11;
					dead <= 1'b0;
				end
			QAlive:
				begin
					// State Transtition Logic
					if(health <= damageIn)
					begin
					state <= QI;
					enemyType <= 2'b00;
					dead <= 1'b1;
					end
					// RTL
					
					// accept damage provided by TOP, can be 0 to whatever the attack damage is of enemy units
					if(damageSCEN) health <= health - damageIn;
					if(moveSCEN) // receives moveSCEN from battlefront calculator
					begin
						if(unitFront > position) // move
						begin
							position <= position + 1; // <-- CHANGE TO POSITIVE IN ENEMY.V
							damageOut <= 7'b0000000;
						end
						else damageOut <= power; // attack
					end
				end
			default: state <= UNK;
		endcase
	end
		
end

endmodule
