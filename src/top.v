module top(
	input clk,
	input [7:0] in_dat,
	input in_set,
	output in_get,
	output [7:0] out_dat,
	output out_set,
	input out_get);

// wire clk;
// OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clk), .SEDSTDBY());


channel ch1(.clk(clk), 
	.in_dat(in_dat), .in_set(in_set), .in_get(in_get),
	.out_dat(out_dat), .out_set(out_set), .out_get(out_get));

endmodule
