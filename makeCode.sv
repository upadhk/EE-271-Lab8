module makeCode(clk, reset, code3, code2, code1, code0);
	input logic clk, reset;
	output reg [1:0] code3, code2, code1, code0;
	
	logic [7:0] ps = 8'b0000000;		//2 bits for each digit
	logic [7:0] ns;
	logic in;
	
	// Next state logic
	always_comb begin
		in = ~(ps[7] ^ ps[5] ^ ps[4] ^ ps[3]); 	//Follows LFSR format
		ns = {ps[6:0], in};
	end
	
	// Output logic
	assign code3 = {ps[7], ps[6]};	//Assigns 2 bits of the randomly generated number
	assign code2 = {ps[5], ps[4]};	// to each of the four digits of the secret code
	assign code1 = {ps[3], ps[2]};
	assign code0 = {ps[1], ps[0]};
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= ns;
		else
			ps <= ps;
	end
endmodule

module makeCode_testbench();
	logic clk, reset;
	logic [1:0] code3, code2, code1, code0;
	
	makeCode dut(.clk, .reset, .code3, .code2, .code1, .code0);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	initial begin
		reset <= 1;								@(posedge clk);
													@(posedge clk);
		reset <= 0;								@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		reset <= 1;								@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		$stop;
	end
endmodule
