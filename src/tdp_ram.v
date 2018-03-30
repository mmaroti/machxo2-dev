/**
 * Copyright (C) 2018, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

/**
 * This ram will be inferred as a DP8KC with read before write and 
 * non-registered output (odata appears one clock cycle after enable).
 */
module true_dual_port_ram_readfirst_reg1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] addr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output reg [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] addr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output reg [DATA_WIDTH-1:0] odata2);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

always @(posedge clock1)
begin
	if (enable1)
	begin
		odata1 <= memory[addr1];
		if (write1)
			memory[addr1] <= idata1;
	end
end

always @(posedge clock2)
begin
	if (enable2)
	begin
		odata2 <= memory[addr2];
		if (write2)
			memory[addr2] <= idata2;
	end
end
endmodule

/**
 * This ram will be inferred as a DP8KC with read before write and 
 * registered output (odata appears two clock cycles after enable).
 */
module true_dual_port_ram_readfirst_reg2 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] addr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output reg [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] addr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output reg [DATA_WIDTH-1:0] odata2);

reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

reg [DATA_WIDTH-1:0] odata1_reg;
always @(posedge clock1)
begin
	if (enable1)
	begin
		odata1_reg <= memory[addr1];
		if (write1)
			memory[addr1] <= idata1;
	end
	odata1 <= odata1_reg;
end

reg [DATA_WIDTH-1:0] odata2_reg;
always @(posedge clock2)
begin
	if (enable2)
	begin
		odata2_reg <= memory[addr2];
		if (write2)
			memory[addr2] <= idata2;
	end
	odata2 <= odata2_reg;
end
endmodule

/**
 * This ram will be inferred as a DP8KC with write before read and 
 * non-registered output (odata appears one clock cycles after enable).
 */
module true_dual_port_ram_writefirst_reg1 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] addr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output reg [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] addr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output reg [DATA_WIDTH-1:0] odata2);

reg [DATA_WIDTH-1:0] memory[(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

always @(posedge clock1)
begin
	if (enable1)
	begin
		odata1 <= memory[addr1];
		if (write1)
		begin
			memory[addr1] <= idata1;
			odata1 <= idata1;
		end
	end
end

always @(posedge clock2)
begin
	if (enable2)
	begin
		odata2 <= memory[addr2];
		if (write2)
		begin
			memory[addr2] <= idata2;
			odata2 <= idata2;
		end
	end
end
endmodule

/**
 * This ram will be inferred as a DP8KC with write before read and 
 * registered output (odata appears two clock cycles after enable).
 */
module true_dual_port_ram_writefirst_reg2 #(parameter integer DATA_WIDTH = 8, ADDR_WIDTH = 10) (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] addr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output reg [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] addr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output reg [DATA_WIDTH-1:0] odata2);

reg [DATA_WIDTH-1:0] memory[(1<<ADDR_WIDTH)-1:0] /* synthesis syn_ramstyle="no_rw_check" */;

reg [DATA_WIDTH-1:0] odata1_reg;
always @(posedge clock1)
begin
	if (enable1)
	begin
		odata1_reg <= memory[addr1];
		if (write1)
		begin
			memory[addr1] <= idata1;
			odata1_reg <= idata1;
		end
	end
	odata1 <= odata1_reg;
end

reg [DATA_WIDTH-1:0] odata2_reg;
always @(posedge clock2)
begin
	if (enable2)
	begin
		odata2_reg <= memory[addr2];
		if (write2)
		begin
			memory[addr2] <= idata2;
			odata2_reg <= idata2;
		end
	end
	odata2 <= odata2_reg;
end
endmodule
