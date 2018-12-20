module gameModes(clk, reset, on, off, loseGame, winGame, modeChoice);
	input logic clk, reset, on, off, loseGame, winGame;
	output logic modeChoice;
	
	// State variables
	enum {easy, hard, lost, won} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			easy: if (loseGame)
					ns = lost;
				else if (winGame)
					ns = won;
				else if (on)			//if key is pressed and LEDR[7] was previously off
											// we go to hard mode
					ns = hard;
				else
					ns = easy;
			hard: if (loseGame)		//stays in hard mode
					ns = lost;
				else if (winGame)		//stays in hard mode
					ns = lost;
				else if (off)			//if key is pressed and LEDR[7] was previously on
											// we go back to easy mode
					ns = easy;
				else
					ns = hard;
			lost: ns = lost;
			won: ns = won;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ps)
			easy: modeChoice = 1'b0;
			hard: modeChoice = 1'b1;
			lost: modeChoice = 1'b1;
			won:  modeChoice = 1'b0; 
		endcase
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= easy;
		else
			ps <= ns;
	end
endmodule

module gameModes_testbench();
	logic clk, reset;
	logic on, off, loseGame, winGame;
	logic modeChoice;
	
	gameModes dut(.clk, .reset, .on, .off, .loseGame, .winGame, .modeChoice);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	initial begin
		reset <= 1;						@(posedge clk);
											@(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
		on <= 1;							@(posedge clk);
											@(posedge clk);
		on <= 0;							@(posedge clk);
											@(posedge clk);
		off <= 1;						@(posedge clk);	
											@(posedge clk);
											@(posedge clk);
		loseGame = 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		loseGame = 0;					@(posedge clk);
											@(posedge clk);
		winGame = 1;					@(posedge clk);
											@(posedge clk);
		winGame = 0;					@(posedge clk);
											@(posedge clk);
		$stop;
	end
endmodule
