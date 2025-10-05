class apb_drv extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_drv)
  
  virtual ctrl_sigs_intf ctrl_sigs;
  apb_seq_item req;
  apb_seq_item empty_req;
    
  function new(string name="apb_agnt", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
  
      
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual ctrl_sigs_intf)::get(null,"*","ctrl_sigs", ctrl_sigs))
      `uvm_fatal("apb_driver","Failed to get interface");
    
    empty_req = apb_seq_item::type_id::create("empty_req");
    
  endfunction
      
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      @(ctrl_sigs.cb)
      ctrl_sigs.cb.req_sigs <= req.req_sigs;
              
      @(ctrl_sigs.cb)
      	ctrl_sigs.penable <= 1;
      
      while(!ctrl_sigs.comp_sigs.pready)
        @(ctrl_sigs.cb);
        
      @(ctrl_sigs.cb)
      	ctrl_sigs.penable <= 0;
        ctrl_sigs.req_sigs <= empty_req.req_sigs;

      seq_item_port.item_done();
    end
    
  endtask
  
endclass
