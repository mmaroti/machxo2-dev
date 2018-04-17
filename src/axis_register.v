/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * Moves data from idata to odata. Data is transferred on the ports when both
 * xvalid and xready are high on the rising edge of the clock. This block can
 * move data on every clock, and all its outputs are registered (including
 * iready). This means, that it will store the accepted input value in an
 * internal buffer when both iready and ivalid are true and oready is false.
 * The size output is either 0, 1 or 2. It is 0 if the register is empty so no
 * data is in flight. It is 1 in the steady state when the output is the old
 * input value. It is 2 when the last output was not consumed but the input
 * was accepted into an internal buffer.
 */
module axis_register #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	output wire [1:0] size,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

/*
 * iready && !ovalid: buffer is empty, odata is empty
 * iready && ovalid: buffer is empty, odata is full
 * !iready && ovalid: buffer is full, odata is full
 * !iready && !ovalid: cannot happen
 */

assign size[0] = iready && ovalid;
assign size[1] = !iready;

reg [WIDTH-1:0] buffer;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		// omit async reset on odata and buffer
		ovalid <= 1'b0;
		iready <= 1'b1;
	end
	else
	begin
		odata <= (ovalid && !oready) ? odata : (!iready ? buffer : idata);
		ovalid <= (ovalid && !oready) || !iready || ivalid;
		buffer <= (!iready && !oready) ? buffer : idata;
		iready <= !ovalid || oready || (iready && !ivalid);
	end
end

`ifdef FORMAL
	initial assume (!resetn);

	wire [2:0] count1;
	tick_counter #(.WIDTH(3)) tick_counter_inst1 (
		clock,
		resetn,
		ivalid && iready,
		count1);

	wire [2:0] count2;
	tick_counter #(.WIDTH(3)) tick_counter_inst2 (
		clock,
		resetn,
		ovalid && oready,
		count2);

	reg [WIDTH-1:0] data;

	always @(posedge clock)
	begin
		if (resetn)
		begin
			assert (size <= 2);
			assert (iready == (size < 2));
			assert (ovalid == (size > 0));
			assert (count1 == count2 + size);

			if (count1 == 4 && ivalid && iready)
				data <= idata;

			if (count2 == 4 && ovalid && oready)
				assert(data == odata);
		end
	end
`endif
endmodule
