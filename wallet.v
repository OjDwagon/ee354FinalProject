`timescale 1ns / 1ps

module Wallet(
	input clk,
	input gameClk,
	input rst,
	input purchase,
	input [12:0] unitCost,
	output reg [1:0] level,
	output reg [10:0] balance,
	output reg maxed,
	output reg buySucc
   );
	
	reg MAX;
	
	// Block to set maxed based on level
	always @(posedge clk)
	begin
		if(level == 2'b11) maxed <= 1;
		else maxed <= 0;
	end
	
	// Core state machine
	always @(posedge gameClk, posedge rst) 
	begin: Main_SM
		if(rst)
		begin
			balance <= 0;
			level <= 2'b00;
			maxed <= 1'b0;
			buySucc <= 1'b0;
			MAX <= 3'd256;
		end
		else
		begin
			if(balance < MAX) balance <= balance + 1;
			if(upgrade)
			begin
				level <= level + 1;
				MAX <= MAX * 2;
			end
			if(purchase)
			begin
				if(unitCost <= balance)
				begin
					balance <= balance - unitCost;
					buySucc <= 1;
				end
				else buySucc <= 0;
			end
			else buySucc <= 1'bX;
		end
	end
	
endmodule
