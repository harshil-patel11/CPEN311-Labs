/*
	This module is used to provide an interface between the keyboard and the signals controlling how the audio is retrieved from flash memory. 

	The FSM has 5 states:
	decode - in this state, the fsm determines what to do next depending on the keyboard input
	forward - in this state, the song is playing in the normal direction
	stay_forward - we reach this state if the song has been paused, but was playing in the forward direction.
	backward - in this state, the song is playing in the reverse direction
	stay_backward - we reach this state if the song has been paused, but was playing in the reverse direction.
*/

// Parameters used in the module
parameter character_B =				8'h42;
parameter character_D =				8'h44;
parameter character_E =				8'h45;
parameter character_F =				8'h46;
parameter character_lowercase_b=	8'h62;
parameter character_lowercase_d= 	8'h64;
parameter character_lowercase_e= 	8'h65;
parameter character_lowercase_f= 	8'h66;

module keyboard_audio_controller(clk, key, read_ready, forward);

input logic clk;
input logic [7:0] key;
output logic read_ready, forward;

logic [4:0] state;


				// [ENC]_[FORWARD, READ_READY]
				// [5:3]_[2:0]
parameter decode = 5'b000_00; // First state, all zeros
parameter forward_state = 5'b001_11; // read_ready/forward are output high in forward to allow audio_data to be read
parameter stay_forward = 5'b010_00; // nothing to do with output
parameter backward_state = 5'b011_01; // read_ready is output high in backward to allow audio_data to be read
parameter stay_backward = 5'b100_00; // nothing to do with output

assign read_ready = state[0]; // Output this signal to indicate that it is ready to read 
assign forward = state[1]; // Outputs 1 if in forward, 0 if backward

always_ff @(posedge clk) begin
	case (state)

	decode: begin
		if (key == character_E || key == character_lowercase_e) state <= forward_state;
		else if (key == character_B || key == character_lowercase_b) state <= stay_backward;
		else if (key == character_F || key == character_lowercase_f) state <= stay_forward;
		else state <= decode;
	end

	forward_state: begin
		if (key == character_B || key == character_lowercase_b) state <= backward_state;
		else if (key == character_D || key == character_lowercase_d) state <= stay_forward;
		else state <= forward_state;
	end

	stay_forward: begin
		if (key == character_E || key == character_lowercase_e) state <= forward_state;
		else if (key == character_B || key == character_lowercase_b) state <= stay_backward;
		else state <= stay_forward;
	end

	backward_state: begin
		if (key == character_F || key == character_lowercase_f) state <= forward_state;
		else if (key == character_D || key == character_lowercase_d) state <= stay_backward;
		else state <= backward_state;
	end

	stay_backward: begin
		if (key == character_E || key == character_lowercase_e) state <= backward_state;
		else if (key == character_F || key == character_lowercase_f) state <= stay_forward;
		else state <= stay_backward;
	end

	default: state <= decode;

	endcase
end

endmodule


