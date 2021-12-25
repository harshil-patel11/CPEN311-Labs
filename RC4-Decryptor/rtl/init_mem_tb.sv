module init_mem_tb ();
logic clk, start, wen, finished;
logic [7:0] data, address;

init_mem dut (.clk(clk), .start(start), .wen(wen), .data(data), .address(address), .finished(finished));

initial begin
	forever begin
		clk = 1'b1;
		#10;
		clk = 1'b0;
		#10;
	end
end

initial begin
	start = 1'b0;
	#10; // Stay in idle

	start = 1'b1; // Assert start = 1, begin fsm

	#20;

	start = 1'b0; // Deassert start = 0

	#4500 // Wait for memory to be initialized and finished to be asserted

	$stop;
end

endmodule