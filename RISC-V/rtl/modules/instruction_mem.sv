import risc_pkg::*;
module instruction_mem(
    input word_t A,
    output word_t RD
);
    //TODO: CHECK THE SIZE OF THE INSTRUCTION MEM
    word_t instr_mem [1000:0];
    always_comb begin
        RD = instr_mem[A]; //reading combinationaly
    end
endmodule