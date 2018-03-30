/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module true_dual_port_ram_nonreg #(
	parameter integer DATA_WIDTH = 8,
	parameter integer ADDR_WIDTH = 10,
	parameter FIRST="WRITE") (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] addr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output wire [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] addr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output wire [DATA_WIDTH-1:0] odata2);

if (DATA_WIDTH == 9 && ADDR_WIDTH == 10 && FIRST == "READ")
begin
	ram_readfirst_nonreg_9x1024 impl(
		.DataInA(idata1),
		.DataInB(idata2),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA(odata1),
		.QB(odata2));
end
else if (DATA_WIDTH == 8 && ADDR_WIDTH == 10 && FIRST == "READ")
begin
	wire odata1x, odata2x;
	ram_readfirst_nonreg_9x1024 impl(
		.DataInA({1'b0,idata1}),
		.DataInB({1'b0,idata2}),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA({odata1x,odata1}),
		.QB({odata2x,odata2}));
end
else if (DATA_WIDTH == 9 && ADDR_WIDTH == 10 && FIRST == "WRITE")
begin
	ram_writefirst_nonreg_9x1024 impl(
		.DataInA(idata1),
		.DataInB(idata2),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA(odata1),
		.QB(odata2));
end
else if (DATA_WIDTH == 8 && ADDR_WIDTH == 10 && FIRST == "WRITE")
begin
	wire odata1x, odata2x;
	ram_writefirst_nonreg_9x1024 impl(
		.DataInA({1'b0,idata1}),
		.DataInB({1'b0,idata2}),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA({odata1x,odata1}),
		.QB({odata2x,odata2}));
end
endmodule

module true_dual_port_ram_outreg #(
	parameter integer DATA_WIDTH = 8,
	parameter integer ADDR_WIDTH = 10,
	parameter FIRST="WRITE") (
	input wire clock1,
	input wire enable1,
	input wire write1,
	input wire [ADDR_WIDTH-1:0] addr1,
	input wire [DATA_WIDTH-1:0] idata1,
	output wire [DATA_WIDTH-1:0] odata1,
	input wire clock2,
	input wire enable2,
	input wire write2,
	input wire [ADDR_WIDTH-1:0] addr2,
	input wire [DATA_WIDTH-1:0] idata2,
	output wire [DATA_WIDTH-1:0] odata2);

if (DATA_WIDTH == 9 && ADDR_WIDTH == 10 && FIRST == "READ")
begin
	ram_readfirst_outreg_9x1024 impl(
		.DataInA(idata1),
		.DataInB(idata2),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA(odata1),
		.QB(odata2));
end
else if (DATA_WIDTH == 8 && ADDR_WIDTH == 10 && FIRST == "READ")
begin
	wire odata1x, odata2x;
	ram_readfirst_outreg_9x1024 impl(
		.DataInA({1'b0,idata1}),
		.DataInB({1'b0,idata2}),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA({odata1x,odata1}),
		.QB({odata2x,odata2}));
end
else if (DATA_WIDTH == 9 && ADDR_WIDTH == 10 && FIRST == "WRITE")
begin
	ram_writefirst_outreg_9x1024 impl(
		.DataInA(idata1),
		.DataInB(idata2),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA(odata1),
		.QB(odata2));
end
else if (DATA_WIDTH == 8 && ADDR_WIDTH == 10 && FIRST == "WRITE")
begin
	wire odata1x, odata2x;
	ram_writefirst_outreg_9x1024 impl(
		.DataInA({1'b0,idata1}),
		.DataInB({1'b0,idata2}),
		.AddressA(addr1), 
		.AddressB(addr2),
		.ClockA(clock1),
		.ClockB(clock2),
		.ClockEnA(enable1),
		.ClockEnB(enable2), 
		.WrA(write1),
		.WrB(write2),
		.ResetA(1'b0),
		.ResetB(1'b0),
		.QA({odata1x,odata1}),
		.QB({odata2x,odata2}));
end
endmodule
