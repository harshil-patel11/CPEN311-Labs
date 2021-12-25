module clk_divider_tb();
    logic inClk, reset;
    logic [31:0] clock_count;
    logic outClk;

clk_divider dut(inClk, reset, clock_count, outClk);

initial begin
    inClk = 1'b0;
    reset = 1'b0;

    forever begin
        inClk = 1'b0;
        #10;
        inClk = 1'b1;
        #10;
    end
end

initial begin
    reset = 1'b0;
    clock_count = 32'd2; // Divide freq by 2
    #200;

    clock_count = 32'd5; // Divide freq by 5
    #400;

    clock_count = 32'd10; // Divide freq by 10
    #600;

$stop;
end
endmodule