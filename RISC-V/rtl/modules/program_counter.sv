import risc_pkg::*;
module program_counter(
    input logic CLK,
    input logic rst_n,
    input word_t PcNext,
    output word_t Pc
);
    always_ff @(posedge CLK or negedge rst_n) begin
        if(!rst_n)
            Pc <= LOWEST_ADDRESS;
        else
            Pc <= PcNext;
    end
    
endmodule
