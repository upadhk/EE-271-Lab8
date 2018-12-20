module compareNums(reset, guess, code3, code2, code1, code0, correctLocation, valueOnly);
	input logic reset;
	input logic [1:0] guess, code3, code2, code1, code0;
	output logic [2:0] correctLocation, valueOnly;
	
	always_comb begin
		if (reset) begin
			correctLocation = 3'b000;
			valueOnly = 3'b000;
		end else if (guess == code3) begin		//code3 represents the place that the digit is supposed to be
			correctLocation = 3'b001;
			valueOnly = 3'b000;
		end else begin
			if (guess == code2)						//if the guess is anywhere else, valueOnly is incremented
				valueOnly = 3'b001;
			else if (guess == code1)
				valueOnly = 3'b001;
			else if (guess == code0)
				valueOnly = 3'b001;
			else begin
				valueOnly = 3'b000;
			end
			correctLocation = 3'b000;
		end
	end
endmodule
