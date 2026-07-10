import UART_pkg::*;
module tx(
    input logic clk,
    input logic rst_n,
    input logic i_s_tick,
    input data_t i_tx_din,
    input logic i_tx_start,
    output logic o_tx_bit,
    output logic o_tx_done
    );

    state_t state, next_state;
    data_t data_r, data_next;
    logic [ADDR_WIDTH-1:0] bit_count_r, bit_count_next;
    logic [S_TICKS_WIDTH-1:0] s_tick_r, s_tick_next;

    // state register
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            state <= IDLE;
            s_tick_r <= 0;
            bit_count_r <= 0;
            data_r <= 0;
        end else begin
            state <= next_state;
            s_tick_r <= s_tick_next;
            bit_count_r <= bit_count_next;
            data_r <= data_next;
        end
    end

    // next state logic
    always_comb begin
        next_state = state;
        s_tick_next = s_tick_r;
        bit_count_next = bit_count_r;
        data_next = data_r;
        o_tx_done = 1'b0;
        o_tx_bit = 1'b1;

        case(state)
            IDLE: begin
                if(i_tx_start == 1'b1)begin
                    next_state = START;
                    s_tick_next = 0;
                    data_next = i_tx_din;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                o_tx_bit = 1'b0;
                if(i_s_tick == 1'b1)begin
                    if(s_tick_r == S_TICKS - 1)begin
                        next_state = DATA;
                        s_tick_next = 0;
                        bit_count_next = 0;
                    end else begin
                        s_tick_next = s_tick_r + 1;
                    end
                end
            end
            DATA: begin
                o_tx_bit = data_r[0];
                if(i_s_tick == 1'b1)begin
                    if(s_tick_r == S_TICKS - 1)begin
                        s_tick_next = 0;
                        data_next = {1'b0, data_r[DATA_WIDTH-1:1]};
                        if(bit_count_r == DATA_WIDTH - 1)begin
                            next_state = STOP;
                        end else begin
                            bit_count_next = bit_count_r + 1;
                        end
                    end else begin
                        s_tick_next = s_tick_r + 1;
                    end
                end
            end
            STOP: begin
                o_tx_bit = 1'b1;
                if(i_s_tick == 1'b1)begin
                    if(s_tick_r == SB_TICKS - 1)begin
                        s_tick_next = 0;
                        next_state = IDLE;
                        o_tx_done = 1'b1;
                    end else begin
                        s_tick_next = s_tick_r + 1;
                    end
                end
            end
        endcase
    end

endmodule