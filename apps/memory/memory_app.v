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
		waddr <= waddr + 10'h001;
end

reg [7:0] wdata;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		wdata <= 8'h00;
	else
		wdata <= wdata + 8'h03;
end

reg [9:0] raddr;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		raddr <= 10'h100;
	else
		raddr <= raddr + 10'h005;
end

reg [1:0] control;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		control <= 2'b0;
	else
		control <= control + 2'b1;
end

wire [7:0] rdata;
true_dual_port_ram_outreg #(.DATA_WIDTH(8), .ADDR_WIDTH(10), .FIRST("WRITE")) ram_inst(
	.clock1(clock),
	.enable1(control[0]),
	.write1(1'b1),
	.addr1(waddr),
	.idata1(wdata),
	.odata1(),
	.clock2(clock),
	.enable2(control[1]),
	.write2(1'b0),
	.addr2(raddr),
	.idata2(8'b0),
	.odata2(rdata));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
	begin
		leds <= ~rdata;
	end
end
endmodule
