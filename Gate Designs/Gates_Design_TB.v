`timescale 1ns/1ps

module Gate_design_tb ();

  // Testbench input/output signal declarations
  reg  A_tb, B_tb, cin_tb;
  wire AND_from_NAND_OUT_tb;
  wire OR_from_NAND_OUT_tb;
  wire AND_from_NOR_OUT_tb;
  wire BUFFER_from_XNOR_OUT_tb;
  wire NAND_from_MUX_OUT_tb;
  wire OR_from_MUX_OUT_tb;
  wire XOR_from_MUX_OUT_tb;
  wire [1:0] HA_from_2x1MUX_OUT_tb;   
  wire [1:0] HA_from_2x4Decoder_OUT_tb;
  wire [1:0] FA_from_4x1MUX_OUT_tb;
  wire [1:0] FA_from_3x8Decoder_OUT_tb;

  // Design Under Test (DUT) instantiation[cite: 1]
  Gate_design dut (
    .A(A_tb),
    .B(B_tb),
    .cin(cin_tb),
    .AND_from_NAND_OUT(AND_from_NAND_OUT_tb),
    .OR_from_NAND_OUT(OR_from_NAND_OUT_tb),
    .AND_from_NOR_OUT(AND_from_NOR_OUT_tb),
    .BUFFER_from_XNOR_OUT(BUFFER_from_XNOR_OUT_tb),
    .NAND_from_MUX_OUT(NAND_from_MUX_OUT_tb),
    .OR_from_MUX_OUT(OR_from_MUX_OUT_tb),
    .XOR_from_MUX_OUT(XOR_from_MUX_OUT_tb),
    .HA_from_2x1MUX_OUT(HA_from_2x1MUX_OUT_tb),
    .HA_from_2x4Decoder_OUT(HA_from_2x4Decoder_OUT_tb),
    .FA_from_4x1MUX_OUT(FA_from_4x1MUX_OUT_tb),
    .FA_from_3x8Decoder_OUT(FA_from_3x8Decoder_OUT_tb)
  );

  integer i;

  initial begin
    // Setup VCD dumping for waveform viewers[cite: 1]
    $dumpfile("gates.vcd");
    $dumpvars(0, Gate_design_tb);

    // Console output header
    $display("-----------------------------------------------------------------------------------------------");
    $display(" Time   | A B cin | NAND_AND NAND_OR NOR_AND XNOR_BUF | MUX_NAND MUX_OR MUX_XOR | MUX_HA DEC_HA | MUX_FA DEC_FA ");
    $display("-----------------------------------------------------------------------------------------------");

    // Loop through all 8 combinations (2^3 = 8)
    for (i = 0; i < 8; i = i + 1) begin
      {A_tb, B_tb, cin_tb} = i[2:0];
      #10;
      $display("%4tps | %b %b  %b  |    %b        %b       %b        %b     |    %b       %b      %b    |   %b     %b   |   %b     %b", 
               $time, A_tb, B_tb, cin_tb,
               AND_from_NAND_OUT_tb, OR_from_NAND_OUT_tb, AND_from_NOR_OUT_tb, BUFFER_from_XNOR_OUT_tb,
               NAND_from_MUX_OUT_tb, OR_from_MUX_OUT_tb, XOR_from_MUX_OUT_tb,
               HA_from_2x1MUX_OUT_tb, HA_from_2x4Decoder_OUT_tb,
               FA_from_4x1MUX_OUT_tb, FA_from_3x8Decoder_OUT_tb);
    end

    #10;
    $stop;
  end

endmodule