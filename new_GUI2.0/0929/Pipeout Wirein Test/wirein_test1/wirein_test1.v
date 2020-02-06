module wirein_test1
(
	input      hi_in,
	output     hi_out,
	inout      hi_inout,
	output     hi_muxsel,
	input			clock,
	input			clock2
);

wire [7:0]  hi_in;
wire [1:0]  hi_out;
wire [15:0] hi_inout;
wire        hi_muxsel;

assign      hi_muxsel=1'b0;

// Opal Kelly Module Interface Connections
wire        ti_clk;
wire [112:0] okHE;
wire [64:0] okEH;

// Endpoint connections:
wire [31:0]  ep00wire;
wire [31:0]  ep01wire;
wire [31:0]  ep02wire;

wire [31:0]  epA0pipe;
wire         epA0read;
wire         epA0_blockSTROBE;
wire         epA0_ready;

wire reset;
wire enable;
wire reset_transfer;
wire [31:0]  tmp_1;
wire [31:0] tmp_2;

wire [6:0] data_out;
wire       clk_bar;

assign reset = ep00wire[0];
assign enable = ep01wire[0];
assign reset_transfer = ep02wire[0];

assign tmp_1 = {9'd0,7'd23};
assign tmp_2 = {9'd0, data_out};
// assign tmp_2 = {9'd0,7'b0101010};
assign clk_bar = ~clock;

ramp test (
	.reset	(~reset),
	.enable	(enable),
	.data_out	(data_out),
	.clock	(clock)
);

CIC_data_transferFIFO transfer (
	.reset (reset_transfer),
	.write_clk (clock),
	.read_clk (clock2),
	.data_in (tmp_2),
	.ep_read (epA0read),
	.data_out (epA0pipe),
	.ep_ready  (epA0_ready)
);

wire [65*1-1:0]  okEHx;
okHost okHI(
	.hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .ti_clk(ti_clk),
	.okHE(okHE), .okEH(okEH));

okWireOR # (.N(1)) wireOR (.okEH(okEH), .okEHs(okEHx));

okWireIn     ep00 (.okHE(okHE),                          .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn     ep01 (.okHE(okHE),                          .ep_addr(8'h01), .ep_dataout(ep01wire));
okWireIn     ep02 (.okHE(okHE),                          .ep_addr(8'h02), .ep_dataout(ep02wire));



// okBTPipeOut pipeOutA3 (.ok1(ok1), .ok2(ok2) .ep_addr(8’ha3), .ep_datain(epA3pipe), .ep_read(epA3read), .ep_blockstrobe(epA3strobe), .ep_ready(epA3ready)); 
okBTPipeOut  pipeOutA0 (.okHE(okHE), .okEH(okEH[ 0*17 +: 17 ]), .ep_addr(8'ha0), .ep_datain(epA0pipe), .ep_read(epA0read),  .ep_blockstrobe(epA0_blockSTROBE), .ep_ready(epA0_ready));

endmodule