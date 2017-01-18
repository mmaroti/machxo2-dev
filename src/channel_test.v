module testbench();
	parameter WIDTH = 8;

	reg clk;
	reg [7:0] counter;

	reg [WIDTH-1:0] in_dat;
	reg in_set;
	wire in_get;

	wire [WIDTH-1:0] mid_dat;
	wire mid_set;
	wire mid_get;

	wire [WIDTH-1:0] out_dat;
	wire out_set;
	reg out_get;
	
	channel ch1(.clk(clk), .in_dat(in_dat), .in_set(in_set), .in_get(in_get), .out_dat(mid_dat), .out_set(mid_set), .out_get(mid_get));
	channel ch2(.clk(clk), .in_dat(mid_dat), .in_set(mid_set), .in_get(mid_get), .out_dat(out_dat), .out_set(out_set), .out_get(out_get));

	initial
	begin
		clk = 0;
		counter = 0;
		in_dat = 0;
		in_set = 0;
		out_get = 0;
		#100
		$finish;
	end

	always #1 clk = !clk;

	always @(posedge clk)
	begin
		if (counter == 10)
			in_set <= 1;
		else if (counter == 20)
			out_get <= 1;
		else if (counter == 30)
			in_set <= 0;
		else if (counter == 40)
			in_set <= 1;

		in_dat <= (in_set && in_get) ? in_dat + 1 : in_dat;
		counter <= counter + 1;
	end

endmodule
