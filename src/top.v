module top(
	input clk,
	input [7:0] in_dat,
	input in_val,
	output in_rdy,
	output [7:0] out_dat,
	output out_val,
	input out_rdy);

// wire clk;
// OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clk), .SEDSTDBY());

channel ch1(.clk(clk), 
	.in_dat(in_dat), .in_val(in_val), .in_rdy(in_rdy),
	.out_dat(out_dat), .out_val(out_val), .out_rdy(out_rdy));

endmodule
