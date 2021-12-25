module task2a (clk, start, secret_key, wen, q, data, address, finished);
  input logic clk, start;
  input logic [7:0] q;
  input logic [23:0] secret_key;
  output logic wen, finished;
  output logic [7:0] data, address;

  wire s_i_en, s_j_en;
  reg [7:0] i, j, s_i, s_j;

  parameter keylength = 8'b0000_0011;

  parameter idle              = 8'b0000_0000;
  parameter update_address1   = 8'b0001_0000;
  parameter fetch_mem1        = 8'b0010_0100;
  parameter fetch_mem1_wait   = 8'b0011_0100;
  parameter update_j          = 8'b0100_0000;
  parameter update_address2   = 8'b0101_0000;
  parameter fetch_mem2        = 8'b0110_1000;
  parameter fetch_mem2_wait   = 8'b0111_1000;
  parameter update_data1      = 8'b1000_0000;    
  parameter write_mem1        = 8'b1001_0010;
  parameter write_mem1_wait   = 8'b1010_0010;
  parameter update_data2      = 8'b1011_0000;
  parameter write_mem2        = 8'b1100_0010;
  parameter write_mem2_wait   = 8'b1101_0010;
  parameter increment_i       = 8'b1110_0000;
  parameter finish            = 8'b1111_0001;

  reg [7:0] state = idle;

  assign finished = state[0]; // Finished signal
  assign wen      = state[1]; // Write enable 
  assign s_i_en   = state[2]; // Enable signal for s_i register
  assign s_j_en   = state[3]; // Enable signal for s_j register

  always_ff @(posedge clk) begin
    if (s_i_en) s_i <= q;
    if (s_j_en) s_j <= q;
  end

  always_ff @(posedge clk) begin
    case (state)
      idle: begin
        if (start) begin
          // state <= fetch_mem1;
          state <= update_address1;
          i <= 0;
          j <= 0;
        end
      end

      update_address1: begin
        address <= i;
        state <= fetch_mem1;
      end

      // fetch_mem1: state <= update_j;
      fetch_mem1: state <= fetch_mem1_wait;

      fetch_mem1_wait: state <= update_j;
      
      update_j: begin
        if (i % keylength == 0) 
          j <= j + s_i + secret_key[23:16];
        else if (i % keylength == 1) 
          j <= j + s_i + secret_key[15:8];
        else 
          j <= j + s_i + secret_key[7:0];

        state <= update_address2;
      end

      update_address2: begin
        address <= j;
        state <= fetch_mem2;
      end

      // fetch_mem2: state <= update_data1;
      fetch_mem2: state <= fetch_mem2_wait;

      fetch_mem2_wait: state <= update_data1;

      //swap start
      update_data1: begin
        address <= j;
        data <= s_i;
        state <= write_mem1;
      end

      // write_mem1: state <= update_data2;
      write_mem1: state <= write_mem1_wait;

      write_mem1_wait: state <= update_data2;

      update_data2: begin
        address <= i;
        data <= s_j;
        state <= write_mem2;
      end

      // write_mem2: state <= increment_i;
      write_mem2: state <= write_mem2_wait;

      write_mem2_wait: state <= increment_i;
      //swap end

      increment_i: begin
        if (i == 255) state <= finish;
        else begin
          i <= i + 1;
          state <= update_address1;          
        end
      end

      finish: state <= idle;
    endcase
  end
endmodule
