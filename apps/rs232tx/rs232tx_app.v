/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`default_nettype none

module top(
	output reg [7:0] leds,
    input wire resetn_pin,    
	output wire txd_pin,
	input wire ctsn_pin);

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

wire [7:0] counter;
wire valid;
wire ready;
axis_counter #(.WIDTH(8)) counter_gen(
	.clock(clock), 
	.resetn(resetn), 
	.odata(counter),
	.ovalid(valid), 
	.oready(ready));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
		leds <= ~counter;
end

/*
wire [7:0] counter2;
wire valid2;
wire ready2;
axis_throttle #(.DELAY(1000000)) throttle_inst(
	.clock(clock), 
	.resetn(resetn), 
	.idata(counter),
	.ivalid(valid),
	.iready(ready),
	.odata(counter2),
	.ovalid(valid2), 
	.oready(ready2));
*/

// localparam BAUD_RATE = 115200;
localparam BAUD_RATE = 12000000;

axis_to_rs232 #(.CLOCK_FREQ(133000000), .BAUD_RATE(BAUD_RATE)) rs232tx_inst(
    .clock(clock),
    .resetn(resetn),
    .idata(counter),
    .ivalid(valid),
    .iready(ready),
    .txd_pin(txd_pin),
    .ctsn_pin(ctsn_pin));

endmodule
