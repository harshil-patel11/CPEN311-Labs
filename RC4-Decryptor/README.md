# RC4-Decryptor

[This was done as a lab for CPEN 311 - Digital Systems Design]

- This a circuit that emulates the behaviour of the RC4-Decryptor
- It allows us to decrypt secret messages (found in the rtl/secret_messages) using brute force
- It uses a combination of Finite State Machines [FSMs] that work together to try every decryption key possible in 22 bits and checks if the decrypted message is correctly deciphered

## Main Components:

The main components include different Finite State Machines (FSMs) that work together to perform the following tasks:

- The first FSM in init_mem.sv is reponsible for initializing addresses 0-256 in the RAM memory.
- Next, the FSMs in task2a.sv/task2b.sv are responsible for decrypting the data stored in memory based on a chosen key.
- Next, the FSM in task3.sv is responsible for cycling through all possible keys to decrypt messages in given .mif test files

## Additional Info:

- Verilog code, testbenches and Quartus output files including .sof, .qpf files can be found in the /rtl folder
- Files related to simulations can be found in the /sim folder
- Any additional screenshots can be found in the /doc folder
- A README.pdf can also be found in the root directory that contains results and explanations of simulations/SignalTap outputs
