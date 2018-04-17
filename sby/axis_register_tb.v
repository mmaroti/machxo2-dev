/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

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

initial assume (!resetn);

reg [2:0] count1;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		count1 <= 1'b0;
	else if (ivalid && iready)
		count1 <= count1 + 1'b1;
end

reg [2:0] count2;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		count2 <= 1'b0;
	else if (ovalid && oready)
		count2 <= count2 + 1'b1;
end

always @(posedge clock)
begin
	if (resetn)
		assert (count1 == size + count2);
end

reg [7:0] data1;

always @(posedge clock)
begin
	if (resetn)
	begin
		// just to make induction proof work
		restrict (ivalid || $past(ivalid));
		restrict (oready || $past(oready));

		if (count1 == 4 && ivalid && iready)
			data1 <= idata;

		if (count2 == 4 && ovalid && oready)
			assert(data1 == odata);
	end
end
endmodule
