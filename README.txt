UART TX/RX IP Core - VLSI Internship Project

Design:
- uart_tx_rx.v : UART transmitter and receiver RTL
- uart_tb.v    : Loopback verification testbench

Verification:
- Verilator 5.044
- EPWave waveform viewer
- VCD trace generation

Protocol:
- 8 data bits
- No parity
- 1 start bit
- 1 stop bit (8-N-1)
- Parameterized CLKS_PER_BIT = 10

Test cases:
- 0xA5 transmitted and received successfully
- 0x3C transmitted and received successfully
