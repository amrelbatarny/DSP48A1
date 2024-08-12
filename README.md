# DSP48A1 Block RTL Design

This repository contains the RTL design, verification environment, and documentation for the DSP48A1 Block implemented using Verilog.

## Architecture
![DSP48A1-Slice](Documentation/DSP48A1-Slice.png)

## Repository Structure

```
│   DSP.xdc
│
├───Documentation
│       Documentation.docx
│       Documentation.pdf
│
├───RTL
│       DSP48A1.v
│       registered.v
│
└───Verification
        DSP48A1_tb.v                                                                                                                                                                
        run_DSP48A1.do
        src_files.list
```

## Overview

The DSP48A1 block is a highly configurable DSP block used in various digital signal processing applications. This project includes the RTL design of the DSP48A1 block, along with the necessary verification files to test its functionality.

## Files Description

### RTL
- `DSP48A1.v`: The main Verilog module for the DSP48A1 block.
- `registered.v`: A helper module used for registered inputs and outputs.

### Verification
- `DSP48A1_tb.v`: The testbench for verifying the functionality of the DSP48A1 block.
- `run_DSP48A1.do`: The script to run the simulation.
- `src_files.list`: A list of source files required for the simulation.

### Documentation
- `Documentation.docx`: Detailed documentation of the DSP48A1 block design and implementation.
- `Documentation.pdf`: PDF version of the detailed documentation.

## DSP48A1 Module

The DSP48A1 block is designed with various configurable parameters and handles multiple operations, including addition, subtraction, and multiplication. It also supports various pipeline stages for inputs and outputs.

### Parameters
- `A0REG`, `A1REG`, `B0REG`, `B1REG`: Registers for input operands.
- `CREG`, `DREG`, `MREG`, `PREG`: Registers for intermediate and final results.
- `CARRYINREG`, `CARRYOUTREG`, `OPMODEREG`: Registers for control signals.
- `CARRYINSEL`, `B_INPUT`, `RSTTYPE`: Configuration options for carry-in selection, B input source, and reset type.

### Ports
- **Inputs**:
  - `A`, `B`, `D`: 18-bit input operands.
  - `C`: 48-bit input operand.
  - `OPMODE`: 8-bit operation mode.
  - `BCIN`, `PCIN`: Cascade inputs.
  - `CLK`: Clock signal.
  - `CARRYIN`: Carry-in input.
  - `RSTA`, `RSTB`, `RSTC`, `RSTCARRYIN`, `RSTD`, `RSTM`, `RSTOPMODE`, `RSTP`: Reset signals.
  - `CEA`, `CEB`, `CEC`, `CECARRYIN`, `CED`, `CEM`, `CEOPMODE`, `CEP`: Clock enable signals.

- **Outputs**:
  - `BCOUT`: 18-bit cascade output.
  - `PCOUT`: 48-bit cascade output.
  - `P`: 48-bit final result.
  - `M`: 36-bit intermediate result.
  - `CARRYOUT`, `CARRYOUTF`: Carry-out signals.

## Usage

### Prerequisites

- ModelSim/QuestaSim for simulation
- Vivado/Quartus Prime for synthesis, place-and-route, and timing analysis

### Running Simulations

1. Clone the repository by typing the following command in your terminal
```bash
git clone https://github.com/amrelbatarny/DSP48A1
```
2. Open ModelSim/QuestaSim

3. From the `File` menu, click on `Change directory` and navigate to the `Verification` directory

4. From the `Transcript` window run the following TCL command to run the script file
```tcl
do run_DSP48A1.do
```


## Further Resources

The included documentation provides a detailed explanation of the design and implementation process (refer to `Documentation` / `Documentation.pdf`).

## Contribution

We welcome contributions to this educational project. Feel free to submit pull requests for improvements or additional features.

## Contact

Click on the image below

<a href="https://beacons.ai/amrelbatarny" target="_blank">
  <img align="left" alt="Beacons" width="180px" src="https://www.colormango.com/development/boxshot/beacons-ai_154511.png" />
</a> 
<br>

