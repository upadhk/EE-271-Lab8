module count(reset, in, displayTens, displayOnes, guesses);
	input logic reset, in;
	output logic [6:0] displayTens, displayOnes;
	output logic [7:0] guesses;
	
	logic [3:0] countOnes, countTens;
	
	// Counters
	always @(posedge in or posedge reset) begin //Cannot be clocked since count should increase only when
															  // a guess is submitted or reset if switch 9 is toggled
		if (reset) begin
			countOnes <= 4'b0000;
			countTens <= 4'b0000;
			guesses <= 0;
		end else if (in) begin
			guesses = guesses + 1;
			if (countOnes < 9)
				countOnes <= countOnes + 4'b0001;	//Splits counter up into the ones place...
			else begin
				if (countTens < 9)
					countTens <= countTens + 1;		//... and tens place!
				else begin
					countTens <= 0;
				end
				countOnes = 0;
			end
		end
	end
	
	// Ones place display
	always_comb begin
		case (countOnes)
			4'b0000: displayOnes = 7'b1000000;	// 0
			4'b0001: displayOnes = 7'b1111001;	// 1
			4'b0010: displayOnes = 7'b0100100;	// 2
			4'b0011: displayOnes = 7'b0110000;	// 3
			4'b0100: displayOnes = 7'b0011001;	// 4
			4'b0101: displayOnes = 7'b0010010;	// 5
			4'b0110: displayOnes = 7'b0000010;	// 6
			4'b0111: displayOnes = 7'b1111000;	// 7
			4'b1000: displayOnes = 7'b0000000;	// 8
			4'b1001: displayOnes = 7'b0010000;	// 9
			default: displayOnes = 7'b1111111;
		endcase
	end
	
	// Tens place display
	always_comb begin
		case (countTens)
			4'b0000: displayTens = 7'b1000000;	// 0
			4'b0001: displayTens = 7'b1111001;	// 1
			4'b0010: displayTens = 7'b0100100;	// 2
			4'b0011: displayTens = 7'b0110000;	// 3
			4'b0100: displayTens = 7'b0011001;	// 4
			4'b0101: displayTens = 7'b0010010;	// 5
			4'b0110: displayTens = 7'b0000010;	// 6
			4'b0111: displayTens = 7'b1111000;	// 7
			4'b1000: displayTens = 7'b0000000;	// 8
			4'b1001: displayTens = 7'b0010000;	// 9
			default: displayTens = 7'b1111111;
		endcase
	end
endmodule
