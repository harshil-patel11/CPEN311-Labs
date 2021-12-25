module task2b (clk, start, secret_key, wen, q, data, address, finished,
  address_d, data_d, wren_d, q_m, address_m);
  input logic clk, start;
  input logic [7:0] q, q_m;
  input logic [23:0] secret_key;
  output logic wen, finished, wren_d;
  output logic [4:0] address_d, address_m;
  output logic [7:0] data, data_d, address;

  wire s_i_en, s_j_en, f_en;
  reg [7:0] i, j, k, s_i, s_j, f;

  parameter message_length = 8'd32;

  parameter idle                    = 11'b00000_000000;
  parameter increment_i             = 11'b00001_000000;
  parameter update_address_i        = 11'b00010_000000;
  parameter fetch_mem_i             = 11'b00011_001000;
  parameter fetch_mem_i_wait        = 11'b00100_001000;
  parameter update_j                = 11'b00101_000000;
  parameter update_address_j        = 11'b00110_000000;
  parameter fetch_mem_j             = 11'b00111_010000;
  parameter fetch_mem_j_wait        = 11'b01000_010000;
  parameter update_data_j           = 11'b01001_000000;
  parameter write_mem_j             = 11'b01010_000010;
  parameter write_mem_j_wait        = 11'b01011_000010;
  parameter update_data_i           = 11'b01100_000000;
  parameter write_mem_i             = 11'b01101_000010;
  parameter write_mem_i_wait        = 11'b01110_000010;
  parameter update_address_f        = 11'b01111_000000;
  parameter fetch_mem_f             = 11'b10000_100000;
  parameter fetch_mem_f_wait        = 11'b10001_100000;
  parameter fetch_data_encrypt      = 11'b10010_000000;
  parameter fetch_data_encrypt_wait = 11'b10011_000000;
  parameter update_data_decrypt     = 11'b10100_000000;
  parameter write_mem_decrypt       = 11'b10101_000100;
  // parameter write_mem_decrypt_wait  = 11'b10110_000100;
  parameter increment_k             = 11'b10111_000000;
  parameter finish                  = 11'b11000_000001;

  reg [10:0] state = idle;

  assign finished = state[0]; // Finished signal
  assign wen      = state[1]; // Write enable 
  assign wren_d   = state[2];   
  assign s_i_en   = state[3]; // Enable signal for s_i register
  assign s_j_en   = state[4]; // Enable signal for s_j register
  assign f_en     = state[5]; // Enable signal for f register

  // assign address_d = k[4:0];
  // assign address_m = k[4:0];

  always_ff @(posedge clk) begin
    if (s_i_en) s_i <= q;
    if (s_j_en) s_j <= q;
    if (f_en) f <= q;
  end

  always_ff @(posedge clk) begin
    case (state)
      idle: begin
        if (start) begin
          state <= increment_i;
          i <= 0;
          j <= 0;
          k <= 0;
        end
      end

      increment_i: begin
        i <= i + 1;
        address_d <= k;
        address_m <= k;
        state <= update_address_i;
      end

      update_address_i: begin
        address <= i;
        state <= fetch_mem_i;
      end

      fetch_mem_i: state <= fetch_mem_i_wait;
      
      fetch_mem_i_wait: state <= update_j;
      
      update_j: begin
        j <= j + s_i;
        state <= update_address_j;
      end

      update_address_j: begin
        address <= j;
        state <= fetch_mem_j;
      end

      fetch_mem_j: state <= fetch_mem_j_wait;

      fetch_mem_j_wait: state <= update_data_j;

      //swap start
      update_data_j: begin
        address <= j;
        data <= s_i;
        state <= write_mem_j;
      end

      write_mem_j: state <= write_mem_j_wait;

      write_mem_j_wait: state <= update_data_i;

      update_data_i: begin
        address <= i;
        data <= s_j;
        state <= write_mem_i;
      end

      write_mem_i: state <= write_mem_i_wait;

      write_mem_i_wait: state <= update_address_f;
      //swap end

      update_address_f: begin
        address <= s_i + s_j;
        state <= fetch_mem_f;
      end

      fetch_mem_f: state <= fetch_mem_f_wait;

      fetch_mem_f_wait: state <= fetch_data_encrypt;

      fetch_data_encrypt: state <= fetch_data_encrypt_wait;

      fetch_data_encrypt_wait: state <= update_data_decrypt;

      update_data_decrypt: begin
        data_d <= f ^ q_m;
        state <= write_mem_decrypt;
      end

      write_mem_decrypt: state <= increment_k;

      increment_k: begin
        if (k == (message_length - 8'b1)) state <= finish;
        else begin
          k <= k + 1;
          state <= increment_i;
        end
      end        

      finish: state <= idle;
    endcase
  end
endmodule
