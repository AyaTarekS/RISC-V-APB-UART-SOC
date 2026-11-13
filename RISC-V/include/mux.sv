import risc_pkg::*;
module mux#(parameter int INPUT_NUM = 3 , parameter int SEL_WIDTH = $clog2(INPUT_NUM))(
    input word_t mux_inp_0,
    input word_t mux_inp_1,
    input word_t mux_inp_2,
    input logic [SEL_WIDTH-1:0] sel,
    output word_t mux_out
);

    always_comb begin
        priority case (sel)
            2'b00 : mux_out = mux_inp_0;
            2'b01 : mux_out = mux_inp_1;
            2'b10 : mux_out = mux_inp_2;
        endcase
    end
    
endmodule