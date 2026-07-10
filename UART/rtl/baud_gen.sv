// system clk = 8 MHz --> 125 Ns
// baud rate = 9600
// final value = (1/(16*9600*T))-1 ->
import UART_pkg::*;
module baud_gen
(
    input logic clk,
    input logic rst_n,
    input logic [BAUD_RATE_BITS-1:0] final_value,
    output logic done
    );

    // counter to the final value
    logic [BAUD_RATE_BITS-1:0] counter;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            if (counter == final_value) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
    assign done = (counter == final_value) ? 1'b1 : 1'b0;
endmodule