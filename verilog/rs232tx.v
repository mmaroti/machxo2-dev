/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module axis_rs232tx #(parameter real CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	input wire [7:0] idata,
	input wire ivalid,
	output reg iready,
	output reg txd_pin,	// connected to RXD pin of receiver
	input wire ctsn_pin); // connected to RTSn pin of receiver

reg ctsn, ctsn_pin2; // metastable buffering

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		ctsn <= 1'b1;
		ctsn_pin2 <= 1'b1;
	end
	else
	begin
		ctsn <= ctsn_pin2;
		ctsn_pin2 <= ctsn_pin;
	end
end

localparam integer BAUD_COUNT = 1.0 * CLOCK_FREQ / BAUD_RATE;
localparam integer BAUD_WIDTH = $clog2(BAUD_COUNT - 1);

reg [BAUD_WIDTH:0] baud_counter;
wire baud_tick = baud_counter[BAUD_WIDTH]; // set at underflow

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		baud_counter <= BAUD_COUNT - 2;
	else if (baud_tick || (iready && ivalid))
		baud_counter <= BAUD_COUNT - 2;
	else
		baud_counter <= baud_counter - 1;
end

reg [7:0] buffer; // shifting bits out to txd

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		txd_pin <= 1'b1;
		buffer <= 8'b1111111;
	end
	else if (iready && ivalid)
	begin
		txd_pin <= 1'b0;
		buffer <= idata;
	end
	else if (baud_tick)
	begin
		txd_pin <= buffer[0];
		buffer[6:0] <= buffer[7:1];
		buffer[7] <= 1'b1;
	end
end

reg [3:0] state; // the number of bits sent out

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		state <= 4'b0000;
	else if (iready && ivalid)
		state <= 4'b0000;
	else if (baud_tick)
		state <= state + 4'b0001;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		iready <= 1'b0;
	else if ((iready && ivalid) || ctsn)
		iready <= 1'b0;
	else
		iready <= (state[3] && state[1]) || iready;
end
endmodule
