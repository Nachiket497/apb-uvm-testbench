import signals_def::*;


class apb_seq_item extends uvm_sequence_item;
  `uvm_object_utils(apb_seq_item)
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction
  
  logic                 penable;
  rand req_ctrl_sigs         req_sigs;
  completer_ctrl_sigs   comp_sigs;
  
  constraint pprot_c { req_sigs.pprot == 0;}
  constraint pnse_c  { req_sigs.pnse  == 0;}
  constraint pselx_c { req_sigs.pselx == 1;}
  constraint pwakeup_c { req_sigs.pwakeup == 1;}
  constraint pwdata_c { req_sigs.pwdata[3:0] == 0; }
  
  
endclass