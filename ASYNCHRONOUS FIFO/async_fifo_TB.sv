// Enhanced Coverage Class with Detailed Reporting
class async_fifo_coverage;
    
    // Coverage variables
    bit wr_en, rd_en, full, empty, wrst, rrst;
    bit [7:0] data_in;
    
    // Functional Coverage Group
    covergroup fifo_cg;
        
        // Write Enable Coverage
        write_enable: coverpoint wr_en {
            bins write_high = {1};
            bins write_low = {0};
        }
        
        // Read Enable Coverage
        read_enable: coverpoint rd_en {
            bins read_high = {1};
            bins read_low = {0};
        }
        
        // Full Flag Coverage
        full_flag: coverpoint full {
            bins full_asserted = {1};
            bins full_deasserted = {0};
        }
        
        // Empty Flag Coverage
        empty_flag: coverpoint empty {
            bins empty_asserted = {1};
            bins empty_deasserted = {0};
        }
        
        // Write Reset Coverage
        write_reset: coverpoint wrst {
            bins reset_active = {1};
            bins reset_inactive = {0};
        }
        
        // Read Reset Coverage
        read_reset: coverpoint rrst {
            bins reset_active = {1};
            bins reset_inactive = {0};
        }
        
        // Data Input Coverage
        data_input: coverpoint data_in {
            bins zero = {0};
            bins low_values = {[1:63]};
            bins mid_values = {[64:191]};
            bins high_values = {[192:254]};
            bins max_value = {255};
        }
        
        // FIFO State Coverage (with illegal bins)
        fifo_state: coverpoint {full, empty} {
            bins normal = {2'b00};
            bins empty_state = {2'b01};
            bins full_state = {2'b10};
            illegal_bins invalid = {2'b11};
        }
        
    endgroup
    
    function new();
        fifo_cg = new();
    endfunction
    
    function void sample(bit w_en, bit r_en, bit f, bit e, bit wr, bit rr, bit [7:0] din);
        wr_en = w_en;
        rd_en = r_en;
        full = f;
        empty = e;
        wrst = wr;
        rrst = rr;
        data_in = din;
        fifo_cg.sample();
    endfunction
    
endclass

// Testbench with Enhanced Coverage Reporting
module async_fifo_TB;

  parameter DATA_WIDTH = 8;

  wire [DATA_WIDTH-1:0] data_out;
  wire full;
  wire empty;
  reg [DATA_WIDTH-1:0] data_in;
  reg w_en, wclk, wrst;
  reg r_en, rclk, rrst;

  // Queue to push data_in
  reg [DATA_WIDTH-1:0] wdata_q[$], wdata;
  
  // Coverage instance
  async_fifo_coverage cov;

  Async_FIFO as_fifo (wclk,rclk, wrst,rrst,w_en,r_en,data_in,data_out,full,empty);

  always #10ns wclk = ~wclk;
  always #35ns rclk = ~rclk;
  
  // Coverage sampling
  always @(posedge wclk or posedge rclk) begin
    cov.sample(w_en, r_en, full, empty, wrst, rrst, data_in);
  end
  
  initial begin
    // Initialize coverage
    cov = new();
    
    wclk = 1'b0; wrst = 1'b1;
    w_en = 1'b0;
    data_in = 0;
    
    repeat(10) @(posedge wclk);
    wrst = 1'b0;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge wclk iff !full);
        w_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (w_en) begin
          data_in = $urandom;
	  if(i % 3 == 0) data_in = 255 / (i+1); // insert directed testing for extreme boundry value
          wdata_q.push_back(data_in);
        end
      end
      #50;
    end
  end

  initial begin
    rclk = 1'b0; rrst = 1'b1;
    r_en = 1'b0;

    repeat(20) @(posedge rclk);
    rrst = 1'b0;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge rclk iff !empty);
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (r_en) begin
          wdata = wdata_q.pop_front();
          if(data_out !== wdata) $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, data_out);
          else $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, data_out);
        end
      end
      #50;
    end
    
    // Call detailed coverage report - using built-in methods instead
    $display("\n=== COVERAGE REPORT ===");
    $display("Overall Coverage: %.2f%%", cov.fifo_cg.get_coverage());
    
    $display("\nDetailed Coverage by Coverpoint:");
    $display("Write Enable Coverage: %.2f%%", cov.fifo_cg.write_enable.get_coverage());
    $display("Read Enable Coverage: %.2f%%", cov.fifo_cg.read_enable.get_coverage());
    $display("Full Flag Coverage: %.2f%%", cov.fifo_cg.full_flag.get_coverage());
    $display("Empty Flag Coverage: %.2f%%", cov.fifo_cg.empty_flag.get_coverage());
    $display("Write Reset Coverage: %.2f%%", cov.fifo_cg.write_reset.get_coverage());
    $display("Read Reset Coverage: %.2f%%", cov.fifo_cg.read_reset.get_coverage());
    $display("Data Input Coverage: %.2f%%", cov.fifo_cg.data_input.get_coverage());
    $display("FIFO State Coverage: %.2f%%", cov.fifo_cg.fifo_state.get_coverage());

    $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
