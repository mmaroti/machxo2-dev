/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`default_nettype none

module axis_register_tb (
	input wire clock,
	input wire resetn,
	output wire [1:0] size,
	input wire [7:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [7:0] odata,
	output wire ovalid,
	input wire oready);

wire [2:0] count1;
wire [7:0] sdata1;

axis_bus #(.COUNT_WIDTH(3)) axis_bus_inst1 (
	.clock(clock),
	.resetn(resetn),
	.data(idata),
	.valid(ivalid),
	.ready(iready),
	.count(count1),
	.sdata(sdata1),
	.saved());

axis_register axis_register_inst (
	.clock(clock),
	.resetn(resetn),
	.size(size),
	.idata(idata),
	.ivalid(ivalid),
	.iready(iready),
	.odata(odata),
	.ovalid(ovalid),
	.oready(oready));

wire [2:0] count2;
wire [7:0] sdata2;
wire saved2;

axis_bus #(.COUNT_WIDTH(3)) axis_bus_inst2 (
	.clock(clock),
	.resetn(resetn),
	.data(odata),
	.valid(ovalid),
	.ready(oready),
	.count(count2),
	.sdata(sdata2),
	.saved(saved2));

initial assume (!resetn);

always @(posedge clock)
begin
	if (resetn)
	begin
		assert (count1 == size + count2);

		if (saved2)
			assert(sdata1 == sdata2);
	end

	if (resetn && $past(resetn))
	begin
		assert (size == $past(size
			+ (ivalid && iready) - (ovalid && oready)));

		// just to make induction proof work
		restrict (ivalid || $past(ivalid));
		restrict (oready || $past(oready));
	end
end
endmodule
