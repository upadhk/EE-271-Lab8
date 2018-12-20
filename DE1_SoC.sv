module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	 input logic 			CLOCK_50; // 50MHz clock.
	 output logic 	[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic 	[9:0] LEDR;
	 input logic 	[3:0] KEY; // True when not pressed, False when pressed
	 input logic 	[9:0] SW;
	 
	 // Generate clk off of CLOCK_50, whichClock picks rate.
	 logic [31:0] clk;
	 parameter whichClock = 15;
	 clock_divider cdiv (CLOCK_50, clk);
	 

	logic [1:0] digit3, digit2, digit1, digit0;							// four digit code
	logic [1:0] guessDigit3, guessDigit2, guessDigit1, guessDigit0;						// digits of user input for code
	logic [7:0] totalGuesses;													
	logic [3:0] corrNum3, corrNum2, corrNum1, corrNum0;				// number of digits with correct values and locations
	logic [3:0] corrVal3, corrVal2, corrVal1, corrVal0;				// number of digits with correct values only
	logic [3:0] totalCorrect, totalValuesOnly;							// total number of correct val+location and values only
	logic [6:0] guessDisp3, guessDisp2, guessDisp1, guessDisp0;		// hex displays for guesses
	logic [6:0] codeDisp3, codeDisp2, codeDisp1, codeDisp0;			// hex displays for code
	logic [6:0] locationDisp, valueDisp, counterTens, counterOnes;	// hex displays for game states

	
	
	// Random code generator
	makeCode generator(.clk(clk[whichClock]), .reset(SW[9]), .code3(digit3), .code2(digit2), .code1(digit1), .code0(digit0));
	
	// Make guess
	enterCode guess(.clk(clk[whichClock]), .reset(SW[9]), .guess3({SW[7], SW[6]}), .guess2({SW[5], SW[4]}), .guess1({SW[3], SW[2]}), .guess0({SW[1], SW[0]}), .submit(~KEY[3]|| LEDR[0] || LEDR[9]), .out3(guessDigit3), .out2(guessDigit2), .out1(guessDigit1), .out0(guessDigit0));
	
	// Compare guess with code
	compareNums C3(.reset(SW[9]), .guess(guessDigit3), .code3(digit3), .code2(digit2), .code1(digit1), .code0(digit0), .correctLocation(corrNum3), .valueOnly(corrVal3));
	compareNums C2(.reset(SW[9]), .guess(guessDigit2), .code3(digit2), .code2(digit3), .code1(digit1), .code0(digit0), .correctLocation(corrNum2), .valueOnly(corrVal2));
	compareNums C1(.reset(SW[9]), .guess(guessDigit1), .code3(digit1), .code2(digit3), .code1(digit2), .code0(digit0), .correctLocation(corrNum1), .valueOnly(corrVal1));
	compareNums C0(.reset(SW[9]), .guess(guessDigit0), .code3(digit0), .code2(digit3), .code1(digit2), .code0(digit1), .correctLocation(corrNum0), .valueOnly(corrVal0));
	
	// Finds total correct locations and total values only
	
	assign totalCorrect = corrNum3 + corrNum2 + corrNum1 + corrNum0; 		//calculates total number of digits in correct positions + values
	assign totalValuesOnly = corrVal3 + corrVal2 + corrVal1 + corrVal0;		//calculates total number of digits with correct value only
	
	// Win condition

	assign LEDR[0] = (totalCorrect == 3'b100);		//Lights up if you win
	
	// Select game mode
	gameModes mode(.clk(clk[whichClock]), .reset(SW[9]), .on(~KEY[1]), .off(~KEY[2]), .loseGame(LEDR[9]), .winGame(LEDR[0]), .modeChoice(LEDR[7]));
	gameLimit rounds(.reset(SW[9]), .totalGuesses(totalGuesses), .play(LEDR[7]), .gameOver(LEDR[9]));
	
	// Display user inputted guess code
	guessDisplay G3(.value({SW[7], SW[6]}), .display_hex(guessDisp3));
	guessDisplay G2(.value({SW[5], SW[4]}), .display_hex(guessDisp2));
	guessDisplay G1(.value({SW[3], SW[2]}), .display_hex(guessDisp1));
	guessDisplay G0(.value({SW[1], SW[0]}), .display_hex(guessDisp0));
	
	// Display generated code
	guessDisplay Code3(.value(digit3), .display_hex(codeDisp3));
	guessDisplay Code2(.value(digit2), .display_hex(codeDisp2));
	guessDisplay Code1(.value(digit1), .display_hex(codeDisp1));
	guessDisplay Code0(.value(digit0), .display_hex(codeDisp0));
	
	// Display number of correct numbers, misplaced numbers and guesses made
	displayCorrVals CL(.clk(clk[whichClock]), .reset(SW[9]), .in(~KEY[3]), .value(totalCorrect), .displayOut(locationDisp));
	displayCorrVals VO(.clk(clk[whichClock]), .reset(SW[9]), .in(~KEY[3]), .value(totalValuesOnly), .displayOut(valueDisp));
	count guessesMade(.reset(SW[9]), .in(~KEY[3] || LEDR[0]), .displayTens(counterTens), .displayOnes(counterOnes), .guesses(totalGuesses));
	
	// Display controls depending on SW[8] 
	always_comb begin
		if (LEDR[0] && ~LEDR[9]) begin
			if (SW[8]) begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = codeDisp3;
				HEX2 = codeDisp2;
				HEX1 = codeDisp1;
				HEX0 = codeDisp0;
			end else begin
				HEX5 = locationDisp;
				HEX4 = 7'b1111111;
				HEX3 = valueDisp;
				HEX2 = 7'b1111111;
				HEX1 = counterTens;
				HEX0 = counterOnes;
			end
		end
		else if (LEDR[9]) begin
			if (SW[8]) begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = codeDisp3;
				HEX2 = codeDisp2;
				HEX1 = codeDisp1;
				HEX0 = codeDisp0;
			end else begin
				HEX5 = 7'b1000111; // L
				HEX4 = 7'b0100011; // o
				HEX3 = 7'b0010010; // s
				HEX2 = 7'b0000110; // E
				HEX1 = 7'b0101111; // r
				HEX0 = 7'b1111111;
			end
		end
		else begin
			if (SW[8]) begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = guessDisp3;
				HEX2 = guessDisp2;
				HEX1 = guessDisp1;
				HEX0 = guessDisp0;
			end else begin
				HEX5 = locationDisp;
				HEX4 = 7'b1111111;
				HEX3 = valueDisp;
				HEX2 = 7'b1111111;
				HEX1 = counterTens;
				HEX0 = counterOnes;
			end
		end
	end
endmodule

module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;
	
	initial begin
		divided_clocks <= 0;
	end
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule

module DE1_SoC_testbench();
	logic 		CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
																																		@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[9] <= 1;																													@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[9] <= 0;																													@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[8] <= 1;																													@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[7] <= 0; SW[6] <= 0; SW[5] <= 0; SW[4] <= 0; SW[3] <= 0; SW[2] <= 0; SW[1] <= 0; SW[0] <= 0;	@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		KEY[3] <= 0;																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		KEY[3] <= 1;																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[8] <= 0;																													@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[8] <= 1; 																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[7] <= 0; SW[6] <= 1; SW[5] <= 0; SW[4] <= 1; SW[3] <= 1; SW[2] <= 0; SW[1] <= 0; SW[0] <= 0;	@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		KEY[3] <= 0;																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		KEY[3] <= 1;																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		SW[7] <= 0; SW[6] <= 0; SW[5] <= 1; SW[4] <= 1; SW[3] <= 0; SW[2] <= 1; SW[1] <= 1; SW[0] <= 0;	@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		KEY[3] <= 0;																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
		KEY[3] <= 1;																												@(posedge CLOCK_50);
																																		@(posedge CLOCK_50);
							
		$stop;
	end
endmodule
