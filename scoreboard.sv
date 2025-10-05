
class apb_scb extends uvm_scoreboard;
  `uvm_component_utils(apb_scb)
  
  uvm_analysis_imp  #(apb_seq_item, apb_scb) ap;
  apb_seq_item rsp;
  
  logic [DATA_WIDTH -1 : 0] mem [*];
  
  
  
  function new(string name="apb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("scoreboard_ap", this);
    rsp = apb_seq_item::type_id::create("rsp");
  endfunction
  
  task write(apb_seq_item rsp);
    
//     `uvm_info("scorebard", "Inside write method",UVM_LOW)
    
    if(rsp.req_sigs.pwrite == 1) begin
      `uvm_info("scorebard", "Writing data to mem", UVM_LOW)
      mem[rsp.req_sigs.paddr] = rsp.req_sigs.pwdata;
    end
    else  begin
      if(mem[rsp.req_sigs.paddr] == rsp.comp_sigs.prdata) begin
        `uvm_info("scorebard", "Got the correct data", UVM_LOW)
        `uvm_info("APB_SEQ", $sformatf("WRITE: addr=0x%0h, data=0x%0h, pwrite=%0b",
                                   rsp.req_sigs.paddr, rsp.comp_sigs.prdata, rsp.req_sigs.pwrite),
                                   UVM_MEDIUM)
      end
      else begin
        `uvm_error("scoreboard", "Read & Write data is not matching")
      end
    end
    
//     `uvm_info("scorebard", "EXiting write method",UVM_LOW)
  endtask
  
  
  
endclass