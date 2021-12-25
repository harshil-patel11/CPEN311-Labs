# DDS-Modulation

[This was done as a lab for CPEN 311 - Digital Systems Design]

- This project allows us to view sin/cos/saw/square signals and modulate them using a VGA output interface

## Main Components:

- Built and tested a LFSR (Linear Feedback Shift Register) module (lfsr.sv, lfsr_tb.sv)
- Instantiated the DDS (Direct Digital Synthesis) module into the top level file (dds_nios_and_qsys_lab.v). The DDS module is responsible for generating the wave that is output on the VGA
- Built and tested a module that allows us to transfer data across clock domains (clock_domain_crossing.sv)
- Used NIOS and QSYS (Embedded processor) to make 3 new PIO (Peripheral Input Ouput) modules and instantiate them in the top level without writing any verilog code for the modules
- Wrote SystemVerilog code in the top level file to allow ASK (Amplitude Shift Keying), BPSK (Binary Phase Shift Keying)
- Wrote the C code in student_code.c to allow FSK modulation (Frequency Shift Keying)

## Additional Info:

- A README.pdf can also be found in the root directory that contains results and explanations of simulations/SignalTap outputs
