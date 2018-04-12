/**
 * Copyright (C) 2018, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * This ram is inferred as distributed pseudo dual port ram with 
 * non-registered output.
 */
module simple_dual_port_ram_reg0 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire [ADDR_WIDTH-1:0] raddr,
	output wire [DATA_WIDTH-1:0] rdata)
	/* synthesis syn_hier = "hard" */;

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0]
	/* synthesis syn_ramstyle="distributed,no_rw_check" */;

always @(posedge wclock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

assign rdata = memory[raddr];
endmodule

/**
 * This ram is inferred as distributed pseudo dual port ram with registered
 * output.
 */
module simple_dual_port_ram_reg1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire rclock,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output reg [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] 
	/* synthesis syn_ramstyle="distributed,no_rw_check" */;

always @(posedge wclock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

always @(posedge rclock)
begin
	if (renable)
		rdata <= memory[raddr];
end
endmodule

/**
 * Converts a push interface (with clock enable) to an axi stream interface
 * with overflow error detection. The overflow flag is set on overflow, and
 * it is cleared only at reset.
 */
module push_to_axis2 #(parameter integer WIDTH = 8, SIZE_LOG2 = 3, AFULL_LIMIT = 1 << (SIZE_LOG2-1)) (
	input wire clock,
	input wire resetn,
	output reg overflow,
	input wire [WIDTH-1:0] idata,
	input wire ienable,
	output reg iafull,
	output wire [WIDTH-1:0] odata,
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
reg [SIZE_LOG2-1:0] waddr;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 1'b0;
	else if (wenable)
		waddr <= waddr + 1'b1;
end

wire renable;
reg [SIZE_LOG2-1:0] raddr;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 1'b0;
	else if (renable)
		raddr <= raddr + 1'b1;
end

simple_dual_port_ram_reg1 #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(SIZE_LOG2)) memory(
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

wire [SIZE_LOG2-1:0] size = waddr - raddr;
assign renable = (!ovalid && size != 1'b0) || (ovalid && oready);

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
		overflow <= overflow || (&size && wenable && !renable);
end
endmodule
