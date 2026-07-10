package UART_pkg;
    parameter int DATA_WIDTH = 8;
    parameter int STOP_BITS = 1;
    parameter int PARITY_BITS = 0;
    parameter int S_TICKS = 16;
    parameter int S_TICKS_WIDTH = $clog2(S_TICKS);
    parameter int SB_TICKS = S_TICKS * STOP_BITS;
    parameter int ADDR_WIDTH = $clog2(DATA_WIDTH);

    parameter int MID_OVERSAMPLE = S_TICKS / 2;


    parameter int BAUD_RATE_BITS = 8;
    parameter int BAUD_RATE = 9600;
    parameter real CLK_PERIOD = 125e-9; // 8 MHz clock period in seconds
    parameter real HALF_CLK_PERIOD = 62.5; // 62.5 ns for 16 MHz

    typedef logic [DATA_WIDTH-1:0] data_t;
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b10,
        STOP = 2'b11
    } state_t;
endpackage