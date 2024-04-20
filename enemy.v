`timescale 1ns/1ps

module Enemy(
	input clk, 
	//input gameClk,
	input reset,
	
	input moveSCEN,
	input damageSCEN,
	
	input [7:0] damageIn,
	input [8:0] unitFront, // location of the frontmost unit
	
	output reg [8:0] position, // choose how many bits we need for position
	output reg [7:0] damageOut, // choose how many bits we need for damage
	
	output reg [1:0] enemyType,
	
	/*output q_I,
	output q_Deploy1,
	output q_Deploy2,
	output q_Deploy3,
	output q_Alive*/
	
	output reg dead,
	input canSpawn
);

reg [7:0] power; // determines how strong an enemy's attack is
reg [7:0] health; // internal to the unit, keeps track how much health they have left
//reg [3:0] I; // dummy counter for dead state

reg [6:0] state;
//assign {q_I, q_Deploy1, q_Deploy2, q_Deploy3, q_Alive} = state;

//reg [15:0] counter;

localparam
	QI =       5'b10000,
	//QDeploy0 = 7'b0100000,
	QDeploy1 = 5'b01000,
	QDeploy2 = 5'b00100,
	QDeploy3 = 5'b00010,
	QAlive   = 5'b00001,
	//QDead =    7'b0000001,
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
					
					if(canSpawn) state <= QDeploy1; // making all enemies type 1 for now
					
					//counter <= counter + 4'b0001;
					// RTL
					position <= 9'b0000_0000_0; // CHANGED FROM PLAYER
					//I <= 3'b000;
					// damageIn <= 8'b0000_0000;
					damageOut <= 8'b0000_0000;
					power <= 8'b0000_0000;
					
				end
			/*QDeploy0:
				begin 
					health <= 8'b1111_1111;
					power <= 8'b0001_0000;
				end*/
			QDeploy1:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b0010_0000;
					enemyType <= 2'b01;
				end
			QDeploy2:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b0100_0000;
					enemyType <= 2'b10;
				end
			QDeploy3:
				begin
					state <= QAlive;
					health <= 8'b1111_1111;
					power <= 8'b1000_0000;
					enemyType <= 2'b11;
				end
			QAlive:
				begin
					// State Transtition Logic
					if(health <= damageIn)
					begin
					state <= QI;
					//enemyType <= 2'b00;
					//dead <= 1'b1;
					end
					// RTL
					
					// accept damage provided by TOP, can be 0 to whatever the attack damage is of enemy units
					dead <= 1'b0;
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
			/*QDead:
				begin
					if(I == 4'1010) state <= QI;
					I <= I + 4'b0001;
					
					unitType <= 2'b00;
					//dead <= 1'b1;
				end*/
			default: state <= UNK;
		endcase
	end
		
end

endmodule
