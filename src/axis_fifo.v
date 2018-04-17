/**
 * Copyright (C) 2018, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module axis_fifo_v0 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output reg [ADDR_WIDTH-1:0] size;
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [DATA_WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		size <= 1'b0;
	else if ((ivalid && iready) && !(ovalid && oready))
		size <= size + 1'b1;
	else if (!(ivalid && iready) && (ovalid && oready))
		size <= size - 1'b1;
end

reg [ADDR_WIDTH-1:0] raddr;
wire [ADDR_WIDTH-1:0] waddr = raddr - size;

simple_dual_port_ram_reg0 #(
	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH))
memory (
	.wclock(clock),
	.wenable(ivalid && iready),
	.waddr(waddr),
	.wdata(idata),
	.raddr(raddr),
	.rdata(odata));

assign iready = !(&size);
assign ovalid = (|size);

always @(posedge clock)
begin
	if (ovalid && oready)
		raddr <= raddr + 1'b1;
end
endmodule

module axis_fifo_v1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output wire [ADDR_WIDTH-1:0] size;
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output wire [DATA_WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

reg [ADDR_WIDTH-1:0] waddr;
reg [ADDR_WIDTH-1:0] raddr;
assign size = waddr - raddr;

simple_dual_port_ram_reg1 #(
	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH))
memory (
	.wclock(clock),
	.wenable(ivalid && iready),
	.waddr(waddr),
	.wdata(idata),
	.rclock(clock),
	.renable(ovalid && oready),
	.raddr(raddr),
	.rdata(odata));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 1'b0;
	else if (ivalid && iready)
		waddr <= waddr + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (ovalid && oready)
		raddr <= raddr + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		iready <= 1'b0;
	else
		iready <= !(&size);
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		ovalid <= 1'b0;
	else
		ovalid <= (|size) || (ovalid && !oready);
end
endmodule

module axis_fifo_v2 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output reg [ADDR_WIDTH-1:0] size;
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output wire [DATA_WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

reg [ADDR_WIDTH-1:0] raddr;
wire [ADDR_WIDTH-1:0] waddr = raddr - size;

simple_dual_port_ram_reg1 #(
	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH))
memory (
	.wclock(clock),
	.wenable(ivalid && iready),
	.waddr(waddr),
	.wdata(idata),
	.rclock(clock),
	.renable(ovalid && oready),
	.raddr(raddr),
	.rdata(odata));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		size <= 1'b0;
	else if ((ivalid && iready) && !(ovalid && oready))
		size <= size + 1'b1;
	else if (!(ivalid && iready) && (ovalid && oready))
		size <= size - 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (ovalid && oready)
		raddr <= raddr + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		iready <= 1'b0;
	else
		iready <= !(&size);
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		ovalid <= 1'b0;
	else
		ovalid <= (|size) || (ovalid && !oready);
end
endmodule
