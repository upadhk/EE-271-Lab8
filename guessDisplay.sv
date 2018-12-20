module guessDisplay(value, display_hex);	//Displays the guess count onto the hex display
	input logic [1:0] value;
	output logic [6:0] display_hex;
	
	always_comb begin
		case (value)								//Translates binary value into corresponding hex display pattern
			2'b00: display_hex = 7'b1000000;	// 0
			2'b01: display_hex = 7'b1111001;	// 1
			2'b10: display_hex = 7'b0100100;	// 2
			2'b11: display_hex = 7'b0110000;	// 3
		endcase
	end
endmodule
