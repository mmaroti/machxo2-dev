module top(
	output reg [7:0] leds,
	input wire rs232_txd,
	output wire rs232_rxd,
	input wire rs232_rtsn,
	output wire rs232_ctsn,
	input wire resetn_pio);

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(
	.STDBY(1'b0), 
	.OSC(clock), 
	.SEDSTDBY());

wire resetn;
resetn_gen resetn_gen(
	.clock(clock), 
	.resetn(resetn), 
	.resetn_pio(resetn_pio));

reg txd_bit_data, txd_bit_valid;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		txd_bit_data <= 1'b1;
		txd_bit_valid <= 1'b0;
	end
	else 
	begin
		txd_bit_data <= rs232_txd;
		txd_bit_valid <= txd_bit_valid || !rs232_txd;
	end
end

reg [7:0] txd_byte_data;
reg [2:0] txd_byte_addr;
wire txd_byte_valid = txd_bit_valid && txd_byte_addr == 3'b0;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		txd_byte_data <= 8'b11111111;
		txd_byte_addr <= 3'b000;
	end
	else if (txd_bit_valid)
	begin
		txd_byte_data[6:0] <= txd_byte_data[7:1];
		txd_byte_data[7] <= txd_bit_data;
		txd_byte_addr <= txd_byte_addr + 1'b1;
	end
end

wire fifo_full, fifo_empty, fifo_rden, fifo;
wire [7:0] fifo_q;

fifo_dc fifo(
	.Data(txd_byte_data),
	.WrEn(txd_byte_valid),
	.RdEn(fifo_rden),
	.Q(fifo_q),
	.WrClock(clock),
	.RdClock(clock),
	.Reset(~resetn),
	.RPReset(1'b0),
	.Full(fifo_full),
	.Empty(fifo_empty),
	.AlmostEmpty(),
	.AlmostFull());

always @(posedge clock)
begin
	leds[0] <= ~rs232_txd;
	leds[1] <= ~txd_bit_valid;
	leds[2] <= ~txd_byte_valid;
	leds[3] <= ~fifo_empty;
	leds[4] <= ~fifo_full;
	leds[5] <= ~fifo_rden;
	leds[6] <= ~rs232_rtsn;
	leds[7] <= ~rs232_rxd;
end

wire ready;
rs232_send3 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) rs232_send3(
	.clock(clock),
	.resetn(resetn),
	.rs232_rxd(rs232_rxd),
	.rs232_rtsn(rs232_rtsn),
	.data(fifo_q),
	.valid(~fifo_empty),
	.ready(fifo_rden));

endmodule
