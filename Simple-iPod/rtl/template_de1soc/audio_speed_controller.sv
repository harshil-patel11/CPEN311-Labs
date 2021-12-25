/*
	This module is responsible for controlling the speed of the song being played.
	It makes the changes on every posedge of clk.
	When the increase signal is asserted, the speed increases by adding 10 clock cycles.
	When the decrease signal is asserted, the speed decreases by subtracting 10 clock cycles.
	
	The output clk_count determines the number of clock cycles that need to be input into the clock divider in the top level module. Since we are dividing a 27MHz signal into a 22kHz signal, my clock divider implementation from lab 1 will require the following number of clock cycles:
	27000000/44000 = 32'd613 = 32'h265 (we divide by double of 22kHz because of the implementation of the clock divider).
*/

module audio_speed_controller (clk, increase, decrease, rst, clk_count);

input logic clk, increase, decrease, rst;
output [31:0] clk_count;

logic [31:0] starting_clk_count = 32'h266; // Set to default clock_count

always_ff @(posedge clk) begin

	if (increase && starting_clk_count >= 32'h10) starting_clk_count <= starting_clk_count - 32'h10; // Decrease by 32'h10, if value could go below 32'h10 (after which it could go negative), maintain the same value (in the else statement)
	else if (decrease && starting_clk_count <= 32'h8D0) starting_clk_count <= starting_clk_count + 32'h10; // Increase by 32'h10, if value could go above 32'h8D0 (upper bound max), maintain the same value
	else if (rst) starting_clk_count <= 32'h266; // Reset to default
	else starting_clk_count <= starting_clk_count; // No change otherwise or maintain value
end

assign clk_count = starting_clk_count; // Assign it to output

endmodule