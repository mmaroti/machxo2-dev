/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`default_nettype none

module top(
	output reg [7:0] leds,
    input wire resetn_pin,
	input wire rxd_pin,
	output wire rtsn_pin,
	output wire txd_pin,
	input wire ctsn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) osch_inst(
	.STDBY(1'b0),
	.OSC(clock),
	.SEDSTDBY());

wire resetn;
button button_inst(
	.clock(clock),
	.signal(resetn),
	.signal_pin(resetn_pin));

// localparam BAUD_RATE = 115200;
localparam BAUD_RATE = 12000000;

wire [7:0] data;
wire overflow, valid, ready;
rs232_to_axis2 #(.CLOCK_FREQ(133000000), .BAUD_RATE(BAUD_RATE)) rs232_to_axis_inst(
    .clock(clock),
    .resetn(resetn),
	.overflow(overflow),
    .rxd_pin(rxd_pin),
    .rtsn_pin(rtsn_pin),
    .odata(data),
    .ovalid(valid),
    .oready(ready));

axis_to_rs232 #(.CLOCK_FREQ(133000000), .BAUD_RATE(BAUD_RATE)) axis_to_rs232_inst(
    .clock(clock),
    .resetn(resetn),
    .idata(~data), // we negate the data here
    .ivalid(valid),
    .iready(ready),
    .txd_pin(txd_pin),
    .ctsn_pin(ctsn_pin));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
	begin
		leds[7] <= ~overflow;
		leds[6] <= ~valid;
		leds[5] <= ~ready;
		if (valid && ready)
			leds[4:0] <= ~data[4:0];
	end
end
endmodule
