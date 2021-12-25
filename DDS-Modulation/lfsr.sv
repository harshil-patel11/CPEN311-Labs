module lfsr (clk, lfsr);
input logic clk;
output reg [4:0] lfsr = 5'b1;

always_ff @(posedge clk) begin
    lfsr[3] <= lfsr[4];
    lfsr[2] <= lfsr[3];
    lfsr[1] <= lfsr[2];
    lfsr[0] <= lfsr[1];  
    lfsr[4] <= lfsr[2] ^ lfsr[0];
end

endmodule