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
   
	wire block_fill;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	
	parameter RED   = 12'b1111_0000_0000;
	parameter UNIT1COLOR = 12'b1111_0000_0000; // Red
	parameter UNIT2COLOR = 12'b0000_1111_0000; // Green
	parameter UNIT3COLOR = 12'b0000_0000_1111; // Blue
	
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (block_fill) 
			rgb = RED; 
		else	
			rgb=background;
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign block_fill=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	
	
	// Always block for assigning rgb
	always @(*)
	begin
		// If we are on the level where units exist
		if(vCount <= 395 && vCount > 385)
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
						else if(registeredUnitType1 != 0 && hCount >= (registeredUnitType1 + 10'd203) && hCount <= (registeredUnitType1 + 10'd212))
			begin
				case(registeredUnitType1)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType2 != 0 && hCount >= (registeredUnitType2 + 10'd203) && hCount <= (registeredUnitType2 + 10'd212))
			begin
				case(registeredUnitType2)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType3 != 0 && hCount >= (registeredUnitType3 + 10'd203) && hCount <= (registeredUnitType3 + 10'd212))
			begin
				case(registeredUnitType3)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType4 != 0 && hCount >= (registeredUnitType4 + 10'd203) && hCount <= (registeredUnitType4 + 10'd212))
			begin
				case(registeredUnitType4)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType5 != 0 && hCount >= (registeredUnitType5 + 10'd203) && hCount <= (registeredUnitType5 + 10'd212))
			begin
				case(registeredUnitType5)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType6 != 0 && hCount >= (registeredUnitType6 + 10'd203) && hCount <= (registeredUnitType6 + 10'd212))
			begin
				case(registeredUnitType6)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType7 != 0 && hCount >= (registeredUnitType7 + 10'd203) && hCount <= (registeredUnitType7 + 10'd212))
			begin
				case(registeredUnitType7)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType8 != 0 && hCount >= (registeredUnitType8 + 10'd203) && hCount <= (registeredUnitType8 + 10'd212))
			begin
				case(registeredUnitType8)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            			else if(registeredUnitType9 != 0 && hCount >= (registeredUnitType9 + 10'd203) && hCount <= (registeredUnitType9 + 10'd212))
			begin
				case(registeredUnitType9)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType10 != 0 && hCount >= (registeredUnitType10 + 10'd203) && hCount <= (registeredUnitType10 + 10'd212))
			begin
				case(registeredUnitType10)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType11 != 0 && hCount >= (registeredUnitType11 + 10'd203) && hCount <= (registeredUnitType11 + 10'd212))
			begin
				case(registeredUnitType11)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType12 != 0 && hCount >= (registeredUnitType12 + 10'd203) && hCount <= (registeredUnitType12 + 10'd212))
			begin
				case(registeredUnitType12)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType13 != 0 && hCount >= (registeredUnitType13 + 10'd203) && hCount <= (registeredUnitType13 + 10'd212))
			begin
				case(registeredUnitType13)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType14 != 0 && hCount >= (registeredUnitType14 + 10'd203) && hCount <= (registeredUnitType14 + 10'd212))
			begin
				case(registeredUnitType14)
					2'b01: rgb <= UNIT1COLOR;
					2'b10: rgb <= UNIT2COLOR;
					2'b11: rgb <= UNIT3COLOR;
					default: rgb <= background;
				endcase
			end
            else if(registeredUnitType15 != 0 && hCount >= (registeredUnitType15 + 10'd203) && hCount <= (registeredUnitType15 + 10'd212))
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
	
	
	// always@(posedge clk, posedge rst) 
	// begin
	// 	if(rst)
	// 	begin 
	// 		//rough values for center of screen
	// 		xpos<=450;
	// 		ypos<=250;
	// 	end
	// 	else if (clk) begin
		
	// 	/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
	// 		synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
	// 		the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
	// 		the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
	// 		corresponds to ~(783,515).  
	// 	*/
	// 		if(right) begin
	// 			xpos<=xpos+2; //change the amount you increment to make the speed faster 
	// 			if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
	// 				xpos<=150;
	// 		end
	// 		else if(left) begin
	// 			xpos<=xpos-2;
	// 			if(xpos==150)
	// 				xpos<=800;
	// 		end
	// 		else if(up) begin
	// 			ypos<=ypos-2;
	// 			if(ypos==34)
	// 				ypos<=514;
	// 		end
	// 		else if(down) begin
	// 			ypos<=ypos+2;
	// 			if(ypos==514)
	// 				ypos<=34;
	// 		end
	// 	end
	// end
	
	//the background color reflects the most recent button press
	always@(posedge clk) begin
		if(vCount > 395) background <= 12'b0010_1101_0010;
		else background <= 12'b0011_0111_1011;
	end

	
	
endmodule
