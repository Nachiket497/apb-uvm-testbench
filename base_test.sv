
`include "seq_item.sv"
`include "env.sv"
`include "apb_write_seq.sv"
`include "apb_read_seq.sv"


class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  apb_env env;
  apb_write_seq wseq;
  apb_read_seq  rseq;
  
  function new(string name = "base_test", uvm_component parent=null);
    super.new(name, parent);
    
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = apb_env::type_id::create("apb_env", this);
    wseq = apb_write_seq::type_id::create("wseq");    
    rseq = apb_read_seq::type_id::create("rseq");

  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    phase.raise_objection(this);
    
    @(posedge test_top.reset)
    `uvm_info("base_test", "Inside run phase of base test", UVM_LOW)
    wseq.start(env.agnt.seqr);
        
    rseq.start(env.agnt.seqr);

    
    #10ns;
    phase.drop_objection(this);
    
  endtask
  
endclass