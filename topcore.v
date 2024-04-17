`timescale 1ns/1ps

module TopCore(
	input clk,
	input reset,
	
	input damageCalcDone, // comes from damageCalc module in top
	input battlefrontDone, // comes from battlefrontCalculator 
	input gameSCEN, // from gameEngine.v
	
	output battlefrontACK, // gives battelfront signal an ACK signal, so it can move from DONE state to start calculating again
	
	output moveSCEN, 
	output damageSCEN // goes to damager calculator on the top
);

localparam
	QWaitBF =   6'b100000,
	QMoveCalc = 6'b010000,
	QStartDam = 6'b001000,
	QWaitDam  = 6'b000100,
	QAppDam =   6'b000010,
	QWriteVGA = 6'b000001,
	UNK =       6'bXXXXXX;
	
reg [5:0] state;

assign moveSCEN = state[4];
assign damageSCEN = state[3];

always@(posedge clk, posedge reset)
begin
	if(reset) state <= QWaitBF;
	else
		begin
			case(state)
				QWaitBF:
				begin
					if(battlefrontDone) state <= QMoveCalc;
				end
				QMoveCalc:
				begin
					state <= QStartDam;
				end
				QStartDam:
				begin
					state <= QWaitDam;
				end
				QWaitDam:
				begin
					if(damageCalcDone) state <= QAppDam;
				end
				QAppDam:
				begin
					state <= QWriteVGA;
					battlefrontACK <= 1'b1;
				end
				QWriteVGA:
				begin
					if(gameSCEN) state <= QWaitBF;
					battlefrontACK <= 1'b0;
				end
			endcase
		end
end


endmodule