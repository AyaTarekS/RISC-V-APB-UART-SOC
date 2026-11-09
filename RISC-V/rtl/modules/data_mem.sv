import risc_pkg::*;
module data_mem(
    input logic CLK,
    input logic WE,
    input word_t A,
    input word_t WD,
    output word_t RD
);
//TODO: CHECK THE SIZE OF THE DATA MEMORY
    word_t data [1000];
    always_ff @(posedge CLK) begin
        if(WE) 
            data[A] = WD;
    end
    always_comb begin
        if(!WE)
            RD = data[A];
    end
    
    
endmodule