module init_mem (clk, start, wen, data, address, finished);
  input logic start, clk;
  output logic wen, finished;
  output logic [7:0] data;
  output logic [7:0] address;

  reg [7:0] count;
  
  parameter idle        = 4'b00_00;
  parameter increment   = 4'b01_10;
  parameter finish      = 4'b10_01;

  reg [3:0] state = idle;

  assign data = count;
  assign address = count;
  assign finished = state[0];
  assign wen = state[1];

  always_ff @(posedge clk) begin
    case(state)
      idle: begin 
        if (start) begin
          count <= 0;
          state <= increment;
        end
      end

      increment: begin
        if (count == 255) state <= finish;
        else begin 
          count <= count + 1;   
        end    
      end

      finish: state <= idle;
    endcase    
  end

endmodule