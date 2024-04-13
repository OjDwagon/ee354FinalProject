// project_top.v

module project_top(

	input ClkPort,
	input BtnC,
	
	//VGA signal
	//output hSync, vSync,
	//output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS

);
	// wire bright;
	// wire[9:0] hc, vc;
	wire[15:0] score;
	wire [6:0] ssdOut;
	wire [3:0] anode;
	//wire [11:0] rgb;
	
	wire buySucc;
	wire maxed;
	wire purchase;

	wire [11:0] unitCost;
	wire [1:0] level;
	wire [11:0] balance;
	
	wire gameClk;
	wire reset;
	
	assign purchase = ;
	assign 
	
	//display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	// vga_bitchange vbc(.clk(ClkPort), .bright(bright), .button(BtnU), .hCount(hc), .vCount(vc), .rgb(rgb), .score(score));
	counter cnt(.clk(ClkPort), .displayNumber(score), .anode(anode), .ssdOut(ssdOut));
    Wallet wallet(.clk(ClkPort), .gameClk(gameClk) , .rst(reset), .purchase(), .unitCost(unitCost), .level(level),
				  .balance(balance), .maxed(maxed), .buySucc(buySucc));
	
	

	assign Dp = 1;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};
	
	
	//assign vgaR = rgb[11 : 8];
	//assign vgaG = rgb[7  : 4];
	//assign vgaB = rgb[3  : 0];
	
	// disable memory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;


endmodule