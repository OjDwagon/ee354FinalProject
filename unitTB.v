`timescale 1ns/1ps
// unitTB.v

module unitTB;

	 // when you write testbenches, don't need inputs outputs, just registers to store the values in
	
	// Inputs
	reg clk;
	reg reset;
	reg	moveSCEN;
	reg damageSCEN;
	reg [7:0] damageIn;
	reg [8:0] enemyFront;
	reg SW1;
	reg SW2;
	reg SW3;
	reg purchase;
	
	// Outputs
	wire [8:0] position;
	wire [7:0] damageOut;
	wire [1:0] unitType;
	reg [9*8:0] state_string; // state strings are all 9 characters long

	wire q_I;
	wire q_Deploy1;
	wire q_Deploy2;
	wire q_Deploy3;
	wire q_Alive;
	
	wire [7:0] health;

	//Testbench parameters
	integer file_descriptor_ID;

	// Module instantiation
	Unit uut(
		.clk(clk),
		.reset(reset),
		.moveSCEN(moveSCEN),
		.damageSCEN(damageSCEN),
		.damageIn(damageIn),
		.SW1(SW1),
		.SW2(SW2),
		.SW3(SW3),
		.purchase(purchase),
		.enemyFront(enemyFront),
		
		.position(position),
		.damageOut(damageOut),
		.unitType(unitType),
		
		// state outputs
		.q_I(q_I),
		.q_Deploy1(q_Deploy1),
		.q_Deploy2(q_Deploy2),
		.q_Deploy3(q_Deploy3),
		.q_Alive(q_Alive),
		
		.health(health)
		
	);

	initial begin
		begin: CLOCK_GENERATOR
			clk = 0;
			forever begin
				#5 clk = ~ clk;
			end
		end
	end
	initial begin
		#0 reset = 0;
		#20 reset = 1;
		#20 reset = 0;
	end
	
	/*-------- clock counter --------*/
	integer clk_cnt; // start_clk_cnt, clocks_taken;
	always @(posedge clk) begin
		if(reset) begin
			clk_cnt = 0;
		end
		else begin
			clk_cnt = clk_cnt + 1;
		end
	end
	
	
	initial begin
	
		//start_clk_cnt = 0;
		//clocks_taken = 0;
		file_descriptor_ID = 0;
		file_descriptor_ID = $fopen("unit_output.txt","w");
		
		#100 // waiting for set up
		
		$display("Type 1 test");
		$fdisplay(file_descriptor_ID, "Type 1 test");
		APPLY_STIMULUS(1'b1, 1'b0, 1'b0); // type 1 test
		/*$display("Type 2 test");
		$fdisplay(file_descriptor_ID, "Type 2 test");
		APPLY_STIMULUS(1'b0, 1'b1, 1'b0); // type 2 test
		$display("Type 3 test");
		$fdisplay(file_descriptor_ID, "Type 3 test");
		APPLY_STIMULUS(1'b0, 1'b0, 1'b1); // type 3 test*/
	
	end

	task APPLY_STIMULUS;
		input SW1_in, SW2_in, SW3_in;
		begin
			SW1 = SW1_in;
			SW2 = SW2_in;
			SW3 = SW3_in;
			
			@(posedge clk);
			#1
			purchase = 1'b1; // apply stimulus after clock edge
			#4 // read towards the middle of the clock
			$display("State: %s", state_string); // In INIT
			$display("Unit Type ID: %d", unitType); // unit should be 0
			$fdisplay(file_descriptor_ID, "Unit Type ID: %d", unitType); // type of unit should still be 0
			
			@(posedge clk);
			#1
			purchase = 1'b0;
			#4 // read towards the middle of the clock
			$display("State: %s", state_string); // In DEPLOY
			$display("Unit Type ID: %d", unitType); // type should still be 0, gets turned into corresponding type after next clock)
			$fdisplay(file_descriptor_ID, "Unit Type ID: %d", unitType);
			
			@(posedge clk);
			#1
			moveSCEN = 1;
			#4
			$display("State: %s", state_string); // In ALIVE 
			$display("Unit Type ID: %d", unitType); // type should now be corresponding type
			$fdisplay(file_descriptor_ID, "Unit Type ID: %d", unitType);
			$display("Old position: %d", position); // should be at the end of the field 512
			
			
			@(posedge clk);
			$display("Move test");
			
			#1
			damageSCEN = 1;
			moveSCEN = 0;
			damageIn = 8'b1000_0000;
			#4
			$display("New position: %d", position); // should be updated
			$display("Health before attack: %d", health);
			$display("Damage to be applied: %d", damageIn);
			
			@(posedge clk);
			$display("Attack test");
			#1
			moveSCEN = 0;
			damageSCEN = 1;
			damageIn = 8'b1000_0000; // should kill enemy
			#4
			$display("Health after attack: %d", health);
			$display("Damage to be applied: %d", damageIn);			
			
			
			@(posedge clk);
			#1
			damageIn = 8'b0000_0000;
			#4
			$display("Back to Init State");
			$display("State: %s", state_string);
			$display("Unit Type ID: %d", unitType);
			
			
		end
	endtask
	
	always @(*)
		begin
			case ({q_I, q_Deploy1, q_Deploy2, q_Deploy3, q_Alive})    // Note the concatenation operator {}
				5'b10000: state_string = "q_I      ";  // ****** TODO ******
				5'b01000: state_string = "q_Deploy1";  // Fill-in the three lines
				5'b00100: state_string = "q_Deploy2";
				5'b00010: state_string = "q_Deploy3";
				5'b00001: state_string = "q_Alive  ";
			endcase
		end
	


endmodule