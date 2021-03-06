module keyboard_audio_controller_tb();

logic clk, read_ready, forward;
logic [7:0] key;

keyboard_audio_controller dut (.clk(clk), .key(key), .forward(forward), .read_ready(read_ready));

initial begin
    clk = 0; #5;
    //forever loop for clk signal
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
end

initial begin
	#20;
	key = 8'h46; // F

	#20;

	key = 8'h44; // D

	#20;

	key = 8'h42; // B

	#20;

	key = 8'h45; // E

	#20;

	key = 8'h46; // F (back to playing forward)

	#20;

	$stop;
end

endmodule
