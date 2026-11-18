import risc_pkg::*;
module program_counter(
    input logic CLK,
    input logic rst_n,
    input word_t PCNext,
    input logic EN,
    output word_t PC
);
    //TODO: CHECK THE ENABLE LOGIC WITH THE HAZARDS
    always_ff @(posedge CLK or negedge rst_n) begin
        if(!rst_n)
            PC <= LOWEST_ADDRESS;
        else
            if(EN)
                PC <= PCNext;
    end
    
endmodule
