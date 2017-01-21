module testbench();
	parameter WIDTH = 8;

	reg clk;
	reg [7:0] counter;

	reg [WIDTH-1:0] in_dat;
	reg in_val;
	wire in_rdy;

	wire [WIDTH-1:0] mid_dat;
	wire mid_val;
	wire mid_rdy;

	wire [WIDTH-1:0] out_dat;
	wire out_val;
	reg out_rdy;
	
	channel ch1(.clk(clk), .in_dat(in_dat), .in_val(in_val), .in_rdy(in_rdy), .out_dat(mid_dat), .out_val(mid_val), .out_rdy(mid_rdy));
	channel ch2(.clk(clk), .in_dat(mid_dat), .in_val(mid_val), .in_rdy(mid_rdy), .out_dat(out_dat), .out_val(out_val), .out_rdy(out_rdy));

	initial
	begin
		clk = 0;
		counter = 0;
		in_dat = 0;
		in_val = 0;
		out_rdy = 0;
		#100
		$finish;
	end

	always #1 clk = !clk;

	always @(posedge clk)
	begin
		if (counter == 10)
			in_val <= 1;
		else if (counter == 20)
			out_rdy <= 1;
		else if (counter == 30)
			in_val <= 0;
		else if (counter == 40)
			in_val <= 1;

		in_dat <= (in_val && in_rdy) ? in_dat + 1 : in_dat;
		counter <= counter + 1;
	end

endmodule
