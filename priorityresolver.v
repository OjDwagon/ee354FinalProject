`timescale 1ns/1ps
// priority resolver.v

module PriorityResolver(
	input [15:0] requestSignals,
	output reg [15:0] grantSignals
);

	always@(*)
	begin
		grantSignals <= 16'b0000_0000_0000_0000;
		if(requestSignals[0] == 1'b1) grantSignals[0] <= 1'b1;
		else if (requestSignals[1] == 1'b1) grantSignals[1] <= 1'b1;
		else if (requestSignals[2] == 1'b1) grantSignals[2] <= 1'b1;
		else if (requestSignals[3] == 1'b1) grantSignals[3] <= 1'b1;
		else if (requestSignals[4] == 1'b1) grantSignals[4] <= 1'b1;
		else if (requestSignals[5] == 1'b1) grantSignals[5] <= 1'b1;
		else if (requestSignals[6] == 1'b1) grantSignals[6] <= 1'b1;
		else if (requestSignals[7] == 1'b1) grantSignals[7] <= 1'b1;
		else if (requestSignals[8] == 1'b1) grantSignals[8] <= 1'b1;
		else if (requestSignals[9] == 1'b1) grantSignals[9] <= 1'b1;
		else if (requestSignals[10] == 1'b1) grantSignals[10] <= 1'b1;
		else if (requestSignals[11] == 1'b1) grantSignals[11] <= 1'b1;
		else if (requestSignals[12] == 1'b1) grantSignals[12] <= 1'b1;
		else if (requestSignals[13] == 1'b1) grantSignals[13] <= 1'b1;
		else if (requestSignals[14] == 1'b1) grantSignals[14] <= 1'b1;
		else if (requestSignals[15] == 1'b1) grantSignals[15] <= 1'b1;
		/*
		case(requestSignals)
			
			16'bXXXX_XXXX_XXXX_XXX1: grantSignals = 16'b0000_0000_0000_0001;
			16'bXXXX_XXXX_XXXX_XX10: grantSignals = 16'b0000_0000_0000_0010;
			16'bXXXX_XXXX_XXXX_X100: grantSignals = 16'b0000_0000_0000_0100;
			16'bXXXX_XXXX_XXXX_1000: grantSignals = 16'b0000_0000_0000_1000;
			16'bXXXX_XXXX_XXX1_0000: grantSignals = 16'b0000_0000_0001_0000;
			16'bXXXX_XXXX_XX10_0000: grantSignals = 16'b0000_0000_0010_0000;
			16'bXXXX_XXXX_X100_0000: grantSignals = 16'b0000_0000_0100_0000;
			16'bXXXX_XXXX_1000_0000: grantSignals = 16'b0000_0000_1000_0000;
			16'bXXXX_XXX1_0000_0000: grantSignals = 16'b0000_0001_0000_0000;
			16'bXXXX_XX10_0000_0000: grantSignals = 16'b0000_0010_0000_0000;
			16'bXXXX_X100_0000_0000: grantSignals = 16'b0000_0100_0000_0000;
			16'bXXXX_1000_0000_0000: grantSignals = 16'b0000_1000_0000_0000;
			16'bXXX1_0000_0000_0000: grantSignals = 16'b0001_0000_0000_0000;
			16'bXX10_0000_0000_0000: grantSignals = 16'b0010_0000_0000_0000;
			16'bX100_0000_0000_0000: grantSignals = 16'b0100_0000_0000_0000;
			16'b1000_0000_0000_0000: grantSignals = 16'b1000_0000_0000_0000;
			default: grantSignals = 16'b0000_0000_0000_0000;
		endcase
		*/
	end

endmodule