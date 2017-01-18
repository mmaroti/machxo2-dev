/* 
Moves data from in_dat to out_dat. Data is transferred on the ports 
when both xx_set and xx_get are high on the rising edge of the clock.
*/

module channel #(parameter WIDTH = 8) (
	input wire clk, 
	input wire [WIDTH-1:0] in_dat, 
	input wire in_set,
	output reg in_get,
	output reg [WIDTH-1:0] out_dat, 
	output reg out_set, 
	input wire out_get);

    reg [WIDTH-1:0] buffer;

	initial
	begin
		in_get = 1'b1;
		out_dat = {WIDTH{1'bx}};
		out_set = 1'b0;
		buffer = {WIDTH{1'bx}};
	end

	always @(posedge clk)
	begin
		out_set <= (out_set && !out_get) || !in_get || in_set;
		out_dat <= (out_set && !out_get) ? out_dat : (!in_get ? buffer : in_dat);

		in_get <= !out_set || out_get;
		buffer <= (out_set && !out_get && in_set && in_get) ? in_dat : buffer;
	end

endmodule
