module task3_tb ();

logic clk, start, error, finished;
reg [7:0] q_d = 0;
logic [4:0] address_d;

task3 dut (.clk(clk), .start(start), .error(error), .finished(finished), .q_d(q_d), .address_d(address_d));

initial begin
	forever begin
		clk = 1'b1;
		#10;
		clk = 1'b0;
		#10;
	end
end

initial begin
	#10; // stay in idle

	start = 1'b1;

	#20;
	//FETCH_DATA_D

	#20;
	//FETCH_DATA_D_WAIT

	#20;
	//ERROR_STATE

	#20; 

	#200;
	$stop;
end

endmodule