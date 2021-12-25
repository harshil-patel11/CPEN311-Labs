/*
The clk_sync module uses 4 asynchronized flip flops in order to produce a synchronized clk signal.
The module is adapted from the schematic after page 48 in lecture 4b / Last question of HW1.
This module will be used by the top level module to synchronize the 22kHz signal and 27MHz signal which was divided. This means that when the 27MHz has a posedge, so should the 22kHz clk. 
*/

module clk_sync(outClk, async_clk, out_sync_clk);

input logic outClk, async_clk;
output logic out_sync_clk;

logic q_a, q_b, q_c, q_d;

async_ff ff_a (.clk(async_clk), .clr(!async_clk & q_c), .d(1'b1), .q(q_a));
async_ff ff_b (.clk(outClk), .clr(1'b0), .d(q_a), .q(q_b));
async_ff ff_c (.clk(outClk), .clr(1'b0), .d(q_b), .q(q_c));
async_ff ff_d (.clk(outClk), .clr(1'b0), .d(q_c), .q(q_d));

assign out_sync_clk = !q_d & q_c;

endmodule

// Asynchronized d flip flop that can be connected in sequence
module async_ff (clk, clr, d, q);
input logic clk, clr, d;
output logic q;

always_ff @(posedge clk or posedge clr) begin
	if (clr) q <= 1'b0;
	else q <= d;
end

endmodule
