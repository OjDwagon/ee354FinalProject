`timescale 1ns/1ps

module Tower( // // might have to the change this from clk to gameClk later
	input clk,
	input gameClk,
	input reset,
	input [7:0] damageIn,
	
	input attackSCEN,
	
	input player, // determines if the tower being instantiated is a player tower or an enemy tower
	input startLevel,
	
	output [7:0] health,
	output dead,
	output levelComplete,
);

reg [4:0] state;
reg [8:0] position;

localparam
	QI =       5'b10000,
	QDeployP = 5'b01000,
	QDeployE = 5'b00100,
	QAlive =   5'b00010,
	QDead =    5'b00001;
	UNK =      5'bXXXXX;

always@(posedge clk, posedge reset)
begin
	if(reset)
		state <= QI;
	else 
	begin
		case(state)
			QI:
			begin
				health <= 8'b1111_1111;
				levelComplete <= 1'b0;
				if(startLevel & player) state <= QDeployP;
				else if(startLevel & !player) state <= QDeployE;
			
			end
			QDeployP:
			begin
				state <= QAlive;
				position <= 9'b1111_1111_1; // right side of the screen
			end
			QDeployE: // For now, keep the enemies HP the same between each level, might change
			begin
				state <= QAlive;
				position <= 9'b0000_0000_0; // left side of the screen
			end
			QAlive:
			begin
				if(attackSCEN) health <= health - damageIn;
				if(health <= damageIn) state <= QDead;
				dead <= 1'b0;
			end
			QDead:
			begin
				if(I == 4'1010) state <= QI;
				I <= I + 4'b0001;
				dead <= 1'b1;
				levelComplete <= 1'b1; // MIGHT NEED TO DIFFERENTIATE BETWEEN ENEMY AND PLAYER HERE
			end
			default: state <= UNK;
		endcase
			
	end

end

endmodule