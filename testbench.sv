// Code your testbench here
// or browse Examples

`include "struct.sv"
`include "interface.sv"
`include "base_test.sv"


module test_top();

  bit clk;
  bit reset;

  ctrl_sigs_intf ctrl_sigs();

  // ------------------------------------------------------------
  // DUT Instantiation
  // ------------------------------------------------------------
  apb_slave dut (
     .pclk      (ctrl_sigs.pclk)
    ,.preset    (ctrl_sigs.preset)
    ,.paddr     (ctrl_sigs.req_sigs.paddr)
    ,.pprot     (ctrl_sigs.req_sigs.pprot)
    ,.pnse      (ctrl_sigs.req_sigs.pnse)
    ,.pselx     (ctrl_sigs.req_sigs.pselx)
    ,.penable   (ctrl_sigs.penable)
    ,.pwrite    (ctrl_sigs.req_sigs.pwrite)
    ,.pwdata    (ctrl_sigs.req_sigs.pwdata)
    ,.pstrb     (ctrl_sigs.req_sigs.pstrb)
    ,.pwakeup   (ctrl_sigs.req_sigs.pwakeup)
    ,.prdata    (ctrl_sigs.comp_sigs.prdata)
    ,.pready    (ctrl_sigs.comp_sigs.pready)
    ,.pslverr   (ctrl_sigs.comp_sigs.pslverr)
  );

  // ------------------------------------------------------------
  // Clock Generation
  // ------------------------------------------------------------
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100 MHz clock (10 ns period)
  end

  // ------------------------------------------------------------
  // Reset and Simulation Control
  // ------------------------------------------------------------
  initial begin
    $display("Start of simulation");
    reset = 0;
    repeat (10) @(posedge clk);
    reset = 1;
  end

  // ------------------------------------------------------------
  // Interface Connections
  // ------------------------------------------------------------
  assign ctrl_sigs.pclk   = clk;
  assign ctrl_sigs.preset = reset;

  
  initial begin
    uvm_config_db #(virtual ctrl_sigs_intf)::set(null, "*", "ctrl_sigs", ctrl_sigs);
  end
  
  initial begin
    run_test("base_test");
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule
