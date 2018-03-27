/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module top(
	output reg [7:0] leds,
	input wire resetn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) osch(
	.STDBY(1'b0), 
	.OSC(clock), 
	.SEDSTDBY());

wire resetn;
button button_resetn(
	.clock(clock), 
	.signal(resetn), 
	.signal_pin(resetn_pin));

wire [7:0] data1;
wire valid1, ready1;
axis_counter #(.WIDTH(8)) counter(
	.clock(clock), 
	.resetn(resetn), 
	.odata(data1), 
	.ovalid(valid1), 
	.oready(ready1));

wire [7:0] data2;
wire valid2, ready2;
axis_throttle #(.WIDTH(8), .DELAY(133000000)) throttle(
	.clock(clock), 
	.resetn(resetn), 
	.idata(data1), 
	.ivalid(valid1), 
	.iready(ready1), 
	.odata(data2), 
	.ovalid(valid2), 
	.oready(ready2));

assign ready2 = 1'b1;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else if (valid2)
		leds <= ~data2;
end

endmodule
