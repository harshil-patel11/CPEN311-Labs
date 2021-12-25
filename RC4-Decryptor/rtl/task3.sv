module task3 (clk, start, address_d, q_d, error, finished);

input clk, start;
input [7:0] q_d;
output error, finished;
output [4:0] address_d;

parameter num_iters = 5'd31;

parameter idle 				      = 5'b000_00;
parameter fetch_data_d 		  = 5'b001_00;
parameter fetch_data_d_wait	= 5'b010_00;
parameter check_data_val 	  = 5'b011_00;
parameter increment_count   = 5'b100_00;
parameter error_state 		  = 5'b101_11;
parameter success_state		  = 5'b110_01;

reg [4:0] state = idle;
reg [4:0] count;

assign error = state[1];
assign finished = state[0];
assign address_d = count;

always_ff @(posedge clk) begin
  case(state)
    idle: begin
      if (start) begin
        state <= fetch_data_d;
        count <= 0;
      end
    end

    fetch_data_d: state <= fetch_data_d_wait;

    fetch_data_d_wait: state <= check_data_val;

    check_data_val: begin
      if ((q_d >= 97) && (q_d <= 122) || (q_d == 32)) begin
        state <= increment_count;
      end else begin
        state <= error_state;
      end
    end

    increment_count: begin
      if (count == num_iters) begin
        state <= success_state;
      end else begin
        count <= count + 1;
        state <= fetch_data_d;
      end
    end

    error_state: state <= idle;

    success_state: state <= idle;
  endcase
end

endmodule