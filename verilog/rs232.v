/*
This module provides RS232 communication. The clock frequency does not have to be an
integer multiple of the boud rate.
 */

module rs232_send #(parameter integer CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire reset_n,
	output reg rs232_rxd,
	input wire rs232_rts_n,
	input wire [7:0] data,
	input wire valid,
	output reg ready);

	localparam integer
		START = 0,
		BIT_0 = (CLOCK_FREQ + BAUD_RATE / 2) / BAUD_RATE,
		BIT_1 = (CLOCK_FREQ * 2 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_2 = (CLOCK_FREQ * 3 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_3 = (CLOCK_FREQ * 4 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_4 = (CLOCK_FREQ * 5 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_5 = (CLOCK_FREQ * 6 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_6 = (CLOCK_FREQ * 7 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_7 = (CLOCK_FREQ * 8 + BAUD_RATE / 2) / BAUD_RATE,
		STOP = (CLOCK_FREQ * 9 + BAUD_RATE / 2) / BAUD_RATE,
		FINISH = (CLOCK_FREQ * 10 + BAUD_RATE / 2) / BAUD_RATE;

	localparam integer
		TIMER_WIDTH = $clog2(FINISH);

	reg [7:0] buffer;
	reg [TIMER_WIDTH-1:0] timer;
	reg running;

	always @(posedge clock or negedge reset_n)
	begin
		if (!reset_n || !running)
		begin
			timer <= 0;
			rs232_rxd <= 1'b1;
		end
		else
		begin
			if (timer == START)
				rs232_rxd <= 1'b0;
			else if (timer == BIT_0)
				rs232_rxd <= buffer[0];
			else if (timer == BIT_1)
				rs232_rxd <= buffer[1];
			else if (timer == BIT_2)
				rs232_rxd <= buffer[2];
			else if (timer == BIT_3)
				rs232_rxd <= buffer[3];
			else if (timer == BIT_4)
				rs232_rxd <= buffer[4];
			else if (timer == BIT_5)
				rs232_rxd <= buffer[5];
			else if (timer == BIT_6)
				rs232_rxd <= buffer[6];
			else if (timer == BIT_7)
				rs232_rxd <= buffer[7];
			else if (timer == STOP)
				rs232_rxd <= 1'b1;

			timer <= timer + 1'b1;
		end
	end

	always @(posedge clock or negedge reset_n)
	begin
		if (!reset_n)
		begin
			buffer <= 8'bx;
			running <= 1'b0;
			ready <= 1'b0;
		end
		else if (running)
		begin
			if (timer == FINISH-1)
			begin
				buffer <= 8'bx;
				running <= 1'b0;
				ready <= !rs232_rts_n;
			end
		end
		else
		begin
			if (ready && valid)
			begin
				buffer <= data;
				running <= 1'b1;
				ready <= 1'b0;
			end
			else
			begin
				buffer <= 8'bx;
				running <= 1'b0;
				ready <= !rs232_rts_n;
			end
		end
	end

endmodule

module rs232_send3 #(parameter integer CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire reset_n,
	output reg rs232_rxd,
	input wire rs232_rts_n,
	input wire [7:0] data,
	input wire valid,
	output reg ready);

	localparam integer
		START = 0,
		BIT_0 = (CLOCK_FREQ + BAUD_RATE / 2) / BAUD_RATE,
		BIT_1 = (CLOCK_FREQ * 2 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_2 = (CLOCK_FREQ * 3 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_3 = (CLOCK_FREQ * 4 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_4 = (CLOCK_FREQ * 5 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_5 = (CLOCK_FREQ * 6 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_6 = (CLOCK_FREQ * 7 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_7 = (CLOCK_FREQ * 8 + BAUD_RATE / 2) / BAUD_RATE,
		STOP = (CLOCK_FREQ * 9 + BAUD_RATE / 2) / BAUD_RATE,
		FINISH = (CLOCK_FREQ * 10 + BAUD_RATE / 2) / BAUD_RATE;

	localparam integer
		TIMER_WIDTH = $clog2(FINISH);

	reg [7:0] buffer;
	reg [TIMER_WIDTH-1:0] timer;
	reg running;

	always @(posedge clock or negedge reset_n)
	begin
		if (!reset_n || !running)
			timer <= 0;
		else
			timer <= timer + 1;
	end

	always @(posedge clock or negedge reset_n)
	begin
		if (!reset_n)
		begin
			rs232_rxd <= 1'b1;
			buffer = 8'bx;
			running <= 1'b0;
			ready <= 1'b0;
		end
		else if (running)
		begin
			if ((timer == BIT_0)
				|| (timer == BIT_1)
				|| (timer == BIT_2)
				|| (timer == BIT_3)
				|| (timer == BIT_4)
				|| (timer == BIT_5)
				|| (timer == BIT_6)
				|| (timer == BIT_7)
				|| (timer == STOP))
			begin
				rs232_rxd <= buffer[0];
				buffer[0] <= buffer[1];
				buffer[1] <= buffer[2];
				buffer[2] <= buffer[3];
				buffer[3] <= buffer[4];
				buffer[4] <= buffer[5];
				buffer[5] <= buffer[6];
				buffer[6] <= buffer[7];
				buffer[7] <= 1'b1;
			end
			
			if (timer == FINISH-1)
			begin
				running <= 1'b0;
				ready <= !rs232_rts_n;
			end			
		end
		else
		begin
			if (ready && valid)
			begin
				rs232_rxd <= 1'b0;
				buffer <= data;
				running <= 1'b1;
				ready <= 1'b0;
			end
			else
			begin
				rs232_rxd <= 1'b1;
				buffer <= 8'bx;
				running <= 1'b0;
				ready <= !rs232_rts_n;
			end
		end
	end

endmodule

module rs232_receive #(parameter integer CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire reset,
	input wire txd_async,
	output reg [7:0] data,
	output reg valid);

	reg txd_temp, txd;

	always @(posedge clock or posedge reset)
	begin
		if (reset)
		begin
			txd_temp = 1'b1;
			txd <= 1'b1;
		end	
		else 
		begin
			txd_temp <= txd_async;
			txd <= txd_temp;
		end
	end

	localparam integer
		START = (CLOCK_FREQ *  1) / (2 * BAUD_RATE),
		BIT_0 = (CLOCK_FREQ *  3) / (2 * BAUD_RATE),
		BIT_1 = (CLOCK_FREQ *  5) / (2 * BAUD_RATE),
		BIT_2 = (CLOCK_FREQ *  7) / (2 * BAUD_RATE),
		BIT_3 = (CLOCK_FREQ *  9) / (2 * BAUD_RATE),
		BIT_4 = (CLOCK_FREQ * 11) / (2 * BAUD_RATE),
		BIT_5 = (CLOCK_FREQ * 13) / (2 * BAUD_RATE),
		BIT_6 = (CLOCK_FREQ * 15) / (2 * BAUD_RATE),
		BIT_7 = (CLOCK_FREQ * 17) / (2 * BAUD_RATE),
		STOP =  (CLOCK_FREQ * 19) / (2 * BAUD_RATE);

	localparam integer TIMER_WIDTH = $clog2(STOP + 1);

	reg [TIMER_WIDTH-1:0] timer;
	
	always @(posedge clock or posedge reset)
	begin
		if (reset)
			timer <= 0;
		else if (timer == 0)
			timer <= txd ? 1 : 0;
		else if (timer == START)
			timer <= txd ? 0 : timer + 1;
		else if (timer == STOP)
			timer <= 0;
		else
			timer <= timer + 1;
	end

	always @(posedge clock or posedge reset)
	begin
		if (reset)
			valid <= 1'b0;
		else
			valid <= timer == STOP && txd;
	end

	always @(posedge clock or posedge reset)
	begin
		if (reset)
			data <= 8'b0;
		else if (timer == BIT_0 || timer == BIT_1 || timer == BIT_2	|| timer == BIT_3
			|| timer == BIT_4 || timer == BIT_5 || timer == BIT_6 || timer == BIT_7)
		begin
			data[6:0] <= data[7:1];
			data[7] <= txd;
		end
	end

endmodule
