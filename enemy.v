`timescale 1ns/1ps

module Enemy(
	input clk, 
	input gameClk,
	input reset,
	
	input moveSCEN,
	input damageSCEN,
	
	input [7:0] damageIn,
	
	input SW0,
	input SW1,
	input SW2,
	input SW3,
	
	output [8:0] position, // choose how many bits we need for position
	output [7:0] damageOut, // choose how many bits we need for damange
	output dead
);

reg [7:0] power; // determines how strong an enemy's attack is
reg [7:0] health; // internal to the unit, keeps track how much health they have left
reg [3:0] I; // dummy counter for dead state

reg [6:0] state;

localparam
	QI =       7'b1000000,
	QDeploy0 = 7'b0100000,
	QDeploy1 = 7'b0010000,
	QDeploy2 = 7'b0001000,
	QDeploy3 = 7'b0000100,
	QAlive   = 7'b0000010,
	QDead =    7'b0000001,
	UNK =      7'bXXXXXXX;
	
always@(posedge clk, posedge reset)
begin
	if(reset)
		state <= QI;
	else
	begin
		case(state):
			QI:
				begin
					// state transition
					
					case({SW0, SW1, SW2, SW3}):
						4'b1000: state <= QDeploy0;
						4'b0100: state <= QDeploy1;
						4'b0010: state <= QDeploy2;
						4'b0001: state <= QDeploy3;
					endcase
			
					// RTL
					position <= 9'b0000_0000_0; // CHANGED FROM PLAYER
					I <= 3'b000;
					damageIn <= 8'b0000_0000;
					damageOut <= 8'b0000_0000;
					power <= 8'b0000_0000;
				end
			QDeploy0:
				begin 
					health <= 8'b1111_1111;
					power <= 8'b0001_0000;
				end
			QDeploy1:
				begin
					health <= 8'b1111_1111;
					power <= 8'b0010_0000;
				end
			QDeploy2:
				begin
					health <= 8'b1111_1111;
					power <= 8'b0100_0000;
				end
			QDeploy3:
				begin
					health <= 8'b1111_1111;
					power <= 8'b1000_0000; 
				end
			QAlive:
				begin
					// State Transtition Logic
					if(health <= damageIn) state <= QDead;
					
					// RTL
					
					// accept damage provided by TOP, can be 0 to whatever the attack damage is of enemy units
					dead <= 1'b0;
					if(damageSCEN) health <= health - damageIn;
					if(moveSCEN) // move
						position <= position + 1; // <-- CHANGE TO POSITIVE IN ENEMY.V
						damageOut <= 7'b0000000;
					else // unit is attacking
						damageOut <= power;
						
				end
			QDead:
				begin
					if(I == 4'1010) state <= QI;
					I <= I + 4'b0001;
					dead <= 1'b1;
				end
			default: state <= UNK;
		endcase
	end
		
end

endmodule
