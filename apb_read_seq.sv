class apb_read_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_read_seq)
  
  function new(string name = "apb_read_seq");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item req;

    `uvm_info("APB_SEQ", "Starting APB read sequence", UVM_LOW)

    // Create a new transaction
    req = apb_seq_item::type_id::create("req");
    req.randomize() with { req_sigs.paddr   == 8'h20; req_sigs.pwrite  == 1'b0; };

    // Start the transaction on the sequencer-driver port
    start_item(req);
    finish_item(req);

    // Optional debug info
    `uvm_info("APB_SEQ", $sformatf("READ: addr=0x%0h, pwrite=%0b",
                                   req.req_sigs.paddr, req.req_sigs.pwrite),
                                   UVM_MEDIUM)

    // Deassert pselx after one transfer (for single-beat read)
    `uvm_info("APB_SEQ", "Completed APB read sequence", UVM_LOW)
  endtask
  
endclass
