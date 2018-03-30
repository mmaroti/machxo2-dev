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
	output reg [DATA_WIDTH-1:0] rdata)
	/* synthesis syn_hier = "hard" */;

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
