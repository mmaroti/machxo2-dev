/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module top(
	output reg [7:0] leds,
	input wire resetn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) osch_inst(
	.STDBY(1'b0),
	.OSC(clock),
	.SEDSTDBY());

wire resetn;
button resetn_inst(
	.clock(clock),
	.signal(resetn),
	.signal_pin(resetn_pin));

reg [9:0] waddr;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		waddr <= 10'h000;
	else
		waddr <= waddr + 1'b1;
end

reg [9:0] raddr;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 10'h100;
	else
		raddr <= raddr + 1'b1;
end

wire [7:0] rdata;
/*
inferred_ram6 #(.DATA_WIDTH(8), .ADDR_WIDTH(10)) ram(
	.wclock(clock),
	.wenable(1'b1),
	.waddr(waddr),
	.wdata(waddr[7:0]),
	.rclock(clock),
	.renable(1'b1),
	.raddr(raddr),
	.rdata(rdata));
*/

/*
ram_dp_true __ (.DataInA(waddr[7:0]), .DataInB( ), .AddressA(waddr), .AddressB(raddr), 
    .ClockA(wclock), .ClockB(rclock), .ClockEnA(1'b1), .ClockEnB(1'b1), .WrA(1'b1), .WrB(1'b0), 
    .ResetA(1'b0), .ResetB(1'b0), .QA(), .QB(rdata));
*/

inferred_ram7 #(.DATA_WIDTH(8), .ADDR_WIDTH(10)) ram(
	.clock1(clock),
	.enable1(1'b1),
	.write1(1'b1),
	.iaddr1(waddr),
	.idata1(waddr[7:0]),
	.odata1(),
	.clock2(clock),
	.enable2(1'b1),
	.write2(1'b0),
	.iaddr2(raddr),
	.idata2(8'b0),
	.odata2(rdata));

reg [7:0] rdata2;
always @(posedge clock)
begin
	rdata2 <= rdata;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
		leds <= ~rdata2;
end

endmodule
