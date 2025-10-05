package signals_def;

  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 32;

  // Request/control signals — from master to slave
  typedef struct packed {
    bit [ADDR_WIDTH -1 : 0]    paddr;
    bit [3             : 0]    pprot;
    bit                        pnse;
    bit                        pselx;
    bit                        penable;
    bit                        pwrite;
    bit [DATA_WIDTH -1 : 0]    pwdata;
    bit [DATA_WIDTH/8 -1 : 0]  pstrb;
    bit                        pwakeup;
  } req_ctrl_sigs;

  // Completion signals — from slave to master
  typedef struct packed {
    bit [DATA_WIDTH -1 : 0]  prdata;
    bit                      pready;
    bit                      pslverr;
  } completer_ctrl_sigs;

endpackage
