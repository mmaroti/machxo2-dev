/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * Just a simple counter producing output through an axis interface.
 * The ovalid signal is always true, the couter is incremented when
 * oready is true.
 */
module axis_counter #(parameter integer WIDTH = 8) (
	input wire clock,
	input wire resetn,
	output reg [WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

assign ovalid = 1'b1;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		odata <= 1'b0;
	else if (oready)
		odata <= odata + 1'b1;
end
endmodule

/**
 * This block slows down the flow of elements from the input to the
 * output by moving data at every DELAY clock cycle.
 */
module axis_throttle #(parameter integer WIDTH = 8, DELAY = 2) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

localparam integer DELAY_WIDTH = $clog2(DELAY - 1);
reg [DELAY_WIDTH:0] delay;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		delay <= DELAY - 2;
	else if (delay[DELAY_WIDTH])
		delay <= DELAY - 2;
	else
		delay <= delay - 1'b1;
end

assign ovalid = ivalid && delay[DELAY_WIDTH];
assign iready = oready && delay[DELAY_WIDTH];
assign odata = idata;
endmodule	

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
endmodule

/**
 * An axis fifo buffer which takes data and produces data through pipe
 * interfaces. If SIZE is 2, then this module is functionally equivalent to
 * the axis pipe. The output size is the number of owned elements, which is a
 * number in the range [0, SIZE].
 */
module axis_small_fifo #(parameter integer WIDTH = 8, SIZE = 3, SIZE_WIDTH = $clog2(SIZE + 1)) (
	input wire clock,
	input wire resetn,
	output reg [SIZE_WIDTH-1:0] size,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

integer i;

wire itransfer = ivalid && iready;
wire otransfer = ovalid && oready;

wire [SIZE_WIDTH-1:0] size2 = size - otransfer;
wire [SIZE_WIDTH-1:0] size3 = size2 + itransfer;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		size <= 1'b0;
		iready <= 1'b0;
		ovalid <= 1'b0;
	end
	else
	begin
		size <= size3;
		iready <= size3 < SIZE;
		ovalid <= size3 > 0;
	end
end

reg [WIDTH-1:0] buffer [1:SIZE-1];

always @(posedge clock)
begin
	// no async reset of buffer
	if (itransfer)
	begin
		buffer[1] <= idata;
		for (i = 2; i < SIZE; i = i + 1)
			buffer[i] <= buffer[i - 1];
	end
end

reg [WIDTH-1:0] buffer2 [0:SIZE]; // this will be a wire

always @(*)	// combinatorial
begin
	buffer2[0] <= idata;
	for (i = 1; i < SIZE; i = i + 1)
		buffer2[i] <= buffer[i];
	buffer2[SIZE] <= odata;
end

always @(posedge clock)
begin
	// no async reset of odata
	odata <= buffer2[size2];
end
endmodule

/**
 * Converts a push interface (with clock enable) to a axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis #(parameter integer WIDTH = 8) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [WIDTH-1:0] idata,
	input wire ienable,
	output wire [WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

assign ovalid = ienable;
assign odata = idata;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		overflow <= 1'b0;
	else
		overflow <= (ienable && !oready) || overflow;
end
endmodule
