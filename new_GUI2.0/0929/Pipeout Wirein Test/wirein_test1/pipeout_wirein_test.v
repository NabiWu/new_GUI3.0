
module wirein_test1
(
	input      hi_in,
	output     hi_out,
	inout      hi_inout,
	output     hi_muxsel,
	output     led
);

wire [7:0]  hi_in;
wire [1:0]  hi_out;
wire [15:0] hi_inout;
wire        hi_muxsel;
wire [7:0]  led;

assign      hi_muxsel=1'b0;
// Opal Kelly Module Interface Connections
wire        ti_clk;
wire [112:0] okHE;
wire [64:0] okEH;

// Endpoint connections:
// wire [15:0]  ep00wire;

wire [31:0]  epA3pipe;
wire         epA3read;
wire         epA3_blockSTROBE;
wire         epA3_ready;

/*
assign led[0] =  ~ep00wire[0];
assign led[1] =  ~ep00wire[1];
assign led[2] =  ~ep00wire[2];
assign led[3] =  ~ep00wire[3];
assign led[4] =  ~ep00wire[4];
assign led[5] =  ~ep00wire[5];
assign led[6] =  ~ep00wire[6];
assign led[7] =  ~ep00wire[7];
*/

okHost okHI(
	.hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .ti_clk(ti_clk),
	.okHE(okHE), .okEH(okEH));

okWireIn     ep00 (.okHE(okHE),                          .ep_addr(8'h00), .ep_dataout(ep00wire));


// okBTPipeOut pipeOutA3 (.ok1(ok1), .ok2(ok2) .ep_addr(8’ha3), .ep_datain(epA3pipe), .ep_read(epA3read), .ep_blockstrobe(epA3strobe), .ep_ready(epA3ready)); 
// okBTPipeOut BTpipeOutpA3 (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'ha3), .ep_read(epA3read), .ep_datain(epA3pipe), .ep_blockstrobe(epA3_blockSTROBE), .ep_ready(epA3_ready));
okBTPipeOut  BTpipeOutA3 (.okHE(okHE), .okEH(okEH), .ep_addr(8'ha3), .ep_datain(epA3pipe), .ep_read(epA3read),  .ep_blockstrobe(epA3_blockSTROBE), .ep_ready(epA3_ready));
// okBTPipeOut pipeOutA3 (.ok1(ok1), .ok2(ok2), .ep_addr(8'h00), .ep_datain(ep00pipe), .ep_read(ep00read), .ep_blockstrobe(ep00strobe), .ep_ready(ep00ready)); 

endmodule