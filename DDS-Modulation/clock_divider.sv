// A module to divide in input clock signal
module clock_divider (inclk, outclk, div_clk_count, reset);
  input logic inclk, reset;
  input logic [31:0] div_clk_count;
  output logic outclk = 0;
  logic [31:0] count = 0;

  always_ff @ (posedge inclk, posedge reset) begin
    if (reset) begin
      outclk <= 0;
      count <= 0;
    end
    // if we reached the 50 percent duty cycle count, then invert the outclk and 
    // set count to 0
    else if (count >= (div_clk_count - 32'b1)) begin
      outclk <= ~outclk;
      count <= 0;
    end
    else count <= count + 32'b1;
  end  
endmodule  