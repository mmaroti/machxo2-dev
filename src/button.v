/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`default_nettype none

/**
 * Debounces an input pin and produces a stable signal by ensuring that
 * the new state is held for a specified time. The DELAY parameter is
 * the log2 of the number of clock ticks before a change is registered.
 */
module button #(parameter DELAY = 2) (
	input wire clock,
	input wire signal_pin,
	output reg signal);

// use extra register to avoid metastability
reg signal_pin2 = 1'b1;

always @(posedge clock)
begin
	signal_pin2 <= signal_pin;
end

reg [DELAY-1:0] counter = 0;

always @(posedge clock)
begin
	if (signal_pin2 == signal)
		counter <= 0;
	else
		{signal, counter} <= {signal, counter} + 1'b1;
end
endmodule
