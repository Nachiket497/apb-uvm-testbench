
`include "driver.sv"
`include "monitor.sv"
`include "sequencer.sv"


class apb_agnt extends uvm_agent;
  `uvm_component_utils(apb_agnt)
    
  apb_drv drv;
  apb_mon mon;
  apb_seqr seqr;
  
  function new(string name="apb_agnt", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = apb_drv::type_id::create("drv", this);
    mon = apb_mon::type_id::create("mon", this);
    seqr = apb_seqr::type_id::create("seqr", this);

  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass