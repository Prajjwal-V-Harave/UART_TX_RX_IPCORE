# UART_TX_RX_IPCORE

Project Description

This project implements a UART (Universal Asynchronous Receiver/Transmitter) TX/RX IP core using SystemVerilog RTL. The design supports standard 8-N-1 UART communication, consisting of one start bit, eight data bits, no parity bit, and one stop bit.

The UART is divided into two independent RTL modules: a transmitter and a receiver. Both modules use finite state machines (FSMs) to control the transmission and reception process. The transmitter converts parallel 8-bit data into a serial UART stream, while the receiver detects the start bit, samples the incoming serial data, reconstructs the 8-bit word, and generates a rx_valid indication when a complete byte has been received.

The design uses a parameterized CLKS_PER_BIT value to control the timing of each UART bit, making the implementation adaptable to different clock-to-bit timing requirements.

Key Features
8-bit UART data transmission and reception
Standard 8-N-1 UART frame format
Independent TX and RX FSMs
Start-bit and stop-bit handling
LSB-first serial data transmission
Parameterized CLKS_PER_BIT timing
Bit and clock counters for serial data control
Loopback-based functional verification
VCD waveform generation for simulation analysis
Verification

The design was verified using a SystemVerilog testbench with Verilator. A loopback configuration was used in which the UART transmitter output was directly connected to the receiver input.

Two independent test patterns were transmitted:

0xA5
0x3C

Both values were successfully reconstructed by the receiver, confirming correct end-to-end UART functionality. Internal FSM states, bit counters, clock counters, TX/RX signals, and received data were analyzed using EPWave.

Tools Used
SystemVerilog
Verilator 5.044
EPWave
EDA Playground
Project Structure
UART-TX-RX-IP-Core/
│
├── README.md
│
├── rtl/
│   └── design.sv
│
├── testbench/
│   └── testbench.sv
│
├── simulation/
│   ├── uart.vcd
│   ├── verilator_output.png
│   ├── detailed_fsm_waveform.png
│   └── overall_loopback_waveform.png
│
└── docs/
    └── UART_TX_RX_IP_Core_Internship_Project.pptx
Learning Outcomes

This project provided practical experience in RTL design, finite-state machine implementation, synchronous digital design, serial communication protocols, functional verification, simulation, and waveform-based debugging.
