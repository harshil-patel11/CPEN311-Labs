# Simple-iPod

[This was done as a lab for CPEN 311 - Digital Systems Design]

- A simple-ipod (audio controller) written in System Verilog that reads a song from flash memory on the DE1-SOC.
- Allows for the following capability: Play, pause, play backwards, increase/decrease speed
- Can be controlled by connecting a PS2 Keyboard once the .sof file is loaded onto the DE1-SOC (look at keyboard_audio_controller.sv for controls)

## Main Components:

The main components include 3 different Finite State Machines (FSMs) that work together to perform the following tasks:

- The FSM in keyboard_audio_controller.sv is used to control the behaviour in which audio is read from flash and output (forward, backward, pause, play, etc.)
- The FSM in address_calc.sv is used to calculate the next address from flash memory
- The FSM in flash_control.sv is used to read the audio data from the flash memory based on the address calculated by the address_calc FSM

## Additional Info:

- Verilog code, testbenches and Quartus output files including .sof, .qpf files can be found in the /rtl folder
- Files related to simulations can be found in the /sim folder
- Any additional screenshots can be found in the /doc folder
- A README.pdf can also be found in the root directory that contains results and explanations of simulations/SignalTap outputs
