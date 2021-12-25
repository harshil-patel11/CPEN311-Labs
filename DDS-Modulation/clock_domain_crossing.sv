// move data from fast to slow clock
module clk_domain_fast_to_slow (fast_clk, slow_clk, in, out);
  input logic fast_clk, slow_clk;
  input logic [11:0] in;
  output logic [11:0] out;

  logic [11:0] reg1, reg2, reg3, reg4, reg5;

  always_ff @(posedge fast_clk) begin
    reg1 <= in;
    if (reg5) begin
      reg3 <= reg1;
    end
  end

  always_ff @(negedge fast_clk) begin
    reg4 <= slow_clk;
    reg5 <= reg4;
  end

  always_ff @(posedge slow_clk) begin
    reg2 <= reg3;
  end

  assign out = reg2;
endmodule
