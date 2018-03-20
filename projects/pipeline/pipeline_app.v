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
button resetn_gen(
	.clock(clock), 
	.signal(resetn), 
	.signal_pin(resetn_pin));

wire [7:0] counter1;
wire valid1;
wire ready1;
axis_counter #(.WIDTH(8)) counter_gen(
	.clock(clock), 
	.resetn(resetn), 
	.odata(counter1), 
	.ovalid(valid1), 
	.oready(ready1));

wire [7:0] counter2;
wire valid2;
wire ready2;
axis_throttle #(.WIDTH(8), .DELAY(133000000)) delay_gen(
	.clock(clock), 
	.resetn(resetn), 
	.idata(counter1), 
	.ivalid(valid1), 
	.iready(ready1), 
	.odata(counter2), 
	.ovalid(valid2), 
	.oready(ready2));

assign ready2 = 1'b1;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
		leds <= ~counter2;
end

endmodule
