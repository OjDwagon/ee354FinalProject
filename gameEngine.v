`timescale 1ns / 1ps


// Generates a gameSCEN which causes the game to advance a frame
// Has a synchronous reset
module GameEngine(
	input clk,
	input rst,
	input debouncedBtnU,
	output gameSCEN
   );
	
	reg [19:0] counter;
	reg [1:0] state;
	
	localparam
	WAIT	= 2'b10,
	ADVANCE = 2'b01;
	
	assign gameSCEN = state[0]; // SCEN corresponds to ADVANCE (the lsb of state)
	
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			state <= WAIT;
			counter <= 0;
		end
		else
		begin
			case(state)				
				WAIT:
				begin
					if(counter == 19'b1111_1111_1111_1111_110) state <= ADVANCE;
					counter <= counter + 1;
				end
				
				ADVANCE:
				//begin
					//if(debouncedBtnU)
					begin
						state <= WAIT;
						counter <= counter + 1;
					end
				//end
				default:
				begin
					state <= 2'bXX;
					counter <= 19'bXXXX_XXXX_XXXX_XXXX_XXX;
				end
				
			
			endcase
		end
	end
	
endmodule
