`timescale 1ns / 1ps

module PriorityResolverTB;
	
	// Inputs
	reg [15:0] requestSignals;
	
	// Output
	wire [15:0] grantSignals;
	
	
	// Test bench parameters;
	integer file_fd;
	reg [15:0] tempRequestSignals;
	
	
	// Instantiate the Unit Under Test (UUT)	
   PriorityResolver uut (
		.requestSignals(requestSignals),
		.grantSignals(grantSignals)
   );
		
		
		
		initial begin

		file_fd = $fopen("priorityResolver.txt", "w");

		// Wait 100 ns for global reset to finish
		#103;
		
		for(tempRequestSignals = 0; tempRequestSignals < 16'b1111_1111_1111_1111;)
		begin
			APPLY_STIMULUS(tempRequestSignals);
			tempRequestSignals = tempRequestSignals / 2;
			tempRequestSignals = tempRequestSignals + 16'b1000_0000_0000_0000;
		end
		
		// requestSignals = 16'b1000_0000_0000_0000;
		#20;
		

		$fclose(file_fd);
		$display("All things processed.");
		
				


	end
	
	task APPLY_STIMULUS;
	input [15:0] requestSignalsIn;
	begin
		// Assign the Inputs
		requestSignals = requestSignalsIn;
		
		#5;
		$fdisplay(file_fd, "Requests: %b led to Grants: %b", requestSignals, grantSignals);
		// $fdisplay(file_fd, "In test number %d the friendlyFront is %d and the enemyFront is %d", testNum, friendlyFront, enemyFront);
		// $fdisplay(file_fd, "It took %d clock(s) to compute the battlefront for test number %d", clocks_taken, testNum);
		#20;
	end
	endtask
	 
endmodule

