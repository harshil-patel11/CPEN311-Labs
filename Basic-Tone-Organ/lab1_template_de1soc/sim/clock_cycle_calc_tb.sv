module clock_cycle_calc_tb ();
logic [2:0] sw;
logic [31:0] out;

clock_cycle_calc dut (sw, out);

initial begin
    #10
    sw = 3'b000;
    #50;
    sw = 3'b001;
    #50;
    sw = 3'b010;
    #50;
    sw = 3'b011;
    #50;
    sw = 3'b100;
    #50;
    sw = 3'b101;
    #50;
    sw = 3'b110;
    #50;
    sw = 3'b111;
    #50;
end

endmodule