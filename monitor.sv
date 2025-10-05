class apb_mon extends uvm_monitor;
  `uvm_component_utils(apb_mon)
  
  uvm_analysis_port #(apb_seq_item) ap;
  apb_seq_item rsp;
  virtual ctrl_sigs_intf ctrl_sigs;
    
  function new(string name="apb_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
  
  
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual ctrl_sigs_intf)::get(null,"*","ctrl_sigs", ctrl_sigs))
      `uvm_fatal("apb_mon","Failed to get interface");
    
    ap = new("monitor_ap", this);
    rsp = apb_seq_item::type_id::create("rsp");
    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge ctrl_sigs.pclk);
      if(ctrl_sigs.penable == 1 && ctrl_sigs.comp_sigs.pready == 1 && ctrl_sigs.preset == 1) begin
		rsp.req_sigs = ctrl_sigs.req_sigs;        
        rsp.comp_sigs = ctrl_sigs.comp_sigs;
        ap.write(rsp);
      end
        
    end
  endtask
  
  
endclass