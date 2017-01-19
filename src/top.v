module top(
//	input clk,
	output rs232_rxd,
	input rs232_rts_n,
	input [7:0] in_dat,
	input in_val,
	output in_rdy);

wire clk;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clk), .SEDSTDBY());

wire [7:0] data;
wire valid;
wire ready;

channel ch1(.clk(clk), 
	.in_dat(in_dat), .in_val(in_val), .in_rdy(in_rdy),
	.out_dat(data), .out_val(valid), .out_rdy(ready));

rs232_transmitter trans(
	.clock(clk),
	.reset(1'b0),
	.rs232_rxd(rs232_rxd),
	.rs232_rts_n(rs232_rts_n),
	.data(data),
	.valid(valid),
	.ready(ready));

endmodule
