/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * This is a simple registered dual port ram module. You might have to use
 * certain combinations of WIDTH and SIZE_LOG2 for the synthetizer to infer
 * the right version of block ram module. The rdata is one clock cycle
 * delayed with respect to the raddr.
 */
module dual_port_ram #(parameter WIDTH = 8, SIZE_LOG2 = 8) (
	input wire wclock,
	input wire [SIZE_LOG2-1:0] waddr,
	input wire [WIDTH-1:0] wdata,
	input wire wenable,
	input wire rclock,
	input wire [SIZE_LOG2-1:0] raddr,
	output reg [WIDTH-1:0] rdata);

reg [WIDTH-1:0] memory [(1<<SIZE_LOG2)-1:0];

always @(posedge wclock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

always @(posedge rclock)
begin
	rdata <= memory[raddr];
end
endmodule

module push_to_axis #(parameter WIDTH = 8, SIZE_LOG2 = 16) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [WIDTH-1:0] idata,
	input wire ienable,
	output wire iafull,
	output wire [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

reg [SIZE_LOG2-1:0] waddr;
reg [SIZE_LOG2-1:0] raddr;

dual_port_ram #(.WIDTH(WIDTH), .SIZE_LOG2(SIZE_LOG2)) ram(
	.wclock(clock),
	.waddr(waddr),
	.wdata(idata),
	.wenable(ienable),
	.rclock(clock),
	.raddr(raddr),
	.rdata(odata));

wire [SIZE_LOG2-1:0] waddr_next = waddr + 1'b1;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 1'b0;
	else if (ienable)
		waddr <= waddr_next;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (ovalid && oready)
		raddr <= raddr + 1'b1;
end

endmodule
