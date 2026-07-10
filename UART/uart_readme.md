# UART Core README

## Overview
This UART block provides asynchronous serial communication for the RISC-V APB UART SoC. It is used to transmit and receive one byte at a time over a simple two-wire interface, making it suitable for console output, debug logs, and low-speed peripheral communication.

## Standard Parameters Chosen for This Design
The UART implementation is configured with the following standard serial settings:

- Data width: 8 bits
- Start bit: 1
- Stop bits: 1
- Parity: none
- Baud rate: 9600 bps
- Oversampling factor: 16x
- Bit order: LSB first
- Clock used in the testbench: 8 MHz

These values are defined in the UART package and are used by both the transmitter and receiver modules.

## UART Frame Format
Each byte is sent as a standard UART frame:

1. Start bit = 0
2. 8 data bits
3. Stop bit = 1

This means every transmitted byte requires 10 bit periods on the wire.

## What the UART Does
The UART core performs three main functions:

### 1. Transmit path (TX)
- Accepts a byte from the system
- Sends it bit by bit with the correct timing
- Adds the start and stop bits automatically
- Signals when transmission is complete

### 2. Receive path (RX)
- Monitors the RX input line
- Detects the start bit
- Samples the incoming bits at the correct baud rate
- Reconstructs the received byte
- Signals when reception is complete

### 3. Baud generation
- Generates timing ticks based on the selected baud rate
- Ensures the transmitter and receiver stay synchronized

## Interface Summary
The UART module exposes the following key signals:

- clk: system clock
- rst_n: active-low reset
- final_value: baud-rate configuration value
- i_tx_din: input byte to transmit
- i_tx_start: start transmission command
- o_tx_done: indicates TX is finished
- o_tx_bit: serial TX output bit
- i_rx_bit: serial RX input bit
- o_rx_dout: received byte
- o_rx_done: indicates RX is finished

## Role in the RISC-V SoC
The UART is an important peripheral in a RISC-V-based system because it gives the processor a simple way to talk to the outside world.

### Impact on the SoC
- Enables serial debugging and software print messages
- Allows communication with a host PC or terminal
- Provides a low-cost and low-pin-count interface
- Makes firmware bring-up and testing much easier
- Adds a slow but reliable communication channel for control and monitoring

### Practical effect
Although UART is not a high-speed interface, it is very useful for:
- boot logs
- debugging
- command interfaces
- simple data exchange with external devices

In a SoC, the UART usually acts as a peripheral connected to the processor through the system bus. It does not replace high-speed interfaces, but it is one of the easiest ways to observe and control the system during development.

## Notes
The current RTL uses a simple baud-rate generator and a loopback-based testbench. For production-level integration, the baud configuration and timing logic should be verified carefully against the final clock frequency and target baud rate.

## Summary
The UART in this project is a compact, simple, and practical serial communication block. It provides reliable byte-level communication for the RISC-V SoC and is especially useful for debugging, monitoring, and basic external interaction.
