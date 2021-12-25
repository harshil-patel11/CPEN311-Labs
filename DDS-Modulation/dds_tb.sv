module dds_tb();
logic clk, reset;
logic [31:0] phase_inc;
logic [11:0] sin_out, cos_out, squ_out, saw_out;

waveform_gen dut (.clk(clk), 
				          .reset(reset),
				        	.en(1'b1),
			        		.phase_inc(phase_inc),
				        	.sin_out(sin_out),
				        	.cos_out(cos_out),
				        	.squ_out(squ_out),
				        	.saw_out(saw_out));	

initial begin
	forever begin
		clk = 1'b1;
		#5;
		clk = 1'b0;
		#5;
	end
end		

initial begin
	phase_inc = 32'd10000;
	reset = 0;
	#10;
	reset = 1'b1;
  #6000000;
  $stop;
end

endmodule
								