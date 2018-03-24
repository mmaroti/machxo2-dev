/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * This module convertes an RS232 serial interface with hardware control into
 * a push based handshake with almost full signal. The rxd_pin must be connected
 * to the TXD pin of the transmitter, and the rtsn_pin must be connected to the
 * CTSn pin of the transmitter.
 */
module rs232_to_push #(parameter real CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	input wire rxd_pin, // connected to the TXD pin of receiver
	output wire rtsn_pin, // connected to the CTSn pin of receiver
	output reg [7:0] odata,
	output reg oenable,
	input wire oafull);

/*
 * We pass through the almost full signal on the RSTn pin to indicate
 * to the sender to stop sending data. Hopefully it will react fast
 * enough not to cause problems in later FIFOs.
 */

assign rtsn_pin = oafull;

/*
 * We use two registers to avoid metastability problems on the RXD pin.
 */

reg rxd, rxd_pin2; // metastable buffering

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		{rxd, rxd_pin2} <= 2'b11;
	else
		{rxd, rxd_pin2} <= {rxd_pin2, rxd_pin};
end

/*
 * The state is a 4-bit number which is 2 plus the number of read bits
 * including the start and stop bits. Thus the idle state is 12 when
 * we are looking for the start bit. We are going to reset the baud
 * counter when in this idle state. The other important state is 10,
 * when we have the start and 7 data bits in the data register. We
 * have chosen this encoding so that only a few logic inputs are
 * required to check for these states.
 */

reg [3:0] state;
wire baud_reset = state[3] && state[2]; // state is 12
wire baud_tick;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		state <= 4'b1100;
	else if (baud_reset) // in idle state
	begin
		if (rxd)
			state <= 4'b1100; // stay in idle
		else
			state <= 4'b0010; // start working
	end
	else if (baud_tick)
		state <= state + 4'b0001;
end

/*
 * This is the baud rate generator that sets baud_tick to 1 for one clock
 * every BAUD_COUNT many clock cycles. We count downwards and use the highest
 * bit as the baud_tick when underflow occurs. When BAUD_COUNT is 2, then
 * we see that baud_counter needs to be set to 0, so in the next cycle we
 * get the desired underflow. The reset signal is set from later logic
 * when the start of the start bit is detected. The first period is half,
 * to align the data sampling to the middle of the bit streams. Also, this
 * is rounded down bacause of the logic has a single clock delay.
 */

localparam integer BAUD_COUNT_HALF = 0.5 * CLOCK_FREQ / BAUD_RATE - 0.5;
localparam integer BAUD_COUNT_FULL = 1.0 * CLOCK_FREQ / BAUD_RATE;
localparam integer BAUD_WIDTH = $clog2(BAUD_COUNT_FULL - 1);

reg [BAUD_WIDTH:0] baud_counter;
assign baud_tick = baud_counter[BAUD_WIDTH];

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		baud_counter <= BAUD_COUNT_FULL - 2;
	else if (baud_reset)
		baud_counter <= BAUD_COUNT_HALF - 2;
	else if (baud_tick)
		baud_counter <= BAUD_COUNT_FULL - 2;
	else
		baud_counter <= baud_counter - 1'b1;
end

/*
 * We clock in data from the RXD pin to the data shift register at
 * every bound tick. We will have to make sure to strobe the oenable
 * signal when all data is in (and the start bit is out) and the
 * end bit is not yet in.
 */

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		odata <= 8'b00000000;
	else if (baud_tick)
		odata <= {rxd, odata[7:1]};
end

/*
 * The output data becomes valid when state is 10, and baud tick is on,
 * so we are just shifting in the last data bit.
 */

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		oenable <= 1'b0;
	else
		oenable <= state[3] && state[1] && !state[0] && baud_tick;
end
endmodule
