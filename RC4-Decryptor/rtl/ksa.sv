module ksa (CLOCK_50, KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
  input logic CLOCK_50;
  input logic [3:0] KEY;
  input logic [9:0] SW;
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output reg [9:0] LEDR = 0;

  wire reset = ~KEY[3];
  wire start = ~KEY[0];
  reg [23:0] secret_key; 

  logic wen;
  logic [7:0] address, data, q;
  s_memory WorkingMemoryRAM ( .address(address),
                              .clock(CLOCK_50),
                              .data(data),
                              .wren(wen),
                              .q(q)
                              );

  logic wren_d;
  logic [4:0] address_d; 
  logic [7:0] data_d, q_d;
  d_memory DecryptedMessageRAM (.address(address_d),
                                .clock(CLOCK_50),
                                .data(data_d),
                                .wren(wren_d),
                                .q(q_d)
                                );   

  logic [4:0] address_m;
  logic [7:0] q_m;
  e_memory EncryptedMessageROM (.address(address_m),
                                .clock(CLOCK_50),
                                .q(q_m)
                                );                                                       

  logic start_init_mem_fsm, init_mem_fsm_finished, wen1;
  logic [7:0] address1, data1;
  init_mem FSM1 ( .clk(CLOCK_50), 
                  .start(start_init_mem_fsm), 
                  .wen(wen1),
                  .data(data1), 
                  .address(address1), 
                  .finished(init_mem_fsm_finished)
                  );

  logic start_task2a_fsm, task2a_fsm_finished, wen2;
  logic [7:0] address2, data2;
  task2a FSM2 ( .clk(CLOCK_50),
                .start(start_task2a_fsm),
                .secret_key(secret_key),
                .wen(wen2),
                .q(q),
                .data(data2),
                .address(address2),
                .finished(task2a_fsm_finished)
                );

  logic start_task2b_fsm, task2b_fsm_finished, wen3, wren_d3;
  logic [4:0] address_m3, address_d3;
  logic [7:0] address3, data3, data_m3, data_d3;
  task2b FSM3 ( .clk(CLOCK_50),
                .start(start_task2b_fsm),
                .secret_key(secret_key),
                .wen(wen3),
                .q(q),
                .data(data3),
                .address(address3),
                .finished(task2b_fsm_finished),
                .address_d(address_d3),
                .data_d(data_d3),
                .wren_d(wren_d3),
                .q_m(q_m),
                .address_m(address_m3)
                );    

  logic start_task3_fsm, task3_error, task3_fsm_finished;
  logic [4:0] address_d4;
  task3 FSM4 (.clk(CLOCK_50),
              .start(start_task3_fsm),
              .address_d(address_d4),
              .q_d(q_d),
              .error(task3_error),
              .finished(task3_fsm_finished)
              );                        

  always_comb begin
    //make a 2 select input multiplexer
    case(fsm_signal_select) 
      4'b0001: begin
        wen = wen1;
        data = data1;
        address = address1;
        address_d = 0;
        data_d = 0;
        wren_d = 0;
        address_m = 0;
      end
      
      4'b0010: begin
        wen = wen2;
        data = data2;
        address = address2;
        address_d = 0;
        data_d = 0;
        wren_d = 0;
        address_m = 0;
      end

      4'b0100: begin
        wen = wen3;
        data = data3;
        address = address3;
        address_d = address_d3;
        data_d = data_d3;
        wren_d = wren_d3;
        address_m = address_m3;
      end

      4'b1000: begin
        wen = 0;
        data = 0;
        address = 0;
        address_d = address_d4;
        data_d = 0;
        wren_d = 0;
        address_m = 0;
      end
      
      default: begin
        wen = 0;
        data = 0;
        address = 0;
        address_d = 0;
        data_d = 0;
        wren_d = 0;
        address_m = 0;
      end
    endcase
  end             

  parameter check_start               = 12'b0000_0000_0000;
  parameter run_init_mem              = 12'b0001_0001_0001;        
  parameter wait_for_finish_init_mem  = 12'b0010_0001_0000; 
  parameter run_task2a                = 12'b0011_0010_0010;        
  parameter wait_for_finish_task2a    = 12'b0100_0010_0000; 
  parameter run_task2b                = 12'b0101_0100_0100;
  parameter wait_for_finish_task2b    = 12'b0110_0100_0000;
  parameter run_task3                 = 12'b0111_1000_1000;
  parameter wait_for_finish_task3     = 12'b1000_1000_0000;
  parameter increment_secret_key      = 12'b1001_0000_0000;
  parameter finish                    = 12'b1010_0000_0000; 

  logic [3:0] fsm_signal_select, start_target_fsm;
  reg [11:0] state = check_start;

  assign fsm_signal_select = state[7:4];
  assign start_target_fsm = state[3:0];
  assign start_init_mem_fsm = start_target_fsm[0];
  assign start_task2a_fsm = start_target_fsm[1];
  assign start_task2b_fsm = start_target_fsm[2];
  assign start_task3_fsm  = start_target_fsm[3];
  
  always_ff @(posedge CLOCK_50) begin
    if (reset) begin
      state <= check_start;
      secret_key <= 0;
    end
    else begin
      case(state)
        check_start: if (start) begin
          // secret_key <= {{14{1'b0}}, SW[9:0]};
          secret_key <= 0;
          state <= run_init_mem;
        end

        run_init_mem: state <= wait_for_finish_init_mem;

        wait_for_finish_init_mem: if (init_mem_fsm_finished) begin
          state <= run_task2a;
        end

        run_task2a: state <= wait_for_finish_task2a;

        wait_for_finish_task2a: if (task2a_fsm_finished) begin
          state <= run_task2b;
        end

        run_task2b: state <= wait_for_finish_task2b;

        wait_for_finish_task2b: if (task2b_fsm_finished) begin
          state <= run_task3;
        end

        run_task3: state <= wait_for_finish_task3;

        wait_for_finish_task3: if (task3_fsm_finished) begin
          if (task3_error) begin
            state <= increment_secret_key;
            LEDR <= 10'b10;
          end
          else begin
            state <= finish;
            LEDR <= 10'b1;
          end
        end

        increment_secret_key: begin
          if (secret_key == 24'h3F_FFFF) begin
            state <= finish;
          end
          else begin
            secret_key <= secret_key + 1;
            state <= run_init_mem;
          end
        end

        finish: state <= check_start;
      endcase
    end
  end

  SevenSegmentDisplayDecoder hex0 (.ssOut(HEX0), .nIn(secret_key[3:0]));
  SevenSegmentDisplayDecoder hex1 (.ssOut(HEX1), .nIn(secret_key[7:4]));
  SevenSegmentDisplayDecoder hex2 (.ssOut(HEX2), .nIn(secret_key[11:8]));
  SevenSegmentDisplayDecoder hex3 (.ssOut(HEX3), .nIn(secret_key[15:12]));
  SevenSegmentDisplayDecoder hex4 (.ssOut(HEX4), .nIn(secret_key[19:16]));
  SevenSegmentDisplayDecoder hex5 (.ssOut(HEX5), .nIn(secret_key[23:20]));
endmodule
