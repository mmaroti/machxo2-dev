/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module push_rs232rx #(parameter real CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	input wire rxd_pin, // connected to the TXD pin of receiver
	output wire rtsn_pin, // connected to the CTSn pin of receiver
	output reg [7:0] odata,
	output reg ostrobe);

reg rxd, rxd_pin2; // metastable buffering

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		rxd <= 1'b1;
		rxd_pin2 <= 1'b1;
	end
	else
	begin
		rxd <= rxd_pin2;
		rxd_pin2 <= rxd_pin;
	end
end

localparam integer BAUD_COUNT_HALF = 0.5 * CLOCK_FREQ / BAUD_RATE;
localparam integer BAUD_COUNT_FULL = 1.0 * CLOCK_FREQ / BAUD_RATE;
localparam integer BAUD_WIDTH = $clog2(BAUD_COUNT_FULL - 1);

wire baud_reset; // set from state logic
reg [BAUD_WIDTH:0] baud_counter;
wire baud_tick = baud_counter[BAUD_WIDTH]; // set at underflow

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		baud_counter <= BAUD_COUNT_FULL - 2;
	else if (baud_reset)
		baud_counter <= BAUD_COUNT_HALF - 2;
	else if (baud_tick)
		baud_counter <= BAUD_COUNT_FULL - 2;
	else
		baud_counter <= baud_counter - 1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		odata <= 8'b1;
		rxd <= 1'b1;
	end
	else if (baud_tick)
	begin
		odata[6:0] <= odata[7:1];
		odata[7] <= rxd;
	end
end
endmodule
