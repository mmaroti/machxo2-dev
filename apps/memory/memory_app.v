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

ram_writefirst_outreg_inferred #(.DATA_WIDTH(8), .ADDR_WIDTH(10)) ram_inst(
	.idata1(waddr[7:0]),
	.idata2(8'b0),
	.iaddr1(waddr), 
    .iaddr2(raddr),
	.clock1(clock),
	.clock2(clock),
	.enable1(1'b1),
	.enable2(1'b1), 
    .write1(1'b1),
	.write2(1'b0),
	.odata1(),
	.odata2(rdata));

/*
wire rdata9;
ram_writefirst_outreg_9x1024 ram_inst(
	.DataInA({1'b0,waddr[7:0]}),
	.DataInB(9'b0),
	.AddressA(waddr), 
    .AddressB(raddr),
	.ClockA(clock),
	.ClockB(clock),
	.ClockEnA(1'b1),
	.ClockEnB(1'b1), 
    .WrA(1'b1),
	.WrB(1'b0),
	.ResetA(1'b0),
	.ResetB(1'b0),
	.QA(),
	.QB({rdata8,rdata}));
*/

reg [7:0] rdata2;
always @(posedge clock)
begin
	rdata2 <= ~rdata;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
		leds <= rdata2;
end

endmodule
