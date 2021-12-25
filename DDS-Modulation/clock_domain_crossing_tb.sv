module clk_domain_fast_to_slow_tb();
logic fast_clk, slow_clk;
logic [11:0] in;
logic [11:0] out;

clk_domain_fast_to_slow dut (.fast_clk(fast_clk), .slow_clk(slow_clk), .in(in), .out(out));

initial begin
	forever begin
		fast_clk = 1'b1;
		#5;
		fast_clk = 1'b0;
		#5;
	end
end

initial begin
	forever begin
		slow_clk = 1'b1;
		#15;
		slow_clk = 1'b0;
		#15;
	end
end

initial begin
#10;

in = 12'b1;

#60;

in = 12'd10;

#60;

in = 12'd30;

#300;

$stop;

end

endmodule