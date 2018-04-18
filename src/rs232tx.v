/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`default_nettype none

/**
 * This module convertes an AXI stream byte stream to a RS232 serial interface
 * with hardware flow control. The implementation might start the transmission
 * of one extra byte when the CTSn is set to low, but this is normal in serial
 * communication. The txd_pin must be connected to the RXD pin of the receiver.
 * The ctsn_pin must be connected to the RTSn pin of the receiver.
 */
module axis_to_rs232 #(parameter real CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	input wire [7:0] idata,
	input wire ivalid,
	output reg iready,
	output reg txd_pin,
	input wire ctsn_pin);

/*
 * This is the baud rate generator that sets baud_tick to 1 for one clock
 * every BAUD_COUNT many clock cycles. We count downwards and use the highest
 * bit as the baud_tick when underflow occurs. When BAUD_COUNT is 2, then
 * we see that baud_counter needs to be set to 0, so in the next cycle we
 * get the desired underflow.
 */

localparam integer BAUD_COUNT = 1.0 * CLOCK_FREQ / BAUD_RATE;
localparam integer BAUD_WIDTH = $clog2(BAUD_COUNT - 1);

reg [BAUD_WIDTH:0] baud_counter;
wire baud_tick = baud_counter[BAUD_WIDTH];

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		baud_counter <= BAUD_COUNT - 2;
	else if (baud_tick || (iready && ivalid))
		baud_counter <= BAUD_COUNT - 2;
	else
		baud_counter <= baud_counter - 1'b1;
end

/*
 * We use a shift register buffer to shift the bits out. Transmission
 * starts when iready and ivalid are both true, and continuous at every
 * baud tick. We add one the 0 start bit and the 1 stop bit.
 */

reg [7:0] buffer;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		{buffer, txd_pin} <= 9'b111111111;
	else if (iready && ivalid)
		{buffer, txd_pin} <= {idata, 1'b0};
	else if (baud_tick)
		{buffer, txd_pin} <= {1'b1, buffer};
end

/*
 * The state is a 4-bit number containing the number of bits we sent
 * including the start and stop bits. Thus state becomes zero when
 * we start sending the start bit, and becomes 10 just after finishing
 * the transmission of the stop bit.
 */

reg [3:0] state;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		state <= 4'b0000;
	else if (iready && ivalid)
		state <= 4'b0000;
	else if (baud_tick)
		state <= state + 4'b0001;
end

/*
 * We use two registers to avoid metastability problems on the CTSn pin.
 */

reg ctsn, ctsn_pin2;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		{ctsn, ctsn_pin2} <= 2'b11;
	else
		{ctsn, ctsn_pin2} <= {ctsn_pin2, ctsn_pin};
end

/*
 * Iready becomes false when we start the transmission or when the
 * receiver is indicating to stop with the CTSn signal (which is
 * slightly delayed by the buffering). Iready becomes true when
 * state is 10 (we are getting smart and check this condition
 * using state[3] && state[1]). We leave the state counter and the
 * baud rate generator running, because more logic (and LUTs) would
 * be needed to prevent them updating. Thus we has to stay in iready
 * mode once we are already there.
 */

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
