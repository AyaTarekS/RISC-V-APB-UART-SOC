package apb_pkg;
    parameter int APB_SLAVES = 4;
    parameter int APB_SEL_BITS = $clog2(APB_SLAVES);
    parameter int APB_STATES_BITS = 2;
    parameter int APB_DATA_WIDTH = 32;
    parameter int APB_ADDRESS = 32; 
    parameter int APB_DATA_BYTES = APB_DATA_WIDTH/8;
    parameter int PROTECTION_BITS = 2;
    parameter int UART_IDX = 0;
    parameter int WATCHDOG_IDX = 1;
    parameter int TIMER_IDX = 2;
    typedef enum logic [APB_STATES_BITS-1:0] { IDLE, SETUP, ACCESS } state_t;
    typedef logic [APB_DATA_WIDTH-1:0] word_t;
    
endpackage