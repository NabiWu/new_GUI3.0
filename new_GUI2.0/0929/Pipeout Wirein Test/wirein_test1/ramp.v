module ramp
(
	input			reset,
	input 		enable,
	output		data_out,
	input			clock

);

wire [6:0]		data_out;
reg[6:0] 		count;
reg 				s1;

assign data_out = count;

always@(negedge clock or negedge reset)
begin
	if (~reset)
	begin
		count = 7'd0;
		s1 = 1;
	end

	else 
	begin
		if(enable)
		begin
			if (s1 == 1)
			begin
				count = count + 1;
				if (count == 100)
				begin
					s1 = 0;
				end
			end
			else if (s1 == 0)
			begin
				count = count - 1;
				if (count == 0)
				begin
					s1 = 1;
				end
			end
		end
	end

end

endmodule
