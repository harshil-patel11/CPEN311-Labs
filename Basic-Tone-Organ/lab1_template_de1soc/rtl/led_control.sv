module led_control (inClk, led);
    input logic inClk;
    output logic [7:0] led = 8'b10000000;
    logic left_to_right = 1'b1;

    always @(posedge inClk) begin
        if (left_to_right) begin
            if (led[0] != 1'b1) led <= led >> 1;
            else begin
                left_to_right = ~left_to_right;
                led <= led << 1;
            end
        end

        else begin
            if (led[7] != 1'b1) led <= led << 1;
            else begin
                left_to_right = ~left_to_right;
                led <= led >> 1;
            end
        end

    end
endmodule
