module flash_control_tb();

logic clk, start_flash_read, valid_read, wait_request, mem_read, end_flash_read;

flash_control dut (.clk(clk), .start_flash_read(start_flash_read), .valid_read(valid_read), .wait_request         (wait_request), .mem_read(mem_read), .end_flash_read(end_flash_read));

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

   start_flash_read = 1'b0;
   mem_read = 1'b0;
   wait_request = 1'b0;
   valid_read = 1'b0;

   #20;

   start_flash_read = 1'b1;

   #20;

   mem_read = 1'b1;

   #20;

   wait_request = 1'b0;

   #20;

   valid_read = 1'b0;

   #20;

   $stop; 
end

endmodule

