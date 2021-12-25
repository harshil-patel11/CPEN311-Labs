module task2b_tb ();
logic clk, start, wen, finished, wren_d;
logic [7:0] q, q_m, data, data_d, address;
logic [23:0] secret_key;
logic [4:0] address_d, address_m;

task2b dut (.clk(clk), .start(start), .wen(wen), .finished(finished), .wren_d(wren_d), .q(q), .q_m(q_m), .data(data), .data_d(data_d), .address(address), .secret_key(secret_key), .address_d(address_d), .address_m(address_m));

initial begin
	forever begin
		clk = 1'b1;
		#10;
		clk = 1'b0;
		#10;
	end
end

initial begin
	#10;
	//IDLE

	start = 1'b1;
	//INCREMENT_I 
	#20;
	//UPDATE_ADRDRESS_I
	#20;
	//FETCH_MEM_I
	#20;
	//FETCH_MEM_I_WAIT
	#20;
	//UPDATE_J
	#20;
	//UPDATE_ADDRESS_J
	#20;
	//FETCH_MEM_J
	#20;
	//FETCH_MEM_J_WAIT
	#20;
	//UPDATE_DATA_J
	#20;
	//WRITE_MEM_J
	#20;
	//WRITE_MEM_J_WAIT
	#20;
	//UPDATE_DATA_I
	#20;
	//WRITE_MEM_I
	#20;
	//WRITE_MEM_I_WAIT
	#20;
	//UPDATE_ADDRESS_F
	#20;
	//FETCH_MEM_F
	#20;
	//FETCH_MEM_F_WAIT
	#20;
	//FETCH_DATA_ENCRYPT
	#20;
	//FETCH_DATA_ENCRYPT_WAIT
	#20;
	//UPDATE_DATA_DECRYPT
	#20;
	//WRITE_MEM_DECRYPT
	#20;
	//INCREMENT_K
	#20;
	//FINISH

	#200;
	$stop;
end

endmodule