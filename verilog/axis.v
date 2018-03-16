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
module axis_throttle #(parameter integer WIDTH = 8, DELAY = 2, DELAY_WIDTH = $clog2(DELAY-1)) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

reg [DELAY_WIDTH:0] delay;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		delay <= DELAY - 2;
	end
	else if (delay[DELAY_WIDTH])
	begin
		delay <= DELAY - 2;
	end
	else
	begin
		delay <= delay - 1'b1;
	end
end

assign ovalid = ivalid && delay[DELAY_WIDTH];
assign iready = oready && delay[DELAY_WIDTH];
assign odata = idata;
endmodule	

/**
 * Moves data from idata to odata. Data is transferred on the ports
 * when both xvalid and xready are high on the rising edge of the clock.
 * This block can move data on every clock, and all its outputs are
 * registered (including iready). This means, that it will store the
 * accepted input value when both iready and ivalid are true and oready
 * is false. Complicated pipelines can be built with continous logic
 * blocks that are connected with axis pipes.
 */
module axis_pipe #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

reg [WIDTH-1:0] buffer; // bvalid = !iready (&& ovalid)

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		iready <= 1'b1;
		odata <= {WIDTH{1'bx}};
		ovalid <= 1'b0;
		buffer <= {WIDTH{1'bx}};
	end
	else
	begin
		ovalid <= (ovalid && !oready) || !iready || ivalid;
		odata <= (ovalid && !oready) ? odata : (!iready ? buffer : idata);

		iready <= !ovalid || oready || (iready && !ivalid);
		buffer <= (ovalid && !oready && iready && ivalid) ? idata : buffer;
	end
end
endmodule

/**
 * An axis fifo buffer which takes data and produces data through pipe 
 * interfaces. If SIZE is 1, then this module is functionally equivalent 
 * to the axis pipe.
 */
module axis_fifo #(parameter integer WIDTH = 8, SIZE = 3, SIZE_WIDTH = $clog2(SIZE + 1)) (
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

reg [WIDTH-1:0] buffer[1:SIZE-1];
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		for (i = 1; i < SIZE; i = i + 1)
			buffer[i] <= {WIDTH{1'bx}};
	end
	else if (itransfer)
	begin
		buffer[1] <= idata;
		for (i = 2; i < SIZE; i = i + 1)
			buffer[i] <= buffer[i - 1];
	end
end

reg [WIDTH-1:0] buffer2[0:SIZE];
always @(*)
begin
	buffer2[0] = idata;
	for (i = 1; i < SIZE; i = i + 1)
		buffer2[i] = buffer[i];
	buffer2[SIZE] = odata;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		odata <= {WIDTH{1'bx}};
	else
		odata <= buffer2[size2];
end
endmodule
