// ============================================================================
// File: Gate_design.v
// Description: Multi-gate and adder implementations using various digital logic
//              structures (NAND/NOR gates, Multiplexers, and Decoders).
// ============================================================================

// ----------------------------------------------------------------------------
// Module: mux2x1
// Description: 2-to-1 Multiplexer standard cell model
// ----------------------------------------------------------------------------
module mux2x1(
    input wire [1:0] in,  // 2-bit data inputs: in[0] and in[1]
    input wire  sel,      // Select signal (0 picks in[0], 1 picks in[1])
    output wire out       // Multiplexer output
);
    assign out = in[sel]; // Multiplexer selection logic
endmodule

// ----------------------------------------------------------------------------
// Module: mux4x1
// Description: 4-to-1 Multiplexer standard cell model
// ----------------------------------------------------------------------------
module mux4x1(
    input wire [3:0] in,  // 4-bit data inputs
    input wire [1:0] sel, // 2-bit select signal
    output wire out       // Multiplexer output
);
    assign out = in[sel]; // Multiplexer selection logic
endmodule

// ----------------------------------------------------------------------------
// Module: Gate_design
// Description: Top-level module demonstrating equivalent logic designs using
//              NAND/NOR logic, MUX trees, and active-HIGH Decoders.
// ----------------------------------------------------------------------------
module Gate_design(
    // Input Signals
    input  wire  A, B,             // Primary logic inputs
    input  wire  cin,              // Carry-in for Full Adder implementations

    // Primitive Gate Outputs
    output reg AND_from_NAND_OUT,  // AND output using NAND implementation
    output reg OR_from_NAND_OUT,   // OR output using NAND implementation
    output reg AND_from_NOR_OUT,   // AND output using NOR implementation
    output reg BUFFER_from_XNOR_OUT,// Buffer output using XNOR implementation

    // MUX-Based Logic Outputs
    output wire NAND_from_MUX_OUT, // NAND output via 2x1 MUX
    output wire OR_from_MUX_OUT,   // OR output via 2x1 MUX
    output wire XOR_from_MUX_OUT,  // XOR output via 2x1 MUX

    // Adder Outputs
    output wire [1:0] HA_from_2x1MUX_OUT,   // Half Adder [1]=Carry, [0]=Sum via MUX
    output reg  [1:0] HA_from_2x4Decoder_OUT,// Half Adder via 2x4 Decoder
    output wire [1:0] FA_from_4x1MUX_OUT,   // Full Adder via 4x1 MUX
    output reg  [1:0] FA_from_3x8Decoder_OUT // Full Adder via 3x8 Decoder
);

   // Internal interconnect wires
   wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
   
   // Internal decoder outputs
   reg [3:0] out_decoder2x4; // 2x4 Decoder output lines (One-hot encoded)
   reg [7:0] out_decoder3x8; // 3x8 Decoder output lines (One-hot encoded)

