import UART_pkg::*;
module uart(
    input logic clk,
    input logic rst_n,
    // UART BAUD rate configuration
    input logic [BAUD_RATE_BITS-1:0] final_value,
    // UART TX interface
    input data_t i_tx_din,
    input logic i_tx_start,
    output logic o_tx_done,
    output logic o_tx_bit,

    // UART RX interface
    input logic i_rx_bit,
    output data_t o_rx_dout,
    output logic o_rx_done
);

logic s_tick;

// BAUD generator instance
baud_gen baud_gen_inst(
    .clk(clk),
    .rst_n(rst_n),
    .final_value(final_value),
    .done(s_tick)
);

// UART TX instance
tx tx_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_s_tick(s_tick),
    .i_tx_din(i_tx_din),
    .i_tx_start(i_tx_start),
    .o_tx_bit(o_tx_bit),
    .o_tx_done(o_tx_done)
);

rx rx_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_rx_bit(i_rx_bit),
    .i_s_tick(s_tick),
    .o_rx_dout(o_rx_dout),
    .o_rx_done(o_rx_done)
);


endmodule