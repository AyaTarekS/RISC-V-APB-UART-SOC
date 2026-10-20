import apb_pkg::*;
module apb_master(
    input logic pclk,
    input logic rst_n,
    input logic transfer,
    input logic PREADY,
    input logic[APB_RDATA_WIDTH-1:0] PRDATA,
    //input logic PSLVERR,
    // from wrapper
    input logic [APB_ADDRESS-1:0] MADDR,
    input logic MWRITE,
    input logic [APB_WDATA_WIDTH-1:0] MWDATA,
    input logic [APB_WDATA_BYTES-1:0] MSTRB,
    //input logic [PROTECTION_BITS-1:0] MPROT,

    output logic [APB_SEL_BITS-1:0] PSEL,
    output logic PENABLE,
    output logic [APB_ADDRESS-1:0] PADDR,
    output logic PWRITE,
    output logic [APB_WDATA_WIDTH-1:0] PWDATA,
    output logic [APB_WDATA_BYTES-1:0] PSTRB,
    //output logic [PROTECTION_BITS-1:0] PPROT,
    //for wrapper
    output logic [APB_RDATA_WIDTH-1:0] MRDATA
    //output logic MSLVERR
);

state_t state_next , state_q;
logic [APB_SEL_BITS-1:0] PSEL_q, PSEL_next;
logic PENABLE_q, PENABLE_next;
logic [APB_ADDRESS-1:0] PADDR_q, PADDR_next;
logic PWRITE_q, PWRITE_next;
logic [APB_WDATA_WIDTH-1:0] PWDATA_q, PWDATA_next;
logic [APB_WDATA_BYTES-1:0] PSTRB_q, PSTRB_next;
//logic [PROTECTION_BITS-1:0] PPROT_q, PPROT_next;
logic [APB_RDATA_WIDTH-1:0] MRDATA_q, MRDATA_next;
//logic MSLVERR_q, MSLVERR_next;

// CURRENT STATE LOGIC
always_ff @(posedge pclk or negedge rst_n) begin
    if(!rst_n)begin
        state_q <= IDLE;
        PSEL_q <= '0;
        PENABLE_q <= '0;
        PADDR_q <= '0;
        PWRITE_q <= '0;
        PWDATA_q <= '0;
        PSTRB_q <= '0;
        //PPROT_q <= '0;
        MRDATA_q <= '0;
        //MSLVERR_q <= '0;
    end
    else begin
        state_q <= state_next;
        PSEL_q <= PSEL_next;
        PENABLE_q <= PENABLE_next;
        PADDR_q <= PADDR_next;
        PWRITE_q <= PWRITE_next;
        PWDATA_q <= PWDATA_next;
        PSTRB_q <= PSTRB_next;
        //PPROT_q <= PPROT_next;
        MRDATA_q <= MRDATA_next;
        //MSLVERR_q <= MSLVERR_next;
    end
end

// NEXT STATE LOGIC
always_comb begin 
    state_next = IDLE;
    PSEL_next = '0;
    PADDR_next = '0;
    PWRITE_next = '0;
    PWDATA_next = '0;
    PSTRB_next = '0;
    //PPROT_next = '0;
    PENABLE_next = '0;
    MRDATA_next = '0;

    priority case(state_q)
        IDLE: begin
                PENABLE_next = 1'b0;
                MRDATA_next = '0;
                PSEL_next = '0;
            if(transfer)begin
                state_next = SETUP;
                // Address Decoding
                priority case(MADDR[15:12])
                    4'h0: PSEL_next[UART_IDX]  = 1'b1;
                    4'h1: PSEL_next[WATCHDOG_IDX]  = 1'b1;
                    4'h2: PSEL_next[TIMER_IDX] = 1'b1;
                endcase

                // from RISC wrapper
                PWRITE_next = MWRITE ; 
                PWDATA_next = MWDATA;
                PADDR_next = MADDR;
                PSTRB_next = MSTRB;
            end
            else begin
                state_next = IDLE;
                PSEL_next[UART_IDX] = 1'b0;
                PWRITE_next = 1'b0;
                PADDR_next = '0;
                PWDATA_next = '0;
                PSTRB_next = '0;            
            end
        end
        SETUP: begin
            state_next = ACCESS; 
            PSEL_next = PSEL_q;
            PENABLE_next = 1'b1;
            PWRITE_next = PWRITE_q;
            PADDR_next = PADDR_q;
            PWDATA_next = PWDATA_q;
            PSTRB_next = PSTRB_q;
            MRDATA_next = '0;

        end
        ACCESS: begin
            if(!PREADY) begin 
                // HOLD ON ACCESS
                state_next = ACCESS;
                PSEL_next = PSEL_q;
                PENABLE_next = PENABLE_q;
                PWRITE_next = PWRITE_q ;
                PWDATA_next = PWDATA_q;
                PADDR_next = PADDR_q;
                PSTRB_next = PSTRB_q;
                MRDATA_next = '0;
            end
            else begin
                if(transfer)begin
                    state_next = SETUP;
                    PSEL_next[UART_IDX] = 1'b1;
                    PENABLE_next = 1'b0;
                    PWRITE_next = MWRITE; 
                    PWDATA_next = MWDATA;
                    PADDR_next = MADDR;
                    PSTRB_next = MSTRB;
                    if(!PWRITE_next) 
                        MRDATA_next = PRDATA;  
                    else 
                        MRDATA_next = '0;                  
                end
                else begin
                    state_next = IDLE;
                    PSEL_next[UART_IDX] = 1'b0;
                    PENABLE_next = 1'b0;
                    PWRITE_next = 1'b0;
                    PADDR_next = '0;
                    PWDATA_next = '0;
                    PSTRB_next = '0; 
                    MRDATA_next = '0; 
                end
            end
        end
    endcase
end

//OUTPUT LOGIC
assign PSEL = PSEL_q;
assign PENABLE = PENABLE_q;
assign PWRITE = PWRITE_q;
assign PADDR = PADDR_q;
assign PWDATA = PWDATA_q;
assign PSTRB = PSTRB_q;
assign MRDATA = MRDATA_q;

endmodule