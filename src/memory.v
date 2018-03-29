/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * Inferred as read before write with internal registered output
 */
module inferred_dp_ram1 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
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
 * Inferred as write through with non-registered output
 */
module inferred_dp_ram2 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire rclock,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output wire [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

always @(posedge wclock)
begin
	if (wenable)
		memory[waddr] <= wdata;
end

reg [ADDR_WIDTH-1:0] raddr_reg;
assign rdata = memory[raddr_reg];

always @(posedge rclock)
begin
	if (renable)
		raddr_reg <= raddr;
end
endmodule

/**
 * Inferred as write through with external registered output
 */
module inferred_dp_ram3 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
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

reg [ADDR_WIDTH-1:0] raddr_reg;

always @(posedge rclock)
begin
	if (renable)
		raddr_reg <= raddr;
end

always @(posedge rclock)
begin
	rdata <= memory[raddr_reg];
end
endmodule

/**
 * Inferred as write through with external registered raddr and non-registered output
 */
module inferred_dp_ram4 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
	input wire wclock,
	input wire wenable,
	input wire [ADDR_WIDTH-1:0] waddr,
	input wire [DATA_WIDTH-1:0] wdata,
	input wire rclock,
	input wire renable,
	input wire [ADDR_WIDTH-1:0] raddr,
	output wire [DATA_WIDTH-1:0] rdata);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

reg wenable_reg;
reg [ADDR_WIDTH-1:0] waddr_reg;
reg [DATA_WIDTH-1:0] wdata_reg;
always @(posedge wclock)
begin
	if (wenable_reg)
		memory[waddr_reg] <= wdata_reg;
	waddr_reg <= waddr;
	wdata_reg <= wdata;
	wenable_reg <= wenable;
end

reg [ADDR_WIDTH-1:0] raddr_reg;
assign rdata = memory[raddr_reg];

always @(posedge rclock)
begin
	if (renable)
		raddr_reg <= raddr;
end
endmodule

/**
 * Inferred as read before write with internal output regsiters
 */
module inferred_dp_ram5 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
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

reg [DATA_WIDTH-1:0] rdata_reg;

always @(posedge rclock)
begin
	if (renable)
		rdata_reg <= memory[raddr];
end

always @(posedge rclock)
begin
	rdata <= rdata_reg;
end
endmodule

/**
 * Inferred as read before write with internal output regsiters
 */
module inferred_dp_ram6 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
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

reg [ADDR_WIDTH-1:0] raddr_reg;

always @(posedge rclock)
begin
	if (renable)
		raddr_reg <= raddr;
end

reg [DATA_WIDTH-1:0] rdata_reg;

always @(*)
begin
	rdata_reg <= memory[raddr_reg];
end

always @(posedge rclock)
begin
	rdata <= rdata_reg;
end
endmodule

module inferred_true_dp_ram7 #(parameter DATA_WIDTH = 10, ADDR_WIDTH = 8) (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] iaddr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output reg [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] iaddr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output reg [DATA_WIDTH-1:0] odata2);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

always @(posedge clock1)
begin
	if (enable1)
	begin
		if (write1)
			memory[iaddr1] <= idata1;
		odata1 <= memory[iaddr1];
	end
end

always @(posedge clock2)
begin
	if (enable2)
	begin
		if (write2)
			memory[iaddr2] <= idata2;
		odata2 <= memory[iaddr2];
	end
end
endmodule
