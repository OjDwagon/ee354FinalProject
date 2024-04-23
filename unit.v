`timescale 1ns/1ps

module Unit(
	input clk, 
	input reset,
	input moveSCEN,
	input damageSCEN,
	input [7:0] damageIn,
	input leftSCEN,
	input rightSCEN,
	input downSCEN,
	input canSpawn,
	input [8:0] enemyFront, // location of the frontmost enemy
	output reg [8:0] position, // choose how many bits we need for position
	output reg [7:0] damageOut, // choose how many bits we need for damage
	output reg [1:0] unitType,// 00 dead, 1-3 different unit types
	output reg dead
);

reg [7:0] power; // determines how strong an enemy's attack is
reg [7:0] health; // internal to the unit, keeps track how much health they have left
reg [4:0] state;

localparam
	QI =       5'b10000,
	QDeploy1 = 5'b01000,
	QDeploy2 = 5'b00100,
	QDeploy3 = 5'b00010,
	QAlive   = 5'b00001,
	UNK =      5'bXXXXX;

always@(posedge clk, posedge reset) // might have to the change this from clk to gameClk later
begin
	if(reset)
		state <= QI;
	else
	begin
		case(state) // CASE STATEMENTS IN VERILOG DON'T HAVE A COMMA AFTERWARDS
			QI:
				begin
					// state transition
					unitType <= 2'b00;
					dead <= 1'b1;
					begin
						if(canSpawn)
						begin
							case({leftSCEN, rightSCEN, downSCEN})
								3'b100: state <= QDeploy1;
								3'b010: state <= QDeploy2;
								3'b001: state <= QDeploy3;
							endcase
						end
					end
					
			
					// RTL
					position <= 9'b1111_1111_1;
					damageOut <= 8'b0000_0000;
					power <= 8'b0000_0000;
				end
			QDeploy1:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b0000_0001;
					unitType <= 2'b01;
					dead <= 1'b0;
				end
			QDeploy2:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b0100_0000;
					unitType <= 2'b10;
					dead <= 1'b0;
				end
			QDeploy3:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b1111_1111; 
					unitType <= 2'b11;
					dead <= 1'b0;
				end
			QAlive:
				begin
					// State Transtition Logic
					if(health <= damageIn)
						begin
							state <= QI;
							unitType <= 2'b00;
							dead <= 1'b1;
						end
					// RTL
					
					// accept damage provided by TOP, can be 0 to whatever the attack damage is of enemy units
					if(damageSCEN) health <= health - damageIn;
					if(moveSCEN) // receives moveSCEN from battlefront calculator
					begin
						if(enemyFront < position) // the unit should still move forward
						begin
							position <= position - 1; // <-- CHANGE TO POSITIVE IN ENEMY.V
							damageOut <= 7'b0000000;
						end
						else damageOut <= power; // the unit is attacking
					end
						
				end
			/*QDead:
				begin
					if(I == 4'1010) state <= QI;
					I <= I + 4'b0001;
					unitType <= 2'b00; // mark enemy as dead
					
					// dead <= 1'b1;
				end*/
			default: state <= UNK;
		endcase
	end
		
end

endmodule
