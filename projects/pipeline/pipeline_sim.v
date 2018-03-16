/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`timescale 1ns/100ps

module test();

reg clock, resetn;

wire [7:0] data1;
wire valid1, ready1;
reg enabled;

axis_counter counter(
	.clock(clock), 
	.resetn(resetn), 
	.odata(data1), 
	.ovalid(valid1), 
	.oready(ready1 && enabled));

wire [7:0] data2;
wire valid2;
reg ready2;
wire [2:0] size;

axis_fifo #(.SIZE(7)) fifo(
	.clock(clock), 
	.resetn(resetn),
	.size(size),
	.idata(data1),
	.ivalid(valid1 && enabled),
	.iready(ready1),
	.odata(data2),
	.ovalid(valid2),
	.oready(ready2));

initial
begin
	resetn = 1'b0;
	clock = 1'b1;
	ready2 = 1'b0;
	enabled = 1'b1;
	#5
	resetn = 1'b1;
	#20
	ready2 = 1'b1;
	#20
	enabled = 1'b0;
	#20
	$finish;
end

always #1 clock = ~clock;
	
endmodule
