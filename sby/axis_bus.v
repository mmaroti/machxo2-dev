/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * This module monitors an AXI stream and counts the number of
 * data items that have passed through the stream. It also 
 * saves every data that it has passed when count is 0 modulo
 * its size.
 */
module axis_bus #(parameter integer DATA_WIDTH = 8, COUNT_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	input wire [DATA_WIDTH-1:0] data,
	input wire valid,
	input wire ready,
	output reg [COUNT_WIDTH-1:0] count,
	output reg [DATA_WIDTH-1:0] sdata,
	output reg saved);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		count <= 1'b0;
	else if (valid && ready)
		count <= count + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		sdata <= 1'bx;
		saved <= 1'b0;
	end
	else if (count == 0 && valid && ready)
	begin
		sdata <= data;
		saved <= 1'b1;
	end
	else
		saved <= 1'b0;
end

`ifdef FORMAL
	initial assert (!resetn);
`endif
endmodule