// ----------------------------------------------------------------------------
// Combinational Behavioral Blocks (Basic Gates Implementation)
// ----------------------------------------------------------------------------
always @(*)
begin
    // [1] Implement OR gate from NAND gate: A OR B = ~((~A) AND (~B))
    OR_from_NAND_OUT = ~( ~(A & A) & ~(B & B) );

    // [2] Implement AND gate from NAND gate: A AND B = ~( ~(A AND B) )
    AND_from_NAND_OUT = ~( ~(A & B) & ~(A & B) );

    // [3] Implement AND gate from NOR gate: A AND B = ~((~A) NOR (~B))
    AND_from_NOR_OUT = ~( ~(A | A) | ~(B | B) );

    // [4] Implement BUFFER gate from XNOR gate: Buffer(A) = ~(A ^ 1)
    BUFFER_from_XNOR_OUT = ~(A ^ 1'b1);
end

// ----------------------------------------------------------------------------
// Multiplexer-based Logic Implementations
// ----------------------------------------------------------------------------

// [5] Implement NAND gate using 2x1 MUXes
// Stage 1: Pass B when A=1, else pass 0 -> Produces (A AND B)
mux2x1 m1( .in({B, 1'b0}), .sel(A), .out(w6) );
// Stage 2: Invert the result using MUX as NOT gate -> Produces ~(A AND B)
mux2x1 m2( .in({1'b0, 1'b1}), .sel(w6), .out(NAND_from_MUX_OUT) );

// [6] Implement OR gate using 2x1 MUX: If A=1 output 1, else output B
mux2x1 m3( .in({1'b1, B}), .sel(A), .out(OR_from_MUX_OUT) );

// [7] Implement XOR gate using 2x1 MUXes
// Invert B to form (~B)
mux2x1 m4( .in({1'b0, 1'b1}), .sel(B), .out(w7) );
// Select (~B) when A=1, else select B -> Produces A ^ B
mux2x1 m5( .in({w7, B}), .sel(A), .out(XOR_from_MUX_OUT) );

// [8] Implement Half Adder using 2x1 MUXes
// Sum Bit (A ^ B) via MUX tree
mux2x1 m6( .in({1'b0, 1'b1}), .sel(B), .out(w7) );
mux2x1 m7( .in({w7, B}), .sel(A), .out(HA_from_2x1MUX_OUT[0]) );
// Carry Bit (A AND B) via MUX: If A=1 output B, else output 0
mux2x1 m8( .in({B, 1'b0}), .sel(A), .out(HA_from_2x1MUX_OUT[1]) );

// ----------------------------------------------------------------------------
// [9] Implement Half Adder using 2x4 Decoder
// ----------------------------------------------------------------------------
always @(*)
begin
    // 2x4 Decoder functionality (generates minterms m0, m1, m2, m3)
    case ({A, B})
        2'b00: out_decoder2x4 = 4'b0001; // m0
        2'b01: out_decoder2x4 = 4'b0010; // m1
        2'b10: out_decoder2x4 = 4'b0100; // m2
        2'b11: out_decoder2x4 = 4'b1000; // m3
    endcase
    
    // Sum = m1 + m2 (A^B)
    HA_from_2x4Decoder_OUT[0] = out_decoder2x4[1] | out_decoder2x4[2];
    // Carry = m3 (A & B)
    HA_from_2x4Decoder_OUT[1] = out_decoder2x4[3];
end

// ----------------------------------------------------------------------------
// [10] Implement Full Adder using 4x1 MUXes
// ----------------------------------------------------------------------------
// Sum = A ^ B ^ cin using Multiplexer LUT approach
mux4x1 mux0(
    .in({A, ~A, ~A, A}),  // Inputs mapped to {cin=1,B=1}, {cin=1,B=0}, {cin=0,B=1}, {cin=0,B=0}
    .sel({B, cin}),
    .out(FA_from_4x1MUX_OUT[0])
);

// Carry-Out = AB + B(cin) + A(cin)
mux4x1 mux1(
    .in({1'b1, A, A, 1'b0}), // Inputs mapped for carry conditions
    .sel({B, cin}),
    .out(FA_from_4x1MUX_OUT[1])
);

// ----------------------------------------------------------------------------
// [11] Implement Full Adder using 3x8 Decoder
// ----------------------------------------------------------------------------
always @(*)
begin
    // 3x8 Decoder logic generating active-HIGH minterms m0 to m7
    case ({A, B, cin})
        3'b000: out_decoder3x8 = 8'b00000001; // m0
        3'b001: out_decoder3x8 = 8'b00000010; // m1
        3'b010: out_decoder3x8 = 8'b00000100; // m2
        3'b011: out_decoder3x8 = 8'b00001000; // m3
        3'b100: out_decoder3x8 = 8'b00010000; // m4
        3'b101: out_decoder3x8 = 8'b00100000; // m5
        3'b110: out_decoder3x8 = 8'b01000000; // m6
        3'b111: out_decoder3x8 = 8'b10000000; // m7
    endcase

    // Sum = Σm(1, 2, 4, 7)
    FA_from_3x8Decoder_OUT[0] = out_decoder3x8[1] | out_decoder3x8[2] | out_decoder3x8[4] | out_decoder3x8[7];
    // Carry-out = Σm(3, 5, 6, 7)
    FA_from_3x8Decoder_OUT[1] = out_decoder3x8[3] | out_decoder3x8[5] | out_decoder3x8[6] | out_decoder3x8[7];
end

endmodule