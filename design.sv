`include "enum.sv"
import enums::*;

module apb_slave #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 32) (
    input bit                       pclk,
    input bit                       preset,
    input bit [ADDR_WIDTH-1:0]      paddr,
    input bit [3:0]                 pprot,
    input bit                       pnse,
    input bit                       pselx,
    input bit                       penable,
    input bit                       pwrite,
    input bit [DATA_WIDTH-1:0]      pwdata,
    input bit [DATA_WIDTH/8-1:0]    pstrb,
    input bit                       pwakeup, // Unused in this simple implementation
    output bit [DATA_WIDTH-1:0]     prdata,
    output bit                      pready,
    output bit                      pslverr
);

    // Assuming enums::apb_state is defined as {IDLE, SETUP, ACCESS}
    apb_state curr_state, next_state;

    // Internal memory array (simulated register bank)
    bit [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Read Data Register: holds the data read from memory during the SETUP phase
    // to be output during the ACCESS phase.
    bit [DATA_WIDTH-1:0] prdata_reg;

    // PREADY and PSLVERR outputs
    // For a non-wait-state slave, PREADY is high only during ACCESS
    assign pready = (curr_state == ACCESS);
    assign pslverr = 1'b0; // Simple slave: always success

    // PRDATA output: Valid only when PREADY and PENABLE are high (i.e., during ACCESS)
    assign prdata = (curr_state == ACCESS) ? prdata_reg : '0;


    // --------------------------
    // Sequential Logic: State and Register Updates
    // --------------------------
    always_ff @(posedge pclk or negedge preset) begin
        if (!preset) begin
            // Reset state and data
            curr_state <= IDLE; // Cleaned up whitespace here
            prdata_reg <= '0;  // Cleaned up whitespace here
        end else begin
            curr_state <= next_state;

            // Data/Memory Access occurs on the clock edge entering ACCESS
            // The transaction completes (PWRITE happens) in the ACCESS phase.
            if (curr_state == SETUP && penable) begin
                // Transition to ACCESS: perform the memory operation
                if (pwrite) begin
                    // Write transaction: data is stable on PADDR, PWRITE, PSELX, PWDATA, PSTRB
                    mem[paddr] <= pwdata;
                    prdata_reg <= '0; // Clear read register on write
                end else begin
                    // Read transaction: read the data into the register
                    prdata_reg <= mem[paddr];
                end
            end
        end
    end

    // --------------------------
    // Combinational Logic: Next-state determination
    // --------------------------
    always_comb begin
        next_state = curr_state;

        unique case (curr_state)
            IDLE: begin
                // Start of transfer: PSELX goes high
                if (pselx)
                    next_state = SETUP;
            end
            SETUP: begin
                // PENABLE goes high: move to ACCESS
                if (penable)
                    next_state = ACCESS;
                // Master cancels SETUP phase (non-standard but robust handling)
                else if (!pselx)
                    next_state = IDLE;
            end
            ACCESS: begin
                // Transaction completes because PREADY is asserted (2-cycle transfer)
                // Check if the master is starting the next transfer immediately
                if (pselx)
                    next_state = SETUP; // Pipelined transfer: go straight to SETUP for the next cycle
                else
                    next_state = IDLE; // No immediate transfer: return to IDLE
            end
            default: next_state = IDLE; // Safety
        endcase
    end

endmodule
