module displayCorrVals(clk, reset, in, value, displayOut);
	input logic clk, reset, in;
	input logic [2:0] value;
	output logic [6:0] displayOut;	//Displays the number of correct digits (position and value)
												// and the number of digits with just the correct value
	// State variables
	enum {A, B, C, D} ps, ns;
	
	// Nest state logic
	always_comb begin
		case (ps)
			A: if (in)
					ns = C;
				else
					ns = A;
			B: if (in)
					ns = C;
				else
					ns = B;
			C: if (in)
					ns = D;
				else
					ns = B;
			D: if (in)
					ns = D;
				else
					ns = B;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ps)
			A: displayOut = 7'b1000000;
			default: case (value)
							3'b000: displayOut = 7'b1000000;	// 0
							3'b001: displayOut = 7'b1111001;	// 1
							3'b010: displayOut = 7'b0100100;	// 2
							3'b011: displayOut = 7'b0110000;	// 3
							3'b100: displayOut = 7'b0011001;	// 4
							default:	displayOut = 7'b1111111;
						endcase
		endcase
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
endmodule

module displayCorrVals_testbench();
	logic clk, reset, in;
	logic [2:0] value;
	logic [6:0] displayOut;
	
	displayCorrVals dut(.clk, .reset, .in, .value, .displayOut);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	initial begin
		reset <= 1;	in <= 1;			@(posedge clk);
											@(posedge clk);
		reset <= 0;	in <= 0;			@(posedge clk);
											@(posedge clk);
		value <= 1;						@(posedge clk);
											@(posedge clk);
		value <= 2;						@(posedge clk);
											@(posedge clk);
		value <= 3;						@(posedge clk);
											@(posedge clk);
		value <= 4;						@(posedge clk);
											@(posedge clk);
		value <= 5;						@(posedge clk);
											@(posedge clk);	
		in <= 1;							@(posedge clk);
											@(posedge clk);
		in <= 0;							@(posedge clk);
											@(posedge clk);
		$stop;
	end
endmodule
