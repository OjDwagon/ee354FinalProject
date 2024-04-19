`timescale 1ns/1ps
// priority resolver.v

module PriorityResolver(
input clkPort,
input Reset, 
input reg [15:0] requestSignals,
output reg [15:0] grantSignals,
);

always@(*)
begin
	case(requestSignals)
		16'bXXXX_XXXX_XXXX_XXX1: grantSignals <= 16'b0000_0000_0000_0001;
		16'bXXXX_XXXX_XXXX_XX10: grantSignals <= 16'b0000_0000_0000_0010;
		16'bXXXX_XXXX_XXXX_X100: grantSignals <= 16'b0000_0000_0000_0100;
		16'bXXXX_XXXX_XXXX_1000: grantSignals <= 16'b0000_0000_0000_1000;
		16'bXXXX_XXXX_XXX1_0000: grantSignals <= 16'b0000_0000_0001_0000;
		16'bXXXX_XXXX_XX10_0000: grantSignals <= 16'b0000_0000_0010_0000;
		16'bXXXX_XXXX_X100_0000: grantSignals <= 16'b0000_0000_0100_0000;
		16'bXXXX_XXXX_1000_0000: grantSignals <= 16'b0000_0000_1000_0000;
		16'bXXXX_XXX1_0000_0000: grantSignals <= 16'b0000_0001_0000_0000;
		16'bXXXX_XX10_0000_0000: grantSignals <= 16'b0000_0010_0000_0000;
		16'bXXXX_X100_0000_0000: grantSignals <= 16'b0000_0100_0000_0000;
		16'bXXXX_1000_0000_0000: grantSignals <= 16'b0000_1000_0000_0000;
		16'bXXX1_0000_0000_0000: grantSignals <= 16'b0001_0000_0000_0000;
		16'bXX10_0000_0000_0000: grantSignals <= 16'b0010_0000_0000_0000;
		16'bX100_0000_0000_0000: grantSignals <= 16'b0100_0000_0000_0000;
		16'b1000_0000_0000_0000: grantSignals <= 16'b1000_0000_0000_0000;
		default 16'bXXXX_XXXX_XXXX_XXXX: grantSignals <= 16'b0000_0000_0000_0000;
	endcase
end

endmodule