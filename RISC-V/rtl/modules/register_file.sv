import risc_pkg::*;
module register_file(
    input logic CLK,
    input reg_add_t A1,
    input reg_add_t A2,
    input reg_add_t A3,
    input logic WE3,
    input word_t WD3,
    output word_t RD1,
    output word_t RD2
);
    word_t registers [REGISTERS_NUM]; 
    //READ OPERATION COMBINATIONALLY
    always_comb begin
        RD1 = registers[A1];
        RD2 = registers[A2];
    end
    //WRITE OPERATION SEQUENTIALLY
    always_ff @(posedge CLK) begin
        if(WE3)
            registers [A3] = WD3;
    end
    
    
endmodule
