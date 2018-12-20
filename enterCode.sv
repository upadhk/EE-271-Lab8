module enterCode(clk, reset, guess3, guess2, guess1, guess0, submit, out3, out2, out1, out0);
	input logic clk, reset, submit;
	input logic [1:0] guess3, guess2, guess1, guess0;
	output logic [1:0] out3, out2, out1, out0;
	
	// State variables
	enum {off, store, keep} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			off:	if (submit)
					ns = store;
				else
					ns = off;
			store: if (submit)
					ns = keep;
				else
					ns = off;
			keep: if (submit)
					ns = keep;
				else
					ns = off;
		endcase
	end
	
	// Output logic	
	always_ff @(posedge clk) begin
		if(ns == store) begin
			out3 = guess3;
			out2 = guess2;
			out1 = guess1;
			out0 = guess0;
		end
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= off;
		else
			ps <= ns;
	end
endmodule

module submitCode_testbench();
	logic clk, reset, submit; 
	logic [1:0] guess3, guess2, guess1, guess0;
	logic [1:0] out3, out2, out1, out0;
	
	enterCode dut(.clk, .reset, .submit, .guess3, .guess2, .guess1, .guess0, .out3, .out2, .out1, .out0);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;																									 @(posedge clk);	
		reset <= 0;																									 @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;	submit <= 1; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					 @(posedge clk);
		guess3 <= 2'b11;	guess2 <= 2'b00;	guess1 <= 2'b00;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;	submit <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	submit <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					 @(posedge clk);
																										submit <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	submit <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					 @(posedge clk);
																										submit <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	submit <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					 @(posedge clk);
																										submit <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	submit <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					 @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					 @(posedge clk);
		
		$stop;
	end
endmodule
