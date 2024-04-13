`timescale 1ns / 1ps

module GameEngineTB;

	// Inputs
	reg clk;
	reg rst;
	
	// Outputs
	wire gameSCEN;
	
	// Instantiate the Unit Under Test (UUT)
	GameEngine uut (
		.clk(clk),
		.rst(rst),
		.gameSCEN(gameSCEN)
	);
	
	// Create the clock
	initial begin
		begin: CLOCK_GENERATOR
			clk = 0;
			forever begin
				#5 clk = ~ clk;
			end
		end
	end
	
	// Reset the system
	initial begin
		#0 rst = 0;
		#20 rst = 1;
		#20 rst = 0;
	end
		
	/*-------- clock counter --------*/
	integer clk_cnt, start_clk_cnt, clocks_taken;
	always @(posedge clk) begin
		if(rst) begin
			clk_cnt = 0;
		end
		else begin
			clk_cnt = clk_cnt + 1;
		end
	end
		
	// Wait long enough to view a few gameSCENs
	initial begin
	// Wait 0.05 sec for 9 gameSCENs to display
	#50000000;
		
				


	end
      
endmodule
