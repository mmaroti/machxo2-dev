/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module axis_fifo_tb (
	input wire clock,
	input wire resetn,
	output wire [2:0] size2,
	input wire [7:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [7:0] odata,
	output wire ovalid,
	input wire oready);

wire [3:0] count1;
wire [7:0] sdata1;

axis_bus axis_bus_inst1 (
	.clock(clock),
	.resetn(resetn),
	.data(idata),
	.valid(ivalid),
	.ready(iready),
	.count(count1),
	.sdata(sdata1),
	.saved());

`ifdef VER1
	wire [1:0] size1;
	assign size2 = size1 + ovalid;

	axis_fifo_ver1 #(.ADDR_WIDTH(2)) axis_fifo_inst (
		.clock(clock),
		.resetn(resetn),
		.size(size1),
		.idata(idata),
		.ivalid(ivalid),
		.iready(iready),
		.odata(odata),
		.ovalid(ovalid),
		.oready(oready));
`else
	axis_fifo_ver0 #(.ADDR_WIDTH(2)) axis_fifo_inst (
		.clock(clock),
		.resetn(resetn),
		.size(size2),
		.idata(idata),
		.ivalid(ivalid),
		.iready(iready),
		.odata(odata),
		.ovalid(ovalid),
		.oready(oready));
`endif

wire [3:0] count2;
wire [7:0] sdata2;
wire saved2;

axis_bus axis_bus_inst2 (
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
		assert (count1 == size2 + count2);

		// just to make induction proof work
		restrict (ivalid || $past(ivalid));
		restrict (oready || $past(oready));

		if (saved2)
			assert(sdata1 == sdata2);
	end
end
endmodule
