timeunit 1ns/1ps;

module uart_tb;
import UART_pkg::*;
import uart_tasks_pkg::*;

    logic clk;
    logic rst_n;
    logic [BAUD_RATE_BITS-1:0] final_value;
    data_t i_tx_din;
    logic i_tx_start;
    logic o_tx_done;    
    logic o_tx_bit;
    logic i_rx_bit;
    data_t o_rx_dout;
    logic o_rx_done;



    assign i_rx_bit = o_tx_bit; // Loopback for testing

initial begin
    clk = 0;
    forever begin
        #HALF_CLK_PERIOD;
        clk = ~clk; // 8MHz clock
    end 
end

uart uart_inst(
    .clk(clk),
    .rst_n(rst_n),
    .final_value(final_value),
    .i_tx_din(i_tx_din),
    .i_tx_start(i_tx_start),
    .o_tx_done(o_tx_done),
    .o_tx_bit(o_tx_bit),
    .i_rx_bit(i_rx_bit),
    .o_rx_dout(o_rx_dout),
    .o_rx_done(o_rx_done)
);

initial begin
    // Configure the UART with a baud rate of 9600
    uart_configure(CLK_PERIOD, BAUD_RATE, final_value);
    $display("Configuration Done ! Before Reset");
    // Reset the UART
    //tasks.uart_reset(clk, rst_n);
    rst_n = 1'b0;
    repeat(2) @(posedge clk);
    rst_n = 1'b1;

    $display("RESET Done!");

    //Write data to the UART
    foreach (uart_tasks_pkg::data_to_send[i]) begin
        uart_write_data(clk, rst_n ,uart_tasks_pkg::data_to_send[i],o_tx_done,i_tx_start,i_tx_din);
        uart_read_data(clk,rst_n,o_rx_dout,o_rx_done,uart_tasks_pkg::data_to_send[i]);
   end

    uart_write_data(clk, rst_n ,8'hAA,o_tx_done,i_tx_start,i_tx_din);
    uart_read_data(clk,rst_n,o_rx_dout,o_rx_done,8'hAA);

    //Report test results
    report_results();

    $finish;
end


endmodule

