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
		BIT_0 = CLOCK_FREQ / BAUD_RATE,
		BIT_1 = CLOCK_FREQ * 2 / BAUD_RATE,
		BIT_2 = CLOCK_FREQ * 3 / BAUD_RATE,
		BIT_3 = CLOCK_FREQ * 4 / BAUD_RATE,
		BIT_4 = CLOCK_FREQ * 5 / BAUD_RATE,
		BIT_5 = CLOCK_FREQ * 6 / BAUD_RATE,
		BIT_6 = CLOCK_FREQ * 7 / BAUD_RATE,
		BIT_7 = CLOCK_FREQ * 8 / BAUD_RATE,
		STOP = CLOCK_FREQ * 9 / BAUD_RATE,
		FINISH = CLOCK_FREQ * 10 / BAUD_RATE;

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

/*
module rs232_receiver #(parameter integer CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire reset,
	input wire TXD,
	output wire CTSn,
	output reg [7:0] data,
	output reg valid,
	input wire ready);

	localparam integer
		START = CLOCK_FREQ / (2 * BAUD_RATE),
		BIT_0 = CLOCK_FREQ * 3 / (2 * BAUD_RATE),
		BIT_1 = CLOCK_FREQ * 5 / (2 * BAUD_RATE),
		BIT_2 = CLOCK_FREQ * 7 / (2 * BAUD_RATE),
		BIT_3 = CLOCK_FREQ * 9 / (2 * BAUD_RATE),
		BIT_4 = CLOCK_FREQ * 11 / (2 * BAUD_RATE),
		BIT_5 = CLOCK_FREQ * 13 / (2 * BAUD_RATE),
		BIT_6 = CLOCK_FREQ * 15 / (2 * BAUD_RATE),
		BIT_7 = CLOCK_FREQ * 17 / (2 * BAUD_RATE);

	function integer clog2(input integer n); 
		begin
			clog2 = 0; 
			while ((n >> clog2) > 1)
				clog2 = clog2 + 1;
		end 
	endfunction

	localparam integer
		COUNTER_MAX = 1 + CLOCK_FREQ / BAUD_RATE,
		COUNTER_LOG = clog2(COUNTER_MAX);

	reg [COUNTER_LOG-1:0] counter;
	reg running;
	reg pulse;
	assign CTSn = !ready;

	always @(posedge clock)
		if (!running)
		begin
			counter <= 0;
			pulse <= 0;
		end 
		else 
		begin
			case(counter)
				START: pulse <= 1;
				BIT_0:
				begin
					pulse <= 1;
					data[0] <= TXD;
				end

				BIT_1:
				begin
					pulse <= 1;
					data[1] <= TXD;
				end

				BIT_2:
				begin
					pulse <= 1;
					data[2] <= TXD;
				end

				BIT_3:
				begin
					pulse <= 1;
					data[3] <= TXD;
				end

				BIT_4:
				begin
					pulse <= 1;
					data[4] <= TXD;
				end

				BIT_5:
				begin
					pulse <= 1;
					data[5] <= TXD;
				end

				BIT_6:
				begin
					pulse <= 1;
					data[6] <= TXD;
				end

				BIT_7:
				begin
					pulse <= 1;
					data[7] <= TXD;
				end

				default: 
					pulse <= 0;
			endcase			counter <= counter + 1;

			counter <= counter + 1;
		end
	begin
		
	end

endmodule

*/