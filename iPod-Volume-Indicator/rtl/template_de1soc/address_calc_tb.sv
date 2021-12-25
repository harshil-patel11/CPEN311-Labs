module address_calc_tb ();

logic clk, sync_clk, play, forward, end_flash_read, start_flash, read, finish;;
logic [31:0] audiodata;
logic [3:0] byteenable;
logic [22:0] mem_addr;
logic [15:0] audio_out;

address_calc dut (.clk(clk), .sync_clk(sync_clk), .play(play), .forward(forward), .end_flash_read(end_flash_read), .start_flash(start_flash), .read(read), .finish(finish), .audiodata(audiodata), .byteenable(byteenable), .mem_addr(mem_addr), .audio_out(audio_out));

initial begin
    clk = 0; #5;
    //forever loop for clk signal
    forever begin
      clk = 1; 
      sync_clk = 1;
      #5;
      clk = 0;
      sync_clk = 0;
      #5;
    end
end

initial begin
    #10;
    play = 1'b0;
    end_flash_read = 1'b0;
    forward = 1'b1;

    #10;
    play = 1'b1;

    #10;
    end_flash_read = 1'b1;

    #40;
    forward = 1'b1;

    #30;

    $stop;
end

endmodule