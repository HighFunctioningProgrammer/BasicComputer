
# Basic Computer I Project

## Overview

This project implements a basic computer, referred to as Basic Computer I (BC_I), designed for educational purposes in the Computer Architecture I course at Middle East Technical University. The implementation utilizes a modular approach in Verilog, enhancing scalability and easing the debugging process. It includes a Controller unit, Datapath unit, and extensive register setup, supporting a wide range of operations from arithmetic calculations to interrupt handling.

## Key Components

- **Controller Unit**: Generates control signals for managing the flow of data and instructions within the computer.
- **Datapath Unit**: Handles data storage and arithmetic/logic operations, integrating various registers and an Arithmetic Logic Unit (ALU).
- **Memory Unit**: A 4096xWORD size memory, addressed by a 12-Bit input, capable of combinational reads and sequential writes.
- **ALU**: Supports operations like addition, AND, shift operations, complement, and data transfer.
- **Registers**: Includes multiple registers such as AC (Accumulator), PC (Program Counter), IR (Instruction Register), AR (Address Register), DR (Data Register), and a temporary register (TR), along with flags for interrupt handling and instruction control.

## Project Files

- **`BC_I.v`**: Top module connecting the Controller and Datapath units.
- **`datapath/`**: Directory containing all modules related to data handling and processing.
- **`controller/`**: Directory containing the Controller module and logic for generating control signals.
- **`test/`**: Contains testbenches written using `cocotb`, validating all aspects of the computer's functionality.

## Setup and Running

### Prerequisites

- Verilog simulation tool (e.g., Icarus Verilog or ModelSim)
- Python with `cocotb` installed for running testbenches

### Running Testbenches

Execute the testbenches using `cocotb`:
First locate the "/tests" folder in command promt then use the following script
```bash
make
```

## Documentation

Each module within the project includes in-line comments detailing its functionality. For an in-depth explanation of the system architecture and module interactions, refer to the documentation section within the codebase.
