module led_control_tb ();
    logic clk;
    logic [7:0] led;

led_control dut(clk, led);

    initial begin
        clk = 1'b0;

    forever begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end

    end

    initial begin
        #1000;

        $stop;

    end
endmodule