/*
Moves data from idata to odata. Data is transferred on the ports
when both xx_val and xx_rdy are high on the rising edge of the clock.
*/

module chan2chan #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

	reg [WIDTH-1:0] buffer; // bvalid = !iready (&& ovalid)

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			iready <= 1'b1;
			odata <= {WIDTH{1'bx}};
			ovalid <= 1'b0;
			buffer <= {WIDTH{1'bx}};
		end
		else
		begin
			ovalid <= (ovalid && !oready) || !iready || ivalid;
			odata <= (ovalid && !oready) ? odata : (!iready ? buffer : idata);

			iready <= !ovalid || oready || (iready && !ivalid);
			buffer <= (ovalid && !oready && iready && ivalid) ? idata : buffer;
		end
	end

endmodule

module pull2chan #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire iempty,
	output reg irden,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

	reg [WIDTH-1:0] buffer;
	reg bvalid;

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			irden <= 1'b0;
			odata <= {WIDTH{1'bx}};
			ovalid <= 1'b0;
			buffer <= {WIDTH{1'bx}};
			bvalid <= 1'b0;
		end
		else
		begin
			ovalid <= (ovalid && !oready) || bvalid || irden;
			odata <= (ovalid && !oready) ? odata : (bvalid ? buffer : idata);

			bvalid <= ovalid && !oready && (irden || bvalid);
			buffer <= (ovalid && !oready && irden) ? idata : buffer;

			irden <= !iempty && !(ovalid && !oready && (irden || bvalid));
		end
	end

endmodule
