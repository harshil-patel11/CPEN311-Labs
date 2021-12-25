/*
The address_calc module receives inputs from the keyboard module and sends output signals to the flash_ctrl module.
It is also responsible for calculating the address of the flash that the flash_control reads from.

States:
idle: In this state, we wait for a play signal from the keyboard control in order to move to the next state

flash_read: After the flash is done being read, flash_ctrl sends end_flash_read to indicate that it needs a new address

get_even_addr: We retrieve the even (msb) addresses on the positive edge of the synced 22kHz clock

read_even_addr: We process the address that we retrieved in the previous state

get_odd_addr:We retrieve the odd (lsb) addresses on the positive edge of the synced 22kHz clock

read_odd_addr: We process the address that we retrieved in the previous state

calc_next: This state determines if we need to increment or decrement the current address depending on the forward (direction) signal

increment: In this state, we add 1'h1 to the current address while maintaining the bounds

decrement: In this state, we subtract 1'h1 from the current address while maintaining the bounds

finished: In this state, we indicate to the flash_ctrl that the data at the new flash address is ready to be read.

interrupt1: Since we need to interrupt picoblaze on every flash read, we use two interrupt states (one for even read and one for odd)

interrupt2: Since we need to interrupt picoblaze on every flash read, we use two interrupt states (one for even read and one for odd)
*/

module address_calc (clk, sync_clk, play, forward, end_flash_read, audiodata, start_flash, read, finish, byteenable, mem_addr, audio_out, interrupt);

input logic clk, sync_clk, play, forward, end_flash_read;
input logic [31:0] audiodata;
output logic start_flash, read, finish, interrupt;
output logic [3:0] byteenable;
output logic [22:0] mem_addr;
// output logic [15:0] audio_out;
output logic [7:0] audio_out;

logic [6:0] state;

parameter idle =                7'b0000_000;
parameter flash_read =          7'b0001_001;
parameter get_even_addr =       7'b0010_000;
parameter read_even_addr =      7'b0011_000;
parameter get_odd_addr =        7'b0100_000;
parameter read_odd_addr =       7'b0101_000;
parameter calc_next =           7'b0110_000;
parameter increment =           7'b0111_000;
parameter decrement =           7'b1000_000;
parameter finished =            7'b1001_010;
parameter interrupt1 =          7'b1010_100;
parameter interrupt2 =          7'b1011_100;

assign start_flash = state[0];
assign read = state[0];
assign finish = state[1];
assign interrupt = state[2];

assign byteenable = 4'b1111; // We want to read all 32 bits of the address

always_ff @(posedge clk) begin
   case(state)

   idle: if (play) state <= flash_read;

   flash_read: if (end_flash_read) state <= get_even_addr;

   get_even_addr: if (sync_clk) state <= read_even_addr; // Every posedge of the synchronized 22kHz clock.

   read_even_addr: state <= interrupt1;

   interrupt1: state <= get_odd_addr; // Need to signal interrupt to picoblaze after each flash read

   get_odd_addr: if (sync_clk) state <= read_odd_addr; // Every posedge of the synchronized 22kHz clock.

   read_odd_addr: state <= interrupt2;

   interrupt2: state <= calc_next; // Need to signal interrupt to picoblaze after each flash read

   calc_next: if (forward) state <= increment; else state <= decrement;

   increment: state <= finished;

   decrement: state <= finished;

   finished: state <= idle;

   default: state <= idle;

   endcase

end

// Output Logic
// Address Calculation without Glitches (using an extra flip flop at the output)

always_ff @(posedge clk) begin
    case(state)
    
    // For the odd (lsb) addresses, we assign the lower 16 bits and then move on to read_even_addr where we will read the upper 16 bits. If in reverse (!forward), then we assign the upper 16 bits first.
    read_odd_addr: begin
        if (forward) audio_out <= audiodata [15:8];
        else audio_out <= audiodata [31:24];
        mem_addr <= mem_addr; // When reading, we do not increment/decrement the address
    end

    // For the even (msb) addresses, we assign the upper 16 bits after arriving from the read_odd_addr state where the lower bits were read. If in reverse (!forward), then we assign the lower 16 bits first.
    read_even_addr: begin
        if (forward) audio_out <= audiodata [31:24];
        else audio_out <= audiodata [15:8];
        mem_addr <= mem_addr; // When reading, we do not increment/decrement the address
    end

    // Increment the address by 1 and maintain boundaries
    increment: if (mem_addr >= 23'h7FFFF) mem_addr <= 23'h0; else mem_addr <= mem_addr + 23'h1;

    // Decrement the address by 1 and maintain boundaries
    decrement: if (mem_addr <= 23'h0) mem_addr <= 23'h7FFFF; else mem_addr <= mem_addr - 23'h1;

    default: begin
        mem_addr <= mem_addr;
        audio_out <= audio_out;
    end 
    endcase

end

endmodule
    


