/**
 * Copyright (C) 2018, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * Single clock axis fifo with non-registered output where the number of 
 * elements within the fifo is size.
 */
module axis_fifo_ver1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output wire [ADDR_WIDTH-1:0] size,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [DATA_WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

reg [ADDR_WIDTH-1:0] raddr;
reg [ADDR_WIDTH-1:0] waddr;

assign size = waddr - raddr;
assign iready = !(&size);
assign ovalid = (|size);

simple_dual_port_ram_reg0 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram (
	.wclock(clock),
	.wenable(ivalid && iready),
	.waddr(waddr),
	.wdata(idata),
	.raddr(raddr),
	.rdata(odata));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 1'b0;
	else if (ivalid && iready)
		waddr <= waddr + 1'b1;
end

always @(posedge clock)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (ovalid && oready)
		raddr <= raddr + 1'b1;
end

`ifdef FORMAL
	initial assert (!resetn);
`endif
endmodule

/**
 * Single clock axis fifo with non-registered output where the number of 
 * elements within the fifo is size.
 */
module axis_fifo_ver2 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output reg [ADDR_WIDTH-1:0] size,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [DATA_WIDTH-1:0] odata,
	output wire ovalid,
	input wire oready);

assign iready = !(&size);
assign ovalid = (|size);

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
wire [ADDR_WIDTH-1:0] waddr = raddr + size;

simple_dual_port_ram_reg0 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram (
	.wclock(clock),
	.wenable(ivalid && iready),
	.waddr(waddr),
	.wdata(idata),
	.raddr(raddr),
	.rdata(odata));

always @(posedge clock)
begin
	if (ovalid && oready)
		raddr <= raddr + 1'b1;
end

`ifdef FORMAL
	initial assert (!resetn);
`endif
endmodule

/**
 * Single clock axis fifo with registered output where the number of 
 * elements within the fifo is size + ovalid.
 */
module axis_fifo_ver3 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output wire [ADDR_WIDTH-1:0] size,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [DATA_WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

reg [ADDR_WIDTH-1:0] raddr;
reg [ADDR_WIDTH-1:0] waddr;

assign size = waddr - raddr;
assign iready = !(&size);

wire wenable = ivalid && iready;
wire renable = (|size) && (!ovalid || oready);

simple_dual_port_ram_reg1 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram (
	.wclock(clock),
	.wenable(wenable),
	.waddr(waddr),
	.wdata(idata),
	.rclock(clock),
	.renable(renable),
	.raddr(raddr),
	.rdata(odata));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 1'b0;
	else if (wenable)
		waddr <= waddr + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (renable)
		raddr <= raddr + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		ovalid <= 1'b0;
	else
		ovalid <= (|size) || (ovalid && !oready);
end

`ifdef FORMAL
	initial assert (!resetn);

	always @(posedge clock)
	begin
		if (resetn)
			assert (size <= 1 || ovalid);
	end
`endif
endmodule

/**
 * Single clock axis fifo with registered output where the number of 
 * elements within the fifo is size + ovalid.
 */
module axis_fifo_ver4 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire resetn,
	output reg [ADDR_WIDTH-1:0] size,
	input wire [DATA_WIDTH-1:0] idata,
	input wire ivalid,
	output wire iready,
	output wire [DATA_WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

reg [ADDR_WIDTH-1:0] raddr;
wire [ADDR_WIDTH-1:0] waddr = raddr + size;

wire renable = (|size) && (!ovalid || oready);

simple_dual_port_ram_reg1 #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram (
	.wclock(clock),
	.wenable(ivalid && iready),
	.waddr(waddr),
	.wdata(idata),
	.rclock(clock),
	.renable(renable),
	.raddr(raddr),
	.rdata(odata));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		size <= 1'b0;
	else if ((ivalid && iready) && !(renable))
		size <= size + 1'b1;
	else if (!(ivalid && iready) && renable)
		size <= size - 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (renable)
		raddr <= raddr + 1'b1;
end

assign iready = !(&size);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		ovalid <= 1'b0;
	else
		ovalid <= (|size) || (ovalid && !oready);
end

`ifdef FORMAL
	initial assert (!resetn);

	always @(posedge clock)
	begin
		if (resetn)
			assert (size <= 1 || ovalid);
	end
`endif
endmodule
