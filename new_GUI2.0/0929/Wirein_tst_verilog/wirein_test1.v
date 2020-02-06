module wirein_test1
(
	input        okUH,
	output       okHU,
	inout        okUHU,
	inout        okAA,
	input        sys_clkp,
	input        sys_clkn,
	output       pgaR0
);

// Clock
wire sys_clk;
IBUFGDS osc_clk(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));

// Opal Kelly Module Interface Connections
wire [4:0]   okUH;
wire [2:0]   okHU;
wire [31:0]  okUHU;
wire         okAA;
	
// Target interface bus:
wire         okClk;
wire [112:0] okHE;
wire [64:0]  okEH;

// Endpoint connections:
wire [31:0]  ep00wire;
wire [31:0]  ep01wire;
wire [31:0]  ep02wire;

wire [31:0]  epA0pipe;
wire [15:0]  epA0pipe_tmp;
wire         epA0read;
wire         epA0_blockSTROBE;
wire         epA0_ready;

wire reset;
wire enable;
wire reset_transfer;
wire clk_w;
wire [15:0]  tmp_1;
//wire [31:0] tmp_2;

wire [6:0] data_out;
//wire       clk_bar;

assign reset          = ep00wire[0];
assign enable         = ep01wire[0];
assign reset_transfer = ep02wire[0];

assign tmp_1 = {9'd0, data_out};
//assign tmp_1 = {16'b1111111111111111};
//assign pgaR0 = data_out[0];

//assign tmp_2 = {9'd0, data_out};
// assign tmp_2 = {9'd0,7'b0101010};
//assign clk_bar = ~clk_w;

clk_div_v3 U0
(
	.clk     (sys_clk),
	.reset     (reset),
	.clk_out (clk_w)
);

ramp X1
(
	.reset	   (~reset),
	.enable	   (enable),
	.data_out	(data_out),
	.clock	   (clk_w)
);

cont_dataTransfer_FIFO X2
(
	.RST(reset_transfer),
	.CLK_W(clk_w),
	.CLK_R(sys_clk),
	.DATA_IN(tmp_1),
	.DATA_OUT(epA0pipe_tmp),
	.EP_READ(epA0read),
	.EP_READY(epA0_ready)
);

assign epA0pipe={16'd0, epA0pipe_tmp};

wire [65*1-1:0]  okEHx;

okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH)
);

okWireOR # (.N(1)) wireOR (okEH, okEHx);

okWireIn     ep00 (.okHE(okHE),                          .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn     ep01 (.okHE(okHE),                          .ep_addr(8'h01), .ep_dataout(ep01wire));
okWireIn     ep02 (.okHE(okHE),                          .ep_addr(8'h02), .ep_dataout(ep02wire));

okBTPipeOut  pipeOutA0 (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'ha0), .ep_datain(epA0pipe), .ep_read(epA0read),  .ep_blockstrobe(epA0_blockSTROBE), .ep_ready(epA0_ready));

endmodule
