/* 
The flash_ctrl module is used to interface with the Altera Flash signals in the top level module.
This is done by using the ports valid_read, wait_request, and mem_read
It receives signal inputs such as start_flash_read from the address_calc FSM and initiates the read process.
Upon finishing, it also sends the end_flash_read output signal to the address_calc to indicate that it is time to get a new address.

Similar to viterbi_ctrl (only read operations) from lectures.

States:
idle: Idle state, waits for start_flash_read signal from the address calc.

handle_read_op: In this state, we are ready to tell the flash to read but wait for it to signal to us that it is ready through mem_read.

read_ready: In this state, we make sure that wait_request from the flash is not asserted before we begin reading.

reading: In this state, we read until we get a !valid_read signal from the flash telling us that we need to finish and signal to the address calc for a new address.

finished: In this state, we indicate that we are done reading to the address calc through end_flash_read.
*/

module flash_control (clk, start_flash_read, valid_read, wait_request, mem_read, end_flash_read);

input logic clk, start_flash_read, valid_read, wait_request, mem_read;
output logic end_flash_read;

logic [3:0] state; // The state variable


                           //[ENC]_[END_FLASH_READ]
parameter idle =            4'b000_0; 
parameter handle_read_op =  4'b001_0; 
parameter read_ready =      4'b010_0;
parameter reading =         4'b011_0;
parameter finished =        4'b100_1;

assign end_flash_read = state[0];

always_ff @(posedge clk) begin
   case (state)

   idle: if (start_flash_read) state <= handle_read_op;

   handle_read_op: if (mem_read) state <= read_ready;

   read_ready: if (!wait_request) state <= reading;

   reading: if (!valid_read) state <= finished;

   finished: state <= idle;

   default: state <= idle; 
   endcase
end

endmodule
