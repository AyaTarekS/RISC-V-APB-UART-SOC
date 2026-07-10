import UART_pkg::*;

package uart_tasks_pkg;

    UART_pkg::data_t data_to_send [16]={'h55, 'hAA, 'hFF, 'h00, 'h0F, 'hF0, 'h33, 'hCC, 'h5A, 'hA5, 'h3C, 'hC3, 'h78, 'h87, 'h1E, 'hE1};
    int correct_data_count , error_data_count;


    // Write data task
    task automatic uart_write_data(
        const ref  logic clk,
        const ref rst_n,
        input  UART_pkg::data_t data,
        const ref  logic o_tx_done,
        ref logic i_tx_start,
        ref UART_pkg::data_t i_tx_din
    );
        $display("Before the clk to write the data");
        @(posedge clk);
        $display("After the clk to write the data");
        i_tx_din   = data;
        $display("After assigning the data");
        i_tx_start = 1'b1;
        $display("After the assiging of the start");
        wait(o_tx_done == 1'b1);
    endtask


    // Read data task
    task automatic uart_read_data(
        const ref clk,
        const ref rst_n,
        const ref  UART_pkg::data_t o_rx_dout,
        const ref  logic o_rx_done,
        input  UART_pkg::data_t expected_data
    );
        $display("Before the clk to read the data");
        wait(o_rx_done == 1'b1);
        $display("Comparing the data");
        if (o_rx_dout === expected_data) begin
            $display("UART RX: Received data matches expected data: %0h", o_rx_dout);
            correct_data_count++;
        end else begin
            $display("UART RX: Mismatch. Received: %0h, Expected: %0h", o_rx_dout, expected_data);
            error_data_count++;
        end
    endtask


    // Configure task
    task uart_configure(
        input  real clk_period,
        input  int   baud_rate,
        output logic [UART_pkg::BAUD_RATE_BITS-1:0]   final_value
    );
        // Example assumes 8 MHz clock
        real calculated_final_value;
        calculated_final_value = (1.0 / (16 * baud_rate * clk_period)) - 1;
        final_value = $rtoi(calculated_final_value);
        $display("UART Configured: Baud Rate = %0d, Final Value = %0d", baud_rate, final_value);
    endtask


    // Reset task
    task automatic uart_reset(
        const ref  logic clk,
        output logic rst_n
    );
        rst_n = 1'b0;
        @(posedge clk);
        @(posedge clk);
        rst_n = 1'b1;
        $display("UART Reset: Reset signal asserted and deasserted.");
    endtask

    function report_results();
        $display("UART Test Results: Correct Data Count = %0d, Error Data Count = %0d", correct_data_count, error_data_count);
    endfunction

endpackage


