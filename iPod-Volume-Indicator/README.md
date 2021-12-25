# iPod-Volume-Indicator

[This was done as a lab for CPEN 311 - Digital Systems Design]

- A continuation of the [Simple-iPod](https://github.com/harshil-patel11/Simple-iPod.git) project.
- Added functionality of a volume strength indicator on the DE1-SOC.
- Added additional LED functionality on the DE1-SOC.

## Main Components:

The main components include the top level file simple_ipod.sv and other files written in PicoBlaze Assembly (pracPICO.psm):

- The Interrupt Service Routine (ISR) in the PicoBlaze Assembly file is used for averaging the strength of the audio and then display it on the LED[9:2] on the FPGA
- Code was also written to turn LED0 on and off every 1 second

## Additional Info:

- Verilog code, testbenches and Quartus output files including .sof, .qpf files can be found in the /rtl folder
- Files related to simulations can be found in the /sim folder
- Any additional screenshots can be found in the /doc folder
- A README.pdf can also be found in the root directory that contains results and explanations of simulations/SignalTap outputs
