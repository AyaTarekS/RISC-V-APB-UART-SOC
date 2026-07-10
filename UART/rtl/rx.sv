import UART_pkg::*;
module rx(
    input logic clk,
    input logic rst_n,
    input logic i_rx_bit,
    input logic i_s_tick,
    output data_t o_rx_dout,
    output logic o_rx_done
    );
    
    logic  [S_TICKS_WIDTH-1:0] s_tick_r;
    data_t data_r;
    logic [ADDR_WIDTH-1:0] bit_count_r;

    logic [S_TICKS_WIDTH-1:0] s_tick_next;
    data_t data_next;
    logic [ADDR_WIDTH-1:0] bit_count_next;


    state_t state, next_state;

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
        o_rx_done = 1'b0;
        o_rx_dout = data_r;

        case (state)
            IDLE: begin
                if (i_rx_bit == 1'b0)begin
                    next_state = START;
                    s_tick_next = 0;
                end
            end
            START: begin 
                if(i_s_tick == 1)begin
                    if(s_tick_r == MID_OVERSAMPLE - 1)begin
                        next_state = DATA;
                        s_tick_next = 0;
                        bit_count_next= 0;
                    end else begin
                        s_tick_next = s_tick_r + 1;
                    end
                end
            end
            DATA: begin
                if(i_s_tick == 1)begin
                    if(s_tick_r == S_TICKS - 1)begin
                        s_tick_next = 0;
                        data_next ={ i_rx_bit, data_r[DATA_WIDTH - 1:1] };
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
                if(i_s_tick == 1)begin
                    if(s_tick_r == SB_TICKS - 1)begin
                        s_tick_next = 0;
                        next_state = IDLE;
                        o_rx_done = 1'b1;
                        o_rx_dout = data_r;
                    end else begin
                        s_tick_next = s_tick_r + 1;
                    end
                end
            end
        endcase
    end

endmodule