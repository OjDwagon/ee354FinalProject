`timescale 1ns / 1ps


module renderer(
	input clk, // Main clock for scanning
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	input gameSCEN, //this SCEN must be a slow enough to view the changing positions of the objects
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
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	
	reg [8:0] registeredUnitLoc0, registeredUnitLoc1, registeredUnitLoc2,
            registeredUnitLoc3, registeredUnitLoc4, registeredUnitLoc5,
            registeredUnitLoc6, registeredUnitLoc7, registeredUnitLoc8, 
            registeredUnitLoc9, registeredUnitLoc10, registeredUnitLoc11, 
            registeredUnitLoc12, registeredUnitLoc13, registeredUnitLoc14, 
            registeredUnitLoc15;
			
	reg [8:0] registeredUnitType0, registeredUnitType1, registeredUnitType2,
		registeredUnitType3, registeredUnitType4, registeredUnitType5,
		registeredUnitType6, registeredUnitType7, registeredUnitType8, 
		registeredUnitType9, registeredUnitType10, registeredUnitType11, 
		registeredUnitType12, registeredUnitType13, registeredUnitType14, 
		registeredUnitType15;
	
	// Capture the new unit positions and types only when given gameSCEN
	always @(posedge gameSCEN)
	begin
		registeredUnitLoc0 <= unitLoc0;
		registeredUnitLoc1 <= unitLoc1;
		registeredUnitLoc2 <= unitLoc2;
		registeredUnitLoc3 <= unitLoc3;
		registeredUnitLoc4 <= unitLoc4;
		registeredUnitLoc5 <= unitLoc5;
		registeredUnitLoc6 <= unitLoc6;
		registeredUnitLoc7 <= unitLoc7;
		registeredUnitLoc8 <= unitLoc8;
		registeredUnitLoc9 <= unitLoc9;
		registeredUnitLoc10 <= unitLoc10;
		registeredUnitLoc11 <= unitLoc11;
		registeredUnitLoc12 <= unitLoc12;
		registeredUnitLoc13 <= unitLoc13;
		registeredUnitLoc14 <= unitLoc14;
		registeredUnitLoc15 <= unitLoc15;
		registeredUnitType0 <= unitType0;
		registeredUnitType1 <= unitType1;
		registeredUnitType2 <= unitType2;
		registeredUnitType3 <= unitType3;
		registeredUnitType4 <= unitType4;
		registeredUnitType5 <= unitType5;
		registeredUnitType6 <= unitType6;
		registeredUnitType7 <= unitType7;
		registeredUnitType8 <= unitType8;
		registeredUnitType9 <= unitType9;
		registeredUnitType10 <= unitType10;
		registeredUnitType11 <= unitType11;
		registeredUnitType12 <= unitType12;
		registeredUnitType13 <= unitType13;
		registeredUnitType14 <= unitType14;
		registeredUnitType15 <= unitType15;
	end

	parameter UNIT1COLOR = 12'b1111_0000_0000; // Red
	parameter UNIT2COLOR = 12'b0000_1111_0000; // Green
	parameter UNIT3COLOR = 12'b0000_0000_1111; // Blue
	
	
	
	// Always block for assigning rgb
	always @(*)
	begin
		// If we are on the level where units exist
		if(~bright) rgb <= 12'b0000_0000_0000;
		else if(vCount <= 395 && vCount > 385)
		begin
			// Assign the appropriate color if the unit is alive and there
			if(registeredUnitType0 != 2'b00 && hCount >= (registeredUnitLoc0 + 10'd203) && hCount <= (registeredUnitLoc0 + 10'd212))
			begin
				case(registeredUnitType0)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
			else if(registeredUnitType1 != 2'b00 && hCount >= (registeredUnitLoc1 + 10'd203) && hCount <= (registeredUnitLoc1 + 10'd212))
			begin
				case(registeredUnitType1)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType2 != 2'b00 && hCount >= (registeredUnitLoc2 + 10'd203) && hCount <= (registeredUnitLoc2 + 10'd212))
			begin
				case(registeredUnitType2)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType3 != 2'b00 && hCount >= (registeredUnitLoc3 + 10'd203) && hCount <= (registeredUnitLoc3 + 10'd212))
			begin
				case(registeredUnitType3)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType4 != 2'b00 && hCount >= (registeredUnitLoc4 + 10'd203) && hCount <= (registeredUnitLoc4 + 10'd212))
			begin
				case(registeredUnitType4)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType5 != 2'b00 && hCount >= (registeredUnitLoc5 + 10'd203) && hCount <= (registeredUnitLoc5 + 10'd212))
			begin
				case(registeredUnitType5)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType6 != 2'b00 && hCount >= (registeredUnitLoc6 + 10'd203) && hCount <= (registeredUnitLoc6 + 10'd212))
			begin
				case(registeredUnitType6)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType7 != 2'b00 && hCount >= (registeredUnitLoc7 + 10'd203) && hCount <= (registeredUnitLoc7 + 10'd212))
			begin
				case(registeredUnitType7)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType8 != 2'b00 && hCount >= (registeredUnitLoc8 + 10'd203) && hCount <= (registeredUnitLoc8 + 10'd212))
			begin
				case(registeredUnitType8)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType9 != 2'b00 && hCount >= (registeredUnitLoc9 + 10'd203) && hCount <= (registeredUnitLoc9 + 10'd212))
			begin
				case(registeredUnitType9)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType10 != 2'b00 && hCount >= (registeredUnitLoc10 + 10'd203) && hCount <= (registeredUnitLoc10 + 10'd212))
			begin
				case(registeredUnitType10)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType11 != 2'b00 && hCount >= (registeredUnitLoc11 + 10'd203) && hCount <= (registeredUnitLoc11 + 10'd212))
			begin
				case(registeredUnitType11)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType12 != 2'b00 && hCount >= (registeredUnitLoc12 + 10'd203) && hCount <= (registeredUnitLoc12 + 10'd212))
			begin
				case(registeredUnitType12)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType13 != 2'b00 && hCount >= (registeredUnitLoc13 + 10'd203) && hCount <= (registeredUnitLoc13 + 10'd212))
			begin
				case(registeredUnitType13)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType14 != 2'b00 && hCount >= (registeredUnitLoc14 + 10'd203) && hCount <= (registeredUnitLoc14 + 10'd212))
			begin
				case(registeredUnitType14)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType15 != 2'b00 && hCount >= (registeredUnitLoc15 + 10'd203) && hCount <= (registeredUnitLoc15 + 10'd212))
			begin
				case(registeredUnitType15)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
			else rgb <= background;
		end
		else rgb <= background;
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk) begin
		if(vCount > 395) background <= 12'b0010_1101_0010;
		else background <= 12'b0011_0111_1011;
	end

	
	
endmodule
