/*
Moves data from in_dat to out_dat. Data is transferred on the ports
when both xx_val and xx_rdy are high on the rising edge of the clock.
*/

module channel #(parameter WIDTH = 8) (
	input wire clk,
	input wire [WIDTH-1:0] in_dat,
	input wire in_val,
	output reg in_rdy,
	output reg [WIDTH-1:0] out_dat,
	output reg out_val,
	input wire out_rdy);

	reg [WIDTH-1:0] buffer;

	initial
	begin
		in_rdy = 1'b1;
		out_dat = {WIDTH{1'bx}};
		out_val = 1'b0;
		buffer = {WIDTH{1'bx}};
	end

	always @(posedge clk)
	begin
		out_val <= (out_val && !out_rdy) || !in_rdy || in_val;
		out_dat <= (out_val && !out_rdy) ? out_dat : (!in_rdy ? buffer : in_dat);

		in_rdy <= !out_val || out_rdy;
		buffer <= (out_val && !out_rdy && in_val && in_rdy) ? in_dat : buffer;
	end

endmodule
