/**
 * Copyright (C) 2018, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module simple_dual_port_ram_reg0 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire [ADDR_WIDTH-1:0] raddr,
	output wire [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

always @(posedge clock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

assign rdata = memory[raddr];
endmodule

module simple_dual_port_ram_reg1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 4) (
	input wire clock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output reg [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

always @(posedge clock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

always @(posedge clock)
begin
	if (renable)
		rdata <= memory[raddr];
end
endmodule
