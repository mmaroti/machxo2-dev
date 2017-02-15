// Copyright (C) 2017, Miklos Maroti

`timescale 1ns/1ps
module sim();

wire [7:0] leds;
top top(.leds(leds));

initial
begin
	#100	// wait 100 nanoseconds, one clock tick is about 1/133000000 = 7518 ps
	$finish;
end

endmodule
