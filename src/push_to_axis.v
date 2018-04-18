/**
 * Copyright (C) 2018, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

`default_nettype none

/**
 * Converts a push interface (with clock enable) to an axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis_ver1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4, AFULL_LIMIT = 1 << (ADDR_WIDTH - 1)) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ienable,
	output wire iafull,
	output wire [DATA_WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

wire [ADDR_WIDTH-1:0] size;
wire iready;

axis_fifo_ver1 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo (
	.clock(clock),
	.resetn(resetn),
	.size(size),
	.idata(idata),
	.ivalid(ienable),
	.iready(iready),
	.odata(odata),
	.ovalid(ovalid),
	.oready(oready));

assign iafull = (size >= AFULL_LIMIT);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		overflow <= 1'b0;
	else if (ienable && !iready)
		overflow <= 1'b1;
end
endmodule

/**
 * Converts a push interface (with clock enable) to an axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis_ver2 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4, AFULL_LIMIT = 1 << (ADDR_WIDTH - 1)) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ienable,
	output wire iafull,
	output wire [DATA_WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

wire [ADDR_WIDTH-1:0] size;
wire iready;

axis_fifo_ver2 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo (
	.clock(clock),
	.resetn(resetn),
	.size(size),
	.idata(idata),
	.ivalid(ienable),
	.iready(iready),
	.odata(odata),
	.ovalid(ovalid),
	.oready(oready));

assign iafull = (size >= AFULL_LIMIT);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		overflow <= 1'b0;
	else if (ienable && !iready)
		overflow <= 1'b1;
end
endmodule

/**
 * Converts a push interface (with clock enable) to an axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis_ver3 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4, AFULL_LIMIT = 1 << (ADDR_WIDTH - 1)) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ienable,
	output wire iafull,
	output wire [DATA_WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

wire [ADDR_WIDTH-1:0] size;
wire iready;

axis_fifo_ver3 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo (
	.clock(clock),
	.resetn(resetn),
	.size(size),
	.idata(idata),
	.ivalid(ienable),
	.iready(iready),
	.odata(odata),
	.ovalid(ovalid),
	.oready(oready));

assign iafull = (size >= AFULL_LIMIT);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		overflow <= 1'b0;
	else if (ienable && !iready)
		overflow <= 1'b1;
end
endmodule

/**
 * Converts a push interface (with clock enable) to an axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis_ver4 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4, AFULL_LIMIT = 1 << (ADDR_WIDTH - 1)) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ienable,
	output wire iafull,
	output wire [DATA_WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

wire [ADDR_WIDTH-1:0] size;
wire iready;

axis_fifo_ver4 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo (
	.clock(clock),
	.resetn(resetn),
	.size(size),
	.idata(idata),
	.ivalid(ienable),
	.iready(iready),
	.odata(odata),
	.ovalid(ovalid),
	.oready(oready));

assign iafull = (size >= AFULL_LIMIT);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		overflow <= 1'b0;
	else if (ienable && !iready)
		overflow <= 1'b1;
end
endmodule

/**
 * Converts a push interface (with clock enable) to an axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis_ver5 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4, AFULL_LIMIT = 1 << (ADDR_WIDTH-1)) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ienable,
	output reg iafull,
	output wire [DATA_WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

/*
 * The write address is always pointing to the next data slot to be
 * written to. We write to the fifo when ienable is high, even if
 * this might cause an overflow. The read address is always pointing
 * to the next data to be read, not the currently output data in the
 * register waiting to be accepted. We will calculate renable later.
 */

wire wenable = ienable;
reg [ADDR_WIDTH-1:0] waddr;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 1'b0;
	else if (wenable)
		waddr <= waddr + 1'b1;
end

wire renable;
reg [ADDR_WIDTH-1:0] raddr;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (renable)
		raddr <= raddr + 1'b1;
end

simple_dual_port_ram_reg1 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) memory(
	.wclock(clock),
	.wenable(wenable),
	.waddr(waddr),
	.wdata(idata),
	.rclock(clock),
	.renable(renable),
	.raddr(raddr),
	.rdata(odata));

/*
 * Size is the number of elements in the fifo NOT counting the element in the
 * output register. We enable the read when the output register is empty and
 * there is data in the fifo, or the output register is full and it is taken.
 */

wire [ADDR_WIDTH-1:0] size = waddr - raddr;
assign renable = (|size) && (!ovalid || oready);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		ovalid <= 1'b0;
	else
		ovalid <= renable || (ovalid && !oready);
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		iafull <= 1'b1;
	else
		iafull <= (size >= AFULL_LIMIT);
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		overflow <= 1'b0;
	else
		overflow <= overflow || ((&size) && wenable && !renable);
end
endmodule
