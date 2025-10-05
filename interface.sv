import signals_def::*;

interface ctrl_sigs_intf;
  
  bit                   pclk;
  bit                   preset;
  bit                   penable;
  req_ctrl_sigs         req_sigs;
  completer_ctrl_sigs   comp_sigs;
  
  clocking cb @(posedge pclk);
//     default input #1 output #1;
    input comp_sigs;
    output penable;
    output req_sigs;
  endclocking
  
endinterface