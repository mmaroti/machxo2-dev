/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module top(
	output reg [7:0] leds,
    input wire resetn_pin,
	input wire rxd_pin,
	output wire rtsn_pin,
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

wire [7:0] data;
wire write;

// localparam BAUD_RATE = 115200;
localparam BAUD_RATE = 12000000;

rs232_to_push #(.CLOCK_FREQ(133000000), .BAUD_RATE(BAUD_RATE)) rs232_rx(
    .clock(clock),
    .resetn(resetn),
    .rxd_pin(rxd_pin),
    .rtsn_pin(rtsn_pin),
    .odata(data),
    .owrite(write),
    .oafull(1'b0));

reg [7:0] counter;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		counter <= 8'b0;
	else if (write)
	begin
		counter[7:4] <= data[7:4];
		counter[3:0] <= counter[3:0] + 1'b1;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
		leds <= ~counter;
end

/*
axis_to_rs232 #(.CLOCK_FREQ(133000000), .BAUD_RATE(BAUD_RATE)) rs232_tx(
    .clock(clock),
    .resetn(resetn),
    .idata(data),
    .ivalid(valid),
    .iready(ready),
    .txd_pin(txd_pin),
    .ctsn_pin(ctsn_pin));
*/

endmodule
