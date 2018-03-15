/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * Debounces an input pin and produces a stable signal by ensuring that
 * the new state is held for a specified time. The DELAY parameter is
 * the log2 of the number of clock ticks before a change is registered.
 */
module button #(parameter DELAY = 2) (
	input wire clock,
	input wire resetn_pin,
	output reg resetn);

reg resetn_pin2 = 1'b1;

// use extra register to avoid metastability
always @(posedge clock)
begin
	resetn_pin2 <= resetn_pin;
end

reg [DELAY-1:0] counter = 0;

always @(posedge clock)
begin
	if (resetn_pin2 == resetn)
		counter <= 1'b0;
	else
		{resetn, counter} <= {resetn, counter} + 1'b1;
end
endmodule
