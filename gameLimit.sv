module gameLimit(reset, totalGuesses, play, gameOver);
	input logic reset, play;
	input logic [7:0] totalGuesses;
	output logic gameOver;
	
	always_comb begin
		if (play)
			if (totalGuesses > 8'b00001001)
				gameOver = 1'b1;
			else
				gameOver = 1'b0;
		else
			gameOver = 1'b0;
	end
endmodule

module gameLimit_testbench();
	logic reset, play;
	logic [7:0] totalGuesses;
	logic gameOver;
	
	gameLimit dut(.reset, .totalGuesses, .play, .gameOver);
	
	initial begin
		reset = 1; 						#10;			
		play = 1;						#10;
		reset = 0;						#10;
		totalGuesses = 0;				#10;
		totalGuesses = 1;				#10;
		totalGuesses = 2;				#10;
		totalGuesses = 3;				#10;
		totalGuesses = 4;				#10;
		totalGuesses = 5;				#10;
		totalGuesses = 6;				#10;
		totalGuesses = 7;				#10;
		totalGuesses = 8;				#10;
		totalGuesses = 9;				#10;
		totalGuesses = 10;			#10;
		totalGuesses = 11;			#10;
		totalGuesses = 12;			#10;
		totalGuesses = 13;			#10;
		totalGuesses = 14; 			#10;
		totalGuesses = 15;			#10;
		totalGuesses = 16;			#10;
		totalGuesses = 17;			#10;
		totalGuesses = 18;			#10;
		totalGuesses = 19;			#10;
		totalGuesses = 20;			#10;
	end
endmodule
