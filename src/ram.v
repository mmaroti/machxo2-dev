/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * Inferred as read before write with non-registered output.
 */
module pseudo_ram_readfirst_nonreg_inferred #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire rclock,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output reg [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

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
 * Inferred as read before write with registered output
 */
module pseudo_ram_readfirst_outreg_inferred #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire rclock,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output reg [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;
reg [DATA_WIDTH-1:0] rdata_reg;

always @(posedge wclock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

always @(posedge rclock)
begin
	if (renable)
		rdata_reg <= memory[raddr];
	rdata <= rdata_reg;
end
endmodule

/**
 * Inferred as write before read with non-registered output
 */
module pseudo_ram_writefirst_nonreg_inferred #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire rclock,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output wire [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;
reg [ADDR_WIDTH-1:0] raddr_reg;
assign rdata = memory[raddr];

always @(posedge wclock)
begin
	if (wenable)
		memory[waddr] <= wdata;
	if (renable)
		raddr_reg <= raddr;
end
endmodule

/**
 * Inferred as write before read with registered output
 */
module ram_writefirst_outreg_inferred #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire [DATA_WIDTH-1:0] idata1,
	input wire [DATA_WIDTH-1:0] idata2,
	input wire [ADDR_WIDTH-1:0] iaddr1,
	input wire [ADDR_WIDTH-1:0] iaddr2,
	input wire clock1,
	input wire clock2,
	input wire enable1,
	input wire enable2,
	input wire write1,
	input wire write2,
	output wire [DATA_WIDTH-1:0] odata1,
	output wire [DATA_WIDTH-1:0] odata2);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;
reg [ADDR_WIDTH-1:0] iaddr1_reg;
reg [ADDR_WIDTH-1:0] iaddr2_reg;
reg [ADDR_WIDTH-1:0] iaddr1_reg2;
reg [ADDR_WIDTH-1:0] iaddr2_reg2;

assign odata1 = memory[iaddr1_reg2];
assign odata2 = memory[iaddr2_reg2];

always @(posedge clock1)
begin
	if (enable1)
	begin
		if (write1)
			memory[iaddr1] <= idata1;
		iaddr1_reg <= iaddr1;
	end
	iaddr1_reg2 <= iaddr1_reg;
end

always @(posedge clock2)
begin
	if (enable2)
	begin
		if (write2)
			memory[iaddr2] <= idata2;
		iaddr2_reg <= iaddr2;
	end
	iaddr2_reg2 <= iaddr2_reg;
end
endmodule
