// $Id: $
// File name:   tb_moore.sv
// Created:     2/14/2023
// Author:      Joao Taff-Freire
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: .

`timescale 1ns / 10ps

module tb_moore();
  // Define parameters
  // Common parameters
  localparam CLK_PERIOD        = 2.5;
  localparam PROPAGATION_DELAY = 0.8; // Allow for 800 ps for FF propagation delay

  localparam  RESET_OUTPUT_VALUE = 1'b0;

  // Declare Test Case Signals
  integer tb_test_num;
  string  tb_test_case;
  string  tb_stream_check_tag;
  int     tb_bit_num;
  logic   tb_mismatch;
  logic   tb_check;

  // Declare the Test Bench Signals for Expected Results
  logic tb_expected_output;
  logic [7:0] tb_test_data;

  // Declare DUT Connection Signals
  logic                tb_clk;
  logic                tb_n_rst;
  logic                tb_i;
  logic                tb_o;

// Task for standard DUT reset procedure
  task reset_dut;
  begin
    @(posedge tb_clk);
    // Activate the reset
    tb_n_rst = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_n_rst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input string check_tag;
  begin
    @(posedge tb_clk);
    @(negedge tb_clk);
    tb_mismatch = 1'b0;
    tb_check    = 1'b1;
    if(tb_expected_output == tb_o) begin // Check passed
      $info("Correct output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      tb_mismatch = 1'b1;
      $error("Incorrect output %s during %s test case", check_tag, tb_test_case);
    end

    // Wait some small amount of time so check pulse timing is visible on waves
    #(0.1);
    tb_check =1'b0;
  end
  endtask

  // Task to manage the timing of sending one bit through the shift register
  task send_bit;
    input logic bit_to_send;
  begin
    // Synchronize to the negative edge of clock to prevent timing errors
    @(negedge tb_clk);
    
    // Set the value of the bit
    tb_i = bit_to_send;

    // Wait for the value to have been shifted in on the rising clock edge
    @(posedge tb_clk);
    #(PROPAGATION_DELAY);
  end
  endtask

  // Task to contiguosly send a stream of bits through the shift register
  task send_stream;
    input logic [7:0] bit_stream;
  begin
    // Coniguously stream out all of the bits in the provided input vector
    for(tb_bit_num = 7; tb_bit_num >= 0; tb_bit_num--) begin
      // Send the current bit
      send_bit(bit_stream[tb_bit_num]);
    end
  end
  endtask

  // Clock generation block
  always begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end

  // DUT Portmap
  moore DUT (.clk(tb_clk), .n_rst(tb_n_rst), 
                    .i(tb_i), 
                    .o(tb_o));


  // Test bench main process
  initial begin
    // Initialize all of the test inputs
    tb_n_rst            = 1'b1; // Initialize to be inactive
    tb_i        = 1'b0; // Initialize to inactive value
    tb_test_num         = 0;    // Initialize test case counter
    tb_test_case        = "Test bench initializaton";
    tb_stream_check_tag = "N/A";
    tb_bit_num          = -1;   // Initialize to invalid number
    tb_mismatch         = 1'b0;
    tb_check            = 1'b0;
    // Wait some time before starting first test case
    #(0.1);

    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 1: Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    tb_i = 1'b0;
    tb_n_rst     = 1'b0;

    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    tb_expected_output = RESET_OUTPUT_VALUE;
    check_output("after reset applied");

    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output("after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(negedge tb_clk);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    // Check that internal state was correctly keep after reset release
    #(PROPAGATION_DELAY);
    check_output("after reset was released");

    // ************************************************************************
    // Test Case 2: Normal Operation with One Contiguous Detection
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 2: Normal Operation with One Contiguous Detection";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 8'b00001101;
    // Define the expected result
    tb_expected_output = '1;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 3: Normal Operation with Two Contiguous Detection (one stream)
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 3: Normal Operation with Two Contiguous Detection (one stream)";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 8'b01101101;

    // Define the expected result
    tb_expected_output = '1;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 4: Normal Operation Going Through all State Transitions
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 4: Normal Operation Going Through all State Transitions";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 8'b10111100;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 5: Normal Operation Going Through all State Transitions (continued)
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 5: Normal Operation Going Through all State Transitions (continued)";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 8'b00011010;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 6: Check Output State 0
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 6: Check Output State 0";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = '0;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 7: Check Output State 1
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 7: Check Output State 1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 'b01;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 8: Check Output State 2
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 8: Check Output State 2";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 'b011;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 9: Check Output State 3
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 9: Check Output State 3";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 'b0110;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 10: Check Output State 4
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 10: Check Output State 4";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 'b01101;

    // Define the expected result
    tb_expected_output = '1;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 11: Check Output All 0
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 11: Check Output all 0";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = '0;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 12: Check Output All 1
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 12: Check Output All 1";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = '1;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 13: Check Output Toggles
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 13: Check Output Toggles";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 'b01011011;

    // Define the expected result
    tb_expected_output = '0;

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    // Check the result of the full stream
    check_output("after first sequence stream");

    // ************************************************************************
    // Test Case 14: Check Output After Reset
    // ************************************************************************
    tb_test_num  = tb_test_num + 1;
    tb_test_case = "Test Case 14: Check Output After Reset";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_i = 1'b0;
    reset_dut();

    // Define the test data stream for this test case
    tb_test_data = 'b1101;

    // Define the expected result

    // Contiguously stream enough zeros to fill the shift register
    send_stream(tb_test_data);

    tb_n_rst     = 1'b0;

    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    tb_expected_output = RESET_OUTPUT_VALUE;
    check_output("after reset applied");

    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output("after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(negedge tb_clk);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    // Check that internal state was correctly keep after reset release
    #(PROPAGATION_DELAY);
    check_output("after reset was released");

    // Check the result of the full stream
    check_output("after first sequence stream");

  $stop;
  end
endmodule
  
