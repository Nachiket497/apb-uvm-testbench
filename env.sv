
`include "agent.sv"
`include "scoreboard.sv"

class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agnt  agnt;
  apb_scb   scb;
  
  function new(string name="apb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt = apb_agnt::type_id::create("agnt", this);
    scb = apb_scb::type_id::create("scb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnt.mon.ap.connect(scb.ap);
  endfunction
  
  
  
endclass