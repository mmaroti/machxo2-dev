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

wire [1:0] size1;
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

assign size2 = size1 + ovalid;

initial assume (!resetn);

reg [3:0] count1;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		count1 <= 1'b0;
	else if (ivalid && iready)
		count1 <= count1 + 1'b1;
end

reg [3:0] count2;
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
		assert (count1 == size2 + count2);
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
