module CIC_data_transferFIFO
(
input  wire        reset,
input  wire        write_clk,
input  wire        read_clk,
input  wire [15:0] data_in,
input  wire        ep_read,
output wire [15:0] data_out,
output wire        ep_ready  
);

reg         write_en;
reg         read_en;
wire        full;
wire        empty;
wire        ti_clk_BAR;
wire        reset_bar;
reg   [7:0] count1;
reg         s1;
reg         mark1;
reg   [7:0] count2;
reg         s2;
reg         s3;
reg   [7:0] count3;
reg         s3_1;
/*
assign w_en_tmp   = write_en;
assign r_en_tmp   = read_en;
assign full_tmp   = full;
assign empty_tmp  = empty;
assign count1_tmp = count1;
assign count2_tmp = count2;
assign count3_tmp = count3;
assign s1_tmp     = s1;
assign s2_tmp     = s2;
assign s3_tmp     = s3;
assign s3_1_tmp     = s3_1;
assign mark1_tmp     = mark1;
*/
assign ti_clk_BAR = ~ read_clk;
assign reset_bar  = ~ reset;

always@(posedge write_clk or posedge reset)
begin
  if(reset)
  begin
    count1 = 8'd0;
    s1     = 0;
  end
  else if(s1 == 0)
  begin
    count1 = count1 + 1;
    if(count1 == 100)
    begin
      count1 = 0;
      s1     = 1;
    end
  end
end

always@(negedge write_clk or negedge reset_bar)
begin
  if(reset_bar == 0)
  begin
    mark1    = 0;
    write_en = 0;
  end
  else if(s1 == 1)
  begin
    if(full == 0)
    begin
      if(mark1 == 0)
      begin
        write_en = 1;
      end
    end
    else
	 begin
      write_en = 0;
      mark1    = 1;
    end
  end
end

always@(posedge read_clk or posedge reset)
begin
  if(reset)
  begin
    count2 = 8'd0;
    s2     = 0;
  end
  else if(mark1 == 1)
  begin
    if(s2 == 0)
    begin
      count2 = count2 + 1;
      if(count2 == 200)
      begin
        count2 = 0;
        s2     = 1;
      end
    end
  end
end

assign ep_ready = ((s2 == 1) && (s3_1 == 0));

always@(posedge read_clk or posedge reset)
begin
  if(reset)
  begin
    read_en = 0;
    s3      = 0;
  end
  else if((s2 == 1)&&(s3 == 0))
  begin
    if(ep_read == 1)
    begin
      read_en = 1;
    end
    else
      read_en = 0;
		
	 if(empty == 1)
	 begin
	   read_en = 0;
      s3      = 1;
	 end
  end
end
    
always@(posedge read_clk or posedge reset)
begin
  if(reset)
  begin
    count3 = 8'd0;
    s3_1     = 0;
  end
  else if(s3 == 1)
  begin
    if(s3_1 == 0)
    begin
      count3 = count3 + 1;
      if(count3 == 100)
      begin
        count3 = 0;
        s3_1   = 1;
      end
    end
  end
end

Transfer_FIFO X0
(
  .rst(reset),
  .wr_clk(write_clk),
  .rd_clk(ti_clk_BAR),
  .din(data_in),
  .wr_en(write_en),
  .rd_en(read_en),
  .dout(data_out),
  .full(full),
  .empty(empty)
);

endmodule
