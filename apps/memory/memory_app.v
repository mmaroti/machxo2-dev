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

reg [9:0] addr1;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		addr1 <= 10'h000;
	else
		addr1 <= addr1 + 10'h001;
end

reg [9:0] addr2;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		addr2 <= 10'h000;
	else
		addr2 <= addr2 + 10'h003;
end

reg [7:0] idata1;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		idata1 <= 8'h00;
	else
		idata1 <= idata1 + 8'h05;
end

reg [7:0] idata2;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		idata2 <= 8'h00;
	else
		idata2 <= idata1 + 8'h07;
end

reg [3:0] control;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		control <= 4'b0;
	else
		control <= control + 4'b1;
end

wire [7:0] odata1;
wire [7:0] odata2;
true_dual_port_ram_writefirst_reg1 #(.DATA_WIDTH(8), .ADDR_WIDTH(10)) ram_inst(
	.clock1(clock),
	.enable1(control[0]),
	.write1(control[1]),
	.addr1(addr1),
	.idata1(idata1),
	.odata1(odata1),
	.clock2(clock),
	.enable2(control[2]),
	.write2(control[3]),
	.addr2(addr2),
	.idata2(idata2),
	.odata2(odata2));

reg [7:0] odata ;
always @(posedge clock)
begin
	odata <= odata1 + odata2;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
	begin
		leds <= ~odata;
	end
end
endmodule
