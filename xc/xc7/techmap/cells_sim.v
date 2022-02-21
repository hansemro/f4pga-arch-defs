// ============================================================================
// Define FFs required by VPR
//
module CE_VCC (output VCC);
wire VCC = 1;
endmodule

module SR_GND (output GND);
wire GND = 0;
endmodule

module SYN_OBUF(input I, output O);
  assign O = I;
endmodule

module SYN_IBUF(input I, output O);
  assign O = I;
endmodule

module FDRE_ZINI (output reg Q, input C, CE, D, R);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C) if (R) Q <= 1'b0; else if (CE) Q <= D;
    1'b1: always @(negedge C) if (R) Q <= 1'b0; else if (CE) Q <= D;
  endcase endgenerate
endmodule

module FDSE_ZINI (output reg Q, input C, CE, D, S);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C) if (S) Q <= 1'b1; else if (CE) Q <= D;
    1'b1: always @(negedge C) if (S) Q <= 1'b1; else if (CE) Q <= D;
  endcase endgenerate
endmodule

module FDCE_ZINI (output reg Q, input C, CE, D, CLR);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C, posedge CLR) if (CLR) Q <= 1'b0; else if (CE) Q <= D;
    1'b1: always @(negedge C, posedge CLR) if (CLR) Q <= 1'b0; else if (CE) Q <= D;
  endcase endgenerate
endmodule

module FDPE_ZINI (output reg Q, input C, CE, D, PRE);
  parameter [0:0] ZINI = 1'b0;
  parameter [0:0] IS_C_INVERTED = 1'b0;
  initial Q <= !ZINI;
  generate case (|IS_C_INVERTED)
    1'b0: always @(posedge C, posedge PRE) if (PRE) Q <= 1'b1; else if (CE) Q <= D;
    1'b1: always @(negedge C, posedge PRE) if (PRE) Q <= 1'b1; else if (CE) Q <= D;
  endcase endgenerate
endmodule

// ============================================================================
// Carry chain primitives

// Output CO directly
module CARRY_CO_DIRECT(input CO, input O, input S, input DI, output OUT);

assign OUT = CO;

endmodule

// Compute CO from O and S
module CARRY_CO_LUT(input CO, input O, input S, input DI, output OUT);

assign OUT = O ^ S;

endmodule

(* abc9_box, blackbox *)
module CARRY_COUT_PLUG(input CIN, output COUT);

assign COUT = CIN;

  specify
    (CIN => COUT) = 0;
  endspecify

endmodule

module CARRY4_VPR(O0, O1, O2, O3, CO0, CO1, CO2, CO3, CYINIT, CIN, DI0, DI1, DI2, DI3, S0, S1, S2, S3);
  parameter CYINIT_AX = 1'b0;
  parameter CYINIT_C0 = 1'b0;
  parameter CYINIT_C1 = 1'b0;

  (* DELAY_CONST_CYINIT="0.491e-9" *)
  (* DELAY_CONST_CIN="0.235e-9" *)
  (* DELAY_CONST_S0="0.223e-9" *)
  output wire O0;

  (* DELAY_CONST_CYINIT="0.613e-9" *)
  (* DELAY_CONST_CIN="0.348e-9" *)
  (* DELAY_CONST_S0="0.400e-9" *)
  (* DELAY_CONST_S1="0.205e-9" *)
  (* DELAY_CONST_DI0="0.337e-9" *)
  output wire O1;

  (* DELAY_CONST_CYINIT="0.600e-9" *)
  (* DELAY_CONST_CIN="0.256e-9" *)
  (* DELAY_CONST_S0="0.523e-9" *)
  (* DELAY_CONST_S1="0.558e-9" *)
  (* DELAY_CONST_S2="0.226e-9" *)
  (* DELAY_CONST_DI0="0.486e-9" *)
  (* DELAY_CONST_DI1="0.471e-9" *)
  output wire O2;

  (* DELAY_CONST_CYINIT="0.657e-9" *)
  (* DELAY_CONST_CIN="0.329e-9" *)
  (* DELAY_CONST_S0="0.582e-9" *)
  (* DELAY_CONST_S1="0.618e-9" *)
  (* DELAY_CONST_S2="0.330e-9" *)
  (* DELAY_CONST_S3="0.227e-9" *)
  (* DELAY_CONST_DI0="0.545e-9" *)
  (* DELAY_CONST_DI1="0.532e-9" *)
  (* DELAY_CONST_DI2="0.372e-9" *)
  output wire O3;

  (* DELAY_CONST_CYINIT="0.578e-9" *)
  (* DELAY_CONST_CIN="0.293e-9" *)
  (* DELAY_CONST_S0="0.340e-9" *)
  (* DELAY_CONST_DI0="0.329e-9" *)
  output wire CO0;

  (* DELAY_CONST_CYINIT="0.529e-9" *)
  (* DELAY_CONST_CIN="0.178e-9" *)
  (* DELAY_CONST_S0="0.433e-9" *)
  (* DELAY_CONST_S1="0.469e-9" *)
  (* DELAY_CONST_DI0="0.396e-9" *)
  (* DELAY_CONST_DI1="0.376e-9" *)
  output wire CO1;

  (* DELAY_CONST_CYINIT="0.617e-9" *)
  (* DELAY_CONST_CIN="0.250e-9" *)
  (* DELAY_CONST_S0="0.512e-9" *)
  (* DELAY_CONST_S1="0.548e-9" *)
  (* DELAY_CONST_S2="0.292e-9" *)
  (* DELAY_CONST_DI0="0.474e-9" *)
  (* DELAY_CONST_DI1="0.459e-9" *)
  (* DELAY_CONST_DI2="0.289e-9" *)
  output wire CO2;

  (* DELAY_CONST_CYINIT="0.580e-9" *)
  (* DELAY_CONST_CIN="0.114e-9" *)
  (* DELAY_CONST_S0="0.508e-9" *)
  (* DELAY_CONST_S1="0.528e-9" *)
  (* DELAY_CONST_S2="0.376e-9" *)
  (* DELAY_CONST_S3="0.380e-9" *)
  (* DELAY_CONST_DI0="0.456e-9" *)
  (* DELAY_CONST_DI1="0.443e-9" *)
  (* DELAY_CONST_DI2="0.324e-9" *)
  (* DELAY_CONST_DI3="0.327e-9" *)
  output wire CO3;

  input wire DI0, DI1, DI2, DI3;
  input wire S0, S1, S2, S3;

  input wire CYINIT;
  input wire CIN;

  wire CI0;
  wire CI1;
  wire CI2;
  wire CI3;
  wire CI4;

  assign CI0 = CYINIT_AX ? CYINIT :
               CYINIT_C1 ? 1'b1 :
               CYINIT_C0 ? 1'b0 :
               CIN;
  assign CI1 = S0 ? CI0 : DI0;
  assign CI2 = S1 ? CI1 : DI1;
  assign CI3 = S2 ? CI2 : DI2;
  assign CI4 = S3 ? CI3 : DI3;

  assign CO0 = CI1;
  assign CO1 = CI2;
  assign CO2 = CI3;
  assign CO3 = CI4;

  assign O0 = CI0 ^ S0;
  assign O1 = CI1 ^ S1;
  assign O2 = CI2 ^ S2;
  assign O3 = CI3 ^ S3;

  specify
    // https://github.com/SymbiFlow/prjxray-db/blob/34ea6eb08a63d21ec16264ad37a0a7b142ff6031/artix7/timings/CLBLL_L.sdf#L11-L46
    (CYINIT => O0) = 482;
    (S0     => O0) = 223;
    (CIN    => O0) = 222;
    (CYINIT => O1) = 598;
    (DI0    => O1) = 407;
    (S0     => O1) = 400;
    (S1     => O1) = 205;
    (CIN    => O1) = 334;
    (CYINIT => O2) = 584;
    (DI0    => O2) = 556;
    (DI1    => O2) = 537;
    (S0     => O2) = 523;
    (S1     => O2) = 558;
    (S2     => O2) = 226;
    (CIN    => O2) = 239;
    (CYINIT => O3) = 642;
    (DI0    => O3) = 615;
    (DI1    => O3) = 596;
    (DI2    => O3) = 438;
    (S0     => O3) = 582;
    (S1     => O3) = 618;
    (S2     => O3) = 330;
    (S3     => O3) = 227;
    (CIN    => O3) = 313;
    (CYINIT => CO0) = 536;
    (DI0    => CO0) = 379;
    (S0     => CO0) = 340;
    (CIN    => CO0) = 271;
    (CYINIT => CO1) = 494;
    (DI0    => CO1) = 465;
    (DI1    => CO1) = 445;
    (S0     => CO1) = 433;
    (S1     => CO1) = 469;
    (CIN    => CO1) = 157;
    (CYINIT => CO2) = 592;
    (DI0    => CO2) = 540;
    (DI1    => CO2) = 520;
    (DI2    => CO2) = 356;
    (S0     => CO2) = 512;
    (S1     => CO2) = 548;
    (S2     => CO2) = 292;
    (CIN    => CO2) = 228;
    (CYINIT => CO3) = 580;
    (DI0    => CO3) = 526;
    (DI1    => CO3) = 507;
    (DI2    => CO3) = 398;
    (DI3    => CO3) = 385;
    (S0     => CO3) = 508;
    (S1     => CO3) = 528;
    (S2     => CO3) = 378;
    (S3     => CO3) = 380;
    (CIN    => CO3) = 114;
  endspecify
endmodule

// ============================================================================
// Distributed RAMs

module DPRAM64_for_RAM128X1D (
  output O,
  input  DI, CLK, WE, WA7,
  input [5:0] A, WA
);
  parameter [63:0] INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  parameter HIGH_WA7_SELECT = 1'b0;
  wire [5:0] A;
  wire [5:0] WA;
  reg [63:0] mem;
  initial mem <= INIT;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE & (WA7 == HIGH_WA7_SELECT)) mem[WA] <= DI;
endmodule

module DPRAM64 (
  output O,
  input  DI, CLK, WE, WA7, WA8,
  input [5:0] A, WA
);
  parameter [63:0] INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  parameter WA7USED = 1'b0;
  parameter WA8USED = 1'b0;
  parameter HIGH_WA7_SELECT = 1'b0;
  parameter HIGH_WA8_SELECT = 1'b0;
  wire [5:0] A;
  wire [5:0] WA;
  reg [63:0] mem;
  initial mem <= INIT;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;

  wire WA7SELECT = !WA7USED | (WA7 == HIGH_WA7_SELECT);
  wire WA8SELECT = !WA8USED | (WA8 == HIGH_WA8_SELECT);
  wire address_selected = WA7SELECT & WA8SELECT;
  always @(posedge clk) if (WE & address_selected) mem[WA] <= DI;
endmodule

module DPRAM32 (
  output O,
  input  DI, CLK, WE,
  input [4:0] A, WA
);
  parameter [31:0] INIT_00 = 32'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [4:0] A;
  wire [4:0] WA;
  reg [31:0] mem;
  initial mem <= INIT_00;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) begin
    mem[WA] <= DI;
  end
endmodule

module SPRAM32 (
  output O,
  input  DI, CLK, WE,
  input [4:0] A, WA
);
  parameter [31:0] INIT_ZERO = 32'h0;
  parameter [31:0] INIT_00 = 32'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [4:0] A;
  wire [4:0] WA;
  reg [31:0] mem;
  initial mem <= INIT_00;
  assign O = mem[A];
  wire clk = CLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) begin
    mem[WA] <= DI;
  end
endmodule

module DI64_STUB (
    input DI, output DO
);
    assign DO = DI;
endmodule

// To ensure that all DRAMs are co-located within a SLICEM, this block is
// a simple passthrough black box to allow a pack pattern for dual port DRAMs.
module DRAM_2_OUTPUT_STUB(
    input SPO, DPO,
    output SPO_OUT, DPO_OUT
);
  wire SPO_OUT;
  wire DPO_OUT;
  assign SPO_OUT = SPO;
  assign DPO_OUT = DPO;
endmodule

module DRAM_4_OUTPUT_STUB(
    input DOA, DOB, DOC, DOD,
    output DOA_OUT, DOB_OUT, DOC_OUT, DOD_OUT
);
  assign DOA_OUT = DOA;
  assign DOB_OUT = DOB;
  assign DOC_OUT = DOC;
  assign DOD_OUT = DOD;
endmodule

module DRAM_8_OUTPUT_STUB(
    input DOA1, DOB1, DOC1, DOD1, DOA0, DOB0, DOC0, DOD0,
    output DOA1_OUT, DOB1_OUT, DOC1_OUT, DOD1_OUT, DOA0_OUT, DOB0_OUT, DOC0_OUT, DOD0_OUT
);
  assign DOA1_OUT = DOA1;
  assign DOB1_OUT = DOB1;
  assign DOC1_OUT = DOC1;
  assign DOD1_OUT = DOD1;
  assign DOA0_OUT = DOA0;
  assign DOB0_OUT = DOB0;
  assign DOC0_OUT = DOC0;
  assign DOD0_OUT = DOD0;
endmodule

// ============================================================================
// Block RAMs

module RAMB18E1_VPR (
	input CLKARDCLK,
	input CLKBWRCLK,
	input ENARDEN,
	input ENBWREN,
	input REGCLKARDRCLK,
	input REGCEAREGCE,
	input REGCEB,
	input REGCLKB,
	input RSTRAMARSTRAM,
	input RSTRAMB,
	input RSTREGARSTREG,
	input RSTREGB,

	input [1:0]  ADDRBTIEHIGH,
	input [13:0] ADDRBWRADDR,
	input [1:0]  ADDRATIEHIGH,
	input [13:0] ADDRARDADDR,
	input [15:0] DIADI,
	input [15:0] DIBDI,
	input [1:0] DIPADIP,
	input [1:0] DIPBDIP,
	input [3:0] WEA,
	input [7:0] WEBWE,

	output [15:0] DOADO,
	output [15:0] DOBDO,
	output [1:0] DOPADOP,
	output [1:0] DOPBDOP
);
	parameter IN_USE = 1'b0;

	parameter ZINIT_A = 18'h0;
	parameter ZINIT_B = 18'h0;

	parameter ZSRVAL_A = 18'h0;
	parameter ZSRVAL_B = 18'h0;

	parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

	parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

	parameter ZINV_CLKARDCLK = 1'b1;
	parameter ZINV_CLKBWRCLK = 1'b1;
	parameter ZINV_ENARDEN = 1'b1;
	parameter ZINV_ENBWREN = 1'b1;
	parameter ZINV_RSTRAMARSTRAM = 1'b1;
	parameter ZINV_RSTRAMB = 1'b1;
	parameter ZINV_RSTREGARSTREG = 1'b1;
	parameter ZINV_RSTREGB = 1'b1;
	parameter ZINV_REGCLKARDRCLK = 1'b1;
	parameter ZINV_REGCLKB = 1'b1;

	parameter DOA_REG = 1'b0;
	parameter DOB_REG = 1'b0;

	parameter integer SDP_READ_WIDTH_36 = 1'b0;
	parameter integer Y0_READ_WIDTH_A_18 = 1'b0;
	parameter integer Y1_READ_WIDTH_A_18 = 1'b0;
	parameter integer READ_WIDTH_A_9 = 1'b0;
	parameter integer READ_WIDTH_A_4 = 1'b0;
	parameter integer READ_WIDTH_A_2 = 1'b0;
	parameter integer Y0_READ_WIDTH_A_1 = 1'b0;
	parameter integer Y1_READ_WIDTH_A_1 = 1'b0;
	parameter integer READ_WIDTH_B_18 = 1'b0;
	parameter integer READ_WIDTH_B_9 = 1'b0;
	parameter integer READ_WIDTH_B_4 = 1'b0;
	parameter integer READ_WIDTH_B_2 = 1'b0;
	parameter integer READ_WIDTH_B_1 = 1'b1;

	parameter integer SDP_WRITE_WIDTH_36 = 1'b0;
	parameter integer WRITE_WIDTH_A_18 = 1'b0;
	parameter integer WRITE_WIDTH_A_9 = 1'b0;
	parameter integer WRITE_WIDTH_A_4 = 1'b0;
	parameter integer WRITE_WIDTH_A_2 = 1'b0;
	parameter integer WRITE_WIDTH_A_1 = 1'b1;
	parameter integer WRITE_WIDTH_B_18 = 1'b0;
	parameter integer WRITE_WIDTH_B_9 = 1'b0;
	parameter integer WRITE_WIDTH_B_4 = 1'b0;
	parameter integer WRITE_WIDTH_B_2 = 1'b0;
	parameter integer WRITE_WIDTH_B_1 = 1'b1;

	parameter WRITE_MODE_A_NO_CHANGE = 1'b0;
	parameter WRITE_MODE_A_READ_FIRST = 1'b0;
	parameter WRITE_MODE_B_NO_CHANGE = 1'b0;
	parameter WRITE_MODE_B_READ_FIRST = 1'b0;
endmodule

module RAMB36E1_PRIM (
        input CLKARDCLKU,           input CLKARDCLKL,
        input CLKBWRCLKU,           input CLKBWRCLKL,
        input ENARDENU,             input ENARDENL,
        input ENBWRENU,             input ENBWRENL,
        input REGCLKARDRCLKU,       input REGCLKARDRCLKL,
        input REGCEAREGCEU,         input REGCEAREGCEL,
        input REGCEBU,              input REGCEBL,
        input REGCLKBU,             input REGCLKBK,
        input RSTRAMARSTRAMU,       input RSTRAMARSTRAMLRST,
        input RSTRAMBU,             input RSTRAMBL,
        input RSTREGARSTREGU,       input RSTREGARSTREGL,
        input RSTREGBU,             input RSTREGBL,

        input [14:0] ADDRBWRADDRU,  input [15:0] ADDRBWRADDRL,
        input [14:0] ADDRARDADDRU,  input [15:0] ADDRARDADDRL,
        input [31:0] DIADI,
        input [31:0] DIBDI,
        input [3:0] DIPADIP,
        input [3:0] DIPBDIP,
        input [3:0] WEAU,           input [3:0] WEAL,
        input [7:0] WEBWEU,         input [7:0] WEBWEL,

        output [31:0] DOADO,
        output [31:0] DOBDO,
        output [3:0] DOPADOP,
        output [3:0] DOPBDOP
);
        parameter IN_USE = 1'b0;

        parameter ZINIT_A = 36'h0;
        parameter ZINIT_B = 36'h0;

        parameter ZSRVAL_A = 36'h0;
        parameter ZSRVAL_B = 36'h0;

        `define INIT_BLOCK(pre) \
        parameter ``pre``0 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``1 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``2 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``3 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``4 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``5 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``6 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``7 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``8 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``9 = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``A = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``B = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``C = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``D = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``E = 256'h0000000000000000000000000000000000000000000000000000000000000000; \
        parameter ``pre``F = 256'h0000000000000000000000000000000000000000000000000000000000000000

        `INIT_BLOCK(INITP_0);
        `INIT_BLOCK(INIT_1);
        `INIT_BLOCK(INIT_2);
        `INIT_BLOCK(INIT_3);
        `INIT_BLOCK(INIT_4);
        `INIT_BLOCK(INIT_5);
        `INIT_BLOCK(INIT_6);
        `INIT_BLOCK(INIT_7);
        `undef INIT_BLOCK

        parameter ZINV_CLKARDCLK = 1'b1;
        parameter ZINV_CLKBWRCLK = 1'b1;
        parameter ZINV_ENARDEN = 1'b1;
        parameter ZINV_ENBWREN = 1'b1;
        parameter ZINV_RSTRAMARSTRAM = 1'b1;
        parameter ZINV_RSTRAMB = 1'b1;
        parameter ZINV_RSTREGARSTREG = 1'b1;
        parameter ZINV_RSTREGB = 1'b1;
        parameter ZINV_REGCLKARDRCLK = 1'b1;
        parameter ZINV_REGCLKB = 1'b1;

        parameter DOA_REG = 1'b0;
        parameter DOB_REG = 1'b0;

        parameter integer SDP_READ_WIDTH_72 = 1'b0;

        parameter integer READ_WIDTH_A_36 = 1'b0;
        parameter integer READ_WIDTH_A_18 = 1'b0;
        parameter integer READ_WIDTH_A_9 = 1'b0;
        parameter integer READ_WIDTH_A_4 = 1'b0;
        parameter integer READ_WIDTH_A_2 = 1'b0;
        parameter integer READ_WIDTH_A_1 = 1'b1;
        parameter integer BRAM36_READ_WIDTH_A_1 = 1'b0;

        parameter integer READ_WIDTH_B_18 = 1'b0;
        parameter integer READ_WIDTH_B_9 = 1'b0;
        parameter integer READ_WIDTH_B_4 = 1'b0;
        parameter integer READ_WIDTH_B_2 = 1'b0;
        parameter integer READ_WIDTH_B_1 = 1'b1;
        parameter integer BRAM36_READ_WIDTH_B_1 = 1'b0;

        parameter integer SDP_WRITE_WIDTH_72 = 1'b0;

        parameter integer WRITE_WIDTH_A_36 = 1'b0;
        parameter integer WRITE_WIDTH_A_18 = 1'b0;
        parameter integer WRITE_WIDTH_A_9 = 1'b0;
        parameter integer WRITE_WIDTH_A_4 = 1'b0;
        parameter integer WRITE_WIDTH_A_2 = 1'b0;
        parameter integer WRITE_WIDTH_A_1 = 1'b1;
        parameter integer BRAM36_WRITE_WIDTH_A_1 = 1'b0;

        parameter integer WRITE_WIDTH_B_18 = 1'b0;
        parameter integer WRITE_WIDTH_B_9 = 1'b0;
        parameter integer WRITE_WIDTH_B_4 = 1'b0;
        parameter integer WRITE_WIDTH_B_2 = 1'b0;
        parameter integer WRITE_WIDTH_B_1 = 1'b1;
        parameter integer BRAM36_WRITE_WIDTH_B_1 = 1'b0;

        parameter WRITE_MODE_A_NO_CHANGE = 1'b0;
        parameter WRITE_MODE_A_READ_FIRST = 1'b0;
        parameter WRITE_MODE_B_NO_CHANGE = 1'b0;
        parameter WRITE_MODE_B_READ_FIRST = 1'b0;
endmodule

// ============================================================================
// SRLs

// SRLC32E_VPR
module SRLC32E_VPR
(
input CLK, CE, D,
input [4:0] A,
output Q, Q31
);
  parameter [64:0] INIT = 64'd0;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [31:0] r;
  integer i;

  initial for (i=0; i<32; i=i+1)
    r[i] <= INIT[2*i];

  assign Q31 = r[31];
  assign Q = r[A];

  generate begin
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[30:0], D };
    end else begin
      always @(posedge CLK) if (CE) r <= { r[30:0], D };
    end
  end endgenerate

endmodule

// SRLC16E_VPR
module SRLC16E_VPR
(
input CLK, CE, D,
input A0, A1, A2, A3,
output Q, Q15
);
  parameter [15:0] INIT = 16'd0;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;

  reg [15:0] r = INIT;

  assign Q15 = r[15];
  assign Q = r[{A3,A2,A1,A0}];

  generate
    if (IS_CLK_INVERTED) begin
      always @(negedge CLK) if (CE) r <= { r[14:0], D };
    end else begin
      always @(posedge CLK) if (CE) r <= { r[14:0], D };
    end
  endgenerate

endmodule

// ============================================================================
// IO

module IBUF_VPR (
	input I,
	output O
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_IN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVDS_25_LVTTL_SSTL135_SSTL15_TMDS_33_IN_ONLY = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS25_LVCMOS33_LVTTL_IN = 1'b0;
  parameter [0:0] SSTL135_SSTL15_IN = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] IBUF_LOW_PWR = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";

  assign O = I;

endmodule

module OBUFT_VPR (
	input  I,
    input  T,
	output O
);

  parameter [0:0] LVCMOS12_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS12_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS25_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_LVCMOS18_LVCMOS25_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I24 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS33_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I4 = 1'b0;
  parameter [0:0] LVTTL_DRIVE_I24 = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter DRIVE = 0;
  parameter SLEW = "";

  assign O = (T == 1'b0) ? I : 1'bz;

endmodule


module IOBUF_VPR (
    input  I,
    input  T,
    output O,
    input  IOPAD_$inp,
    output IOPAD_$out
);

  parameter [0:0] LVCMOS12_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS12_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_IN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS25_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS15_DRIVE_I8 = 1'b0;
  parameter [0:0] LVCMOS15_LVCMOS18_LVCMOS25_DRIVE_I4 = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS18_DRIVE_I24 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I12 = 1'b0;
  parameter [0:0] LVCMOS25_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS25_LVCMOS33_LVTTL_IN = 1'b0;
  parameter [0:0] LVCMOS33_DRIVE_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I16 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I12_I8 = 1'b0;
  parameter [0:0] LVCMOS33_LVTTL_DRIVE_I4 = 1'b0;
  parameter [0:0] LVTTL_DRIVE_I24 = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_IN = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] IBUF_LOW_PWR = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter DRIVE = 0;
  parameter SLEW = "";

  assign O = IOPAD_$inp;
  assign IOPAD_$out = (T == 1'b0) ? I : 1'bz;

endmodule


module OBUFTDS_M_VPR (
    input  I,
    input  T,
    output O,
    output OB
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_OUT = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;
  parameter [0:0] TMDS_33_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] TMDS_33_OUT = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  assign O  = (T == 1'b0) ?  I : 1'bz;
  assign OB = (T == 1'b0) ? !I : 1'bz;

endmodule

module OBUFTDS_S_VPR (
    input  IB,
    output OB
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  assign OB = IB;

endmodule


module IOBUFDS_M_VPR (
    input  I,
    input  T,
    output O,
    input  IOPAD_$inp,
    output IOPAD_$out,
    input  IB,
    output OB
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_OUT = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;
  parameter [0:0] TMDS_33_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] TMDS_33_OUT = 1'b0;
  parameter [0:0] LVDS_25_SSTL135_SSTL15_IN_DIFF = 1'b0;
  parameter [0:0] TMDS_33_IN_DIFF = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  reg O;
  always @(*) case ({IB, IOPAD_$inp})
  2'b00: O <= 1'bX;
  2'b01: O <= 1'b1;
  2'b10: O <= 1'b0;
  2'b11: O <= 1'bX;
  endcase

  assign IOPAD_$out = (T == 1'b0) ?  I : 1'bz;
  assign OB         = (T == 1'b0) ? !I : 1'bz;

endmodule

module IOBUFDS_S_VPR (
    input  IB,
    output OB,
    input  IOPAD_$inp,
    output IOPAD_$out
);

  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SSTL135_SSTL15_SLEW_SLOW = 1'b0;
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0;
  parameter [0:0] LVCMOS15_SSTL15_DRIVE_I16_I_FIXED = 1'b0;
  parameter [0:0] SSTL135_DRIVE_I_FIXED = 1'b0;
  parameter [0:0] LVDS_25_SSTL135_SSTL15_IN_DIFF = 1'b0;
  parameter [0:0] SSTL135_SSTL15_SLEW_FAST = 1'b0;

  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0;
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0;

  parameter [0:0] PULLTYPE_PULLUP = 1'b0;
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0;
  parameter [0:0] PULLTYPE_NONE = 1'b0;
  parameter [0:0] PULLTYPE_KEEPER = 1'b0;

  parameter PULLTYPE = "";

  parameter IOSTANDARD = "";
  parameter SLEW = "";

  assign IOPAD_$out = IB;
  assign OB = IOPAD_$inp;

endmodule

(* whitebox *)
module T_INV (
    input  TI,
    output TO
);

  assign TO = ~TI;

endmodule

// ============================================================================
// I/OSERDES

module OSERDESE2_VPR (
  input CLK,
  input CLKDIV,
  input D1,
  input D2,
  input D3,
  input D4,
  input D5,
  input D6,
  input D7,
  input D8,
  input OCE,
  input RST,
  input T1,
  input T2,
  input T3,
  input T4,
  input TCE,
  output OFB,
  output OQ,
  output TFB,
  output TQ
);

  parameter [0:0] SERDES_MODE_SLAVE = 1'b0;

  parameter [0:0] TRISTATE_WIDTH_W4 = 1'b0;

  parameter [0:0] DATA_RATE_OQ_DDR = 1'b0;
  parameter [0:0] DATA_RATE_OQ_SDR = 1'b0;
  parameter [0:0] DATA_RATE_TQ_BUF = 1'b0;
  parameter [0:0] DATA_RATE_TQ_DDR = 1'b0;
  parameter [0:0] DATA_RATE_TQ_SDR = 1'b0;

  parameter [0:0] DATA_WIDTH_DDR_W6_8 = 1'b0;
  parameter [0:0] DATA_WIDTH_SDR_W2_4_5_6 = 1'b0;

  parameter [0:0] DATA_WIDTH_W2 = 1'b0;
  parameter [0:0] DATA_WIDTH_W3 = 1'b0;
  parameter [0:0] DATA_WIDTH_W4 = 1'b0;
  parameter [0:0] DATA_WIDTH_W5 = 1'b0;
  parameter [0:0] DATA_WIDTH_W6 = 1'b0;
  parameter [0:0] DATA_WIDTH_W7 = 1'b0;
  parameter [0:0] DATA_WIDTH_W8 = 1'b0;

  // Inverter parameters
  parameter [0:0] IS_CLKDIV_INVERTED = 1'b0;
  parameter [0:0] IS_D1_INVERTED = 1'b0;
  parameter [0:0] IS_D2_INVERTED = 1'b0;
  parameter [0:0] IS_D3_INVERTED = 1'b0;
  parameter [0:0] IS_D4_INVERTED = 1'b0;
  parameter [0:0] IS_D5_INVERTED = 1'b0;
  parameter [0:0] IS_D6_INVERTED = 1'b0;
  parameter [0:0] IS_D7_INVERTED = 1'b0;
  parameter [0:0] IS_D8_INVERTED = 1'b0;

  parameter [0:0] ZINV_CLK = 1'b0;
  parameter [0:0] ZINV_T1 = 1'b0;
  parameter [0:0] ZINV_T2 = 1'b0;
  parameter [0:0] ZINV_T3 = 1'b0;
  parameter [0:0] ZINV_T4 = 1'b0;

  parameter [0:0] ZINIT_OQ = 1'b0;
  parameter [0:0] ZINIT_TQ = 1'b0;
  parameter [0:0] ZSRVAL_OQ = 1'b0;
  parameter [0:0] ZSRVAL_TQ = 1'b0;
endmodule

module ISERDESE2_IDELAY_VPR (
  input  BITSLIP,
  input  CE1,
  input  CE2,
  input  CLK,
  input  CLKB,
  input  CLKDIV,
  input  RST,
  input  DDLY,
  output Q1,
  output Q2,
  output Q3,
  output Q4,
  output Q5,
  output Q6,
  output Q7,
  output Q8
  );

  parameter [0:0] MEMORY_DDR3_4     = 1'b0;
  parameter [0:0] MEMORY_DDR_4      = 1'b0;
  parameter [0:0] MEMORY_QDR_4      = 1'b0;

  parameter [0:0] NETWORKING_SDR_2  = 1'b0;
  parameter [0:0] NETWORKING_SDR_3  = 1'b0;
  parameter [0:0] NETWORKING_SDR_4  = 1'b0;
  parameter [0:0] NETWORKING_SDR_5  = 1'b0;
  parameter [0:0] NETWORKING_SDR_6  = 1'b0;
  parameter [0:0] NETWORKING_SDR_7  = 1'b0;
  parameter [0:0] NETWORKING_SDR_8  = 1'b0;

  parameter [0:0] NETWORKING_DDR_4  = 1'b0;
  parameter [0:0] NETWORKING_DDR_6  = 1'b0;
  parameter [0:0] NETWORKING_DDR_8  = 1'b0;
  parameter [0:0] NETWORKING_DDR_10 = 1'b0;
  parameter [0:0] NETWORKING_DDR_14 = 1'b0;

  parameter [0:0] OVERSAMPLE_DDR_4  = 1'b0;

  parameter [0:0] NUM_CE_N1 = 1'b0;
  parameter [0:0] NUM_CE_N2 = 1'b1;

  parameter [0:0] IOBDELAY_IFD = 1'b0;
  parameter [0:0] IOBDELAY_IBUF = 1'b0;

  parameter [0:0] ZINIT_Q1 = 1'b0;
  parameter [0:0] ZINIT_Q2 = 1'b0;
  parameter [0:0] ZINIT_Q3 = 1'b0;
  parameter [0:0] ZINIT_Q4 = 1'b0;

  parameter [0:0] ZSRVAL_Q1 = 1'b0;
  parameter [0:0] ZSRVAL_Q2 = 1'b0;
  parameter [0:0] ZSRVAL_Q3 = 1'b0;
  parameter [0:0] ZSRVAL_Q4 = 1'b0;

  parameter [0:0] ZINV_D = 1'b0;
  parameter [0:0] ZINV_C = 1'b0;

endmodule

module ISERDESE2_NO_IDELAY_VPR (
  input  BITSLIP,
  input  CE1,
  input  CE2,
  input  CLK,
  input  CLKB,
  input  CLKDIV,
  input  RST,
  input  D,
  output Q1,
  output Q2,
  output Q3,
  output Q4,
  output Q5,
  output Q6,
  output Q7,
  output Q8
  );

  parameter [0:0] MEMORY_DDR3_4     = 1'b0;
  parameter [0:0] MEMORY_DDR_4      = 1'b0;
  parameter [0:0] MEMORY_QDR_4      = 1'b0;

  parameter [0:0] NETWORKING_SDR_2  = 1'b0;
  parameter [0:0] NETWORKING_SDR_3  = 1'b0;
  parameter [0:0] NETWORKING_SDR_4  = 1'b0;
  parameter [0:0] NETWORKING_SDR_5  = 1'b0;
  parameter [0:0] NETWORKING_SDR_6  = 1'b0;
  parameter [0:0] NETWORKING_SDR_7  = 1'b0;
  parameter [0:0] NETWORKING_SDR_8  = 1'b0;

  parameter [0:0] NETWORKING_DDR_4  = 1'b0;
  parameter [0:0] NETWORKING_DDR_6  = 1'b0;
  parameter [0:0] NETWORKING_DDR_8  = 1'b0;
  parameter [0:0] NETWORKING_DDR_10 = 1'b0;
  parameter [0:0] NETWORKING_DDR_14 = 1'b0;

  parameter [0:0] OVERSAMPLE_DDR_4  = 1'b0;

  parameter [0:0] NUM_CE_N1 = 1'b0;
  parameter [0:0] NUM_CE_N2 = 1'b1;

  parameter [0:0] IOBDELAY_IFD = 1'b0;
  parameter [0:0] IOBDELAY_IBUF = 1'b0;

  parameter [0:0] ZINIT_Q1 = 1'b0;
  parameter [0:0] ZINIT_Q2 = 1'b0;
  parameter [0:0] ZINIT_Q3 = 1'b0;
  parameter [0:0] ZINIT_Q4 = 1'b0;

  parameter [0:0] ZSRVAL_Q1 = 1'b0;
  parameter [0:0] ZSRVAL_Q2 = 1'b0;
  parameter [0:0] ZSRVAL_Q3 = 1'b0;
  parameter [0:0] ZSRVAL_Q4 = 1'b0;

  parameter [0:0] ZINV_D = 1'b0;
  parameter [0:0] ZINV_C = 1'b0;

endmodule

// ============================================================================
// IDDR/ODDR

(* blackbox *)
module IDDR_VPR (
  input  CK,
  input  CKB,
  input  CE,
  input  SR,
  input  D,
  output Q1,
  output Q2
);

  parameter [0:0] ZINV_D = 1'b1;
  parameter [0:0] ZINV_C = 1'b1;

  parameter [0:0] SRTYPE_SYNC = 1'b0;

  parameter [0:0] SAME_EDGE     = 1'b0;
  parameter [0:0] OPPOSITE_EDGE = 1'b0;

  parameter [0:0] ZINIT_Q1   = 1'b0;
  parameter [0:0] ZINIT_Q2   = 1'b0;
  parameter [0:0] ZINIT_Q3   = 1'b0;
  parameter [0:0] ZINIT_Q4   = 1'b0;
  parameter [0:0] ZSRVAL_Q12 = 1'b0;
  parameter [0:0] ZSRVAL_Q34 = 1'b0;

endmodule

(* blackbox *)
module ODDR_VPR (
  input  CK,
  input  CE,
  input  SR,
  input  D1,
  input  D2,
  output Q
);

  parameter [0:0] ZINV_CLK = 1'b1;
  parameter [0:0] ZINV_D1  = 1'b1;
  parameter [0:0] ZINV_D2  = 1'b1;
  
  parameter [0:0] INV_D1  = 1'b0;
  parameter [0:0] INV_D2  = 1'b0;

  parameter [0:0] SRTYPE_SYNC = 1'b0;
  parameter [0:0] SAME_EDGE   = 1'b1;

  parameter [0:0] ZINIT_Q  = 1'b1;
  parameter [0:0] ZSRVAL_Q = 1'b1;

endmodule

// ============================================================================
// IDELAYE2

module IDELAYE2_VPR (
  input C,
  input CE,
  input CINVCTRL,
  input CNTVALUEIN0,
  input CNTVALUEIN1,
  input CNTVALUEIN2,
  input CNTVALUEIN3,
  input CNTVALUEIN4,
  input DATAIN,
  input IDATAIN,
  input INC,
  input LD,
  input LDPIPEEN,
  input REGRST,

  output CNTVALUEOUT0,
  output CNTVALUEOUT1,
  output CNTVALUEOUT2,
  output CNTVALUEOUT3,
  output CNTVALUEOUT4,
  output DATAOUT
  );

  parameter [0:0] IN_USE = 1'b0;

  parameter [4:0] IDELAY_VALUE = 5'b00000;
  parameter [4:0] ZIDELAY_VALUE = 5'b11111;

  parameter [0:0] PIPE_SEL = 1'b0;
  parameter [0:0] CINVCTRL_SEL = 1'b0;
  parameter [0:0] DELAY_SRC_DATAIN = 1'b0;
  parameter [0:0] DELAY_SRC_IDATAIN = 1'b0;
  parameter [0:0] HIGH_PERFORMANCE_MODE = 1'b0;

  parameter [0:0] DELAY_TYPE_FIXED = 1'b0;
  parameter [0:0] DELAY_TYPE_VAR_LOAD = 1'b0;
  parameter [0:0] DELAY_TYPE_VARIABLE = 1'b0;

  parameter [0:0] IS_DATAIN_INVERTED = 1'b0;
  parameter [0:0] IS_IDATAIN_INVERTED = 1'b0;

endmodule

// ============================================================================
// Clock Buffers

// BUFGCTRL_VPR
module BUFGCTRL_VPR
(
output O,
input I0, input I1,
input S0, input S1,
input CE0, input CE1,
input IGNORE0, input IGNORE1
);

  parameter [0:0] INIT_OUT = 1'b0;
  parameter [0:0] ZPRESELECT_I0 = 1'b0;
  parameter [0:0] ZPRESELECT_I1 = 1'b0;
  parameter [0:0] ZINV_CE0 = 1'b0;
  parameter [0:0] ZINV_CE1 = 1'b0;
  parameter [0:0] ZINV_S0 = 1'b0;
  parameter [0:0] ZINV_S1 = 1'b0;
  parameter [0:0] IS_IGNORE0_INVERTED = 1'b0;
  parameter [0:0] IS_IGNORE1_INVERTED = 1'b0;

  wire I0_internal = ((CE0 ^ !ZINV_CE0) ? I0 : INIT_OUT);
  wire I1_internal = ((CE1 ^ !ZINV_CE1) ? I1 : INIT_OUT);
  wire S0_true = (S0 ^ !ZINV_S0);
  wire S1_true = (S1 ^ !ZINV_S1);

  assign O = S0_true ? I0_internal : (S1_true ? I1_internal : INIT_OUT);

endmodule

// BUFHCE_VPR
module BUFHCE_VPR
(
output O,
input I,
input CE
);

  parameter [0:0] INIT_OUT = 1'b0;
  parameter CE_TYPE = "SYNC";
  parameter [0:0] ZINV_CE = 1'b0;

  wire I = ((CE ^ !ZINV_CE) ? I : INIT_OUT);

  assign O = I;

endmodule

// ============================================================================
// CMT

// PLLE2_ADV_VPR
(* blackbox *)
module PLLE2_ADV_VPR
(
input         CLKFBIN,
input         CLKIN1,
input         CLKIN2,
input         CLKINSEL,

output        CLKFBOUT,
output        CLKOUT0,
output        CLKOUT1,
output        CLKOUT2,
output        CLKOUT3,
output        CLKOUT4,
output        CLKOUT5,

input         PWRDWN,
input         RST,
output        LOCKED,

input         DCLK,
input         DEN,
input         DWE,
output        DRDY,
input  [ 6:0] DADDR,
input  [15:0] DI,
output [15:0] DO
);

  parameter [0:0] INV_CLKINSEL = 1'd0;
  parameter [0:0] ZINV_PWRDWN = 1'd0;
  parameter [0:0] ZINV_RST = 1'd1;

  parameter [0:0] STARTUP_WAIT = 1'd0;

  // Tables
  parameter [9:0] TABLE = 10'd0;
  parameter [39:0] LKTABLE = 40'd0;
  parameter [15:0] POWER_REG = 16'd0;
  parameter [11:0] FILTREG1_RESERVED = 12'd0;
  parameter [9:0] FILTREG2_RESERVED = 10'd0;
  parameter [5:0] LOCKREG1_RESERVED = 6'd0;
  parameter [0:0] LOCKREG2_RESERVED = 1'b0;
  parameter [0:0] LOCKREG3_RESERVED = 1'b0;

  // DIVCLK
  parameter [5:0] DIVCLK_DIVCLK_HIGH_TIME = 6'd0;
  parameter [5:0] DIVCLK_DIVCLK_LOW_TIME = 6'd0;
  parameter [0:0] DIVCLK_DIVCLK_NO_COUNT = 1'b1;
  parameter [0:0] DIVCLK_DIVCLK_EDGE = 1'b0;

  // CLKFBOUT
  parameter [5:0] CLKFBOUT_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKFBOUT_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKFBOUT_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT0
  parameter [5:0] CLKOUT0_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT0_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT0_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT1
  parameter [5:0] CLKOUT1_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT1_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT1_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT1_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT1_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT1_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT1_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT1_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT2
  parameter [5:0] CLKOUT2_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT2_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT2_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT2_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT2_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT2_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT2_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT2_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT3
  parameter [5:0] CLKOUT3_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT3_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT3_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT3_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT3_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT3_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT3_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT3_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT4
  parameter [5:0] CLKOUT4_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT4_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT4_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT4_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT4_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT4_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT4_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT4_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT5
  parameter [5:0] CLKOUT5_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT5_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT5_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT5_CLKOUT2_NO_COUNT = 1'b1;


  // TODO: Compensation parameters

  // TODO: How to simulate a PLL in verilog (i.e. the VCO) ???

endmodule

// MMCME2_ADV_VPR
(* blackbox *)
module MMCME2_ADV_VPR
(
input     CLKFBIN,
input     CLKIN1,
input     CLKIN2,
input     CLKINSEL,

output    CLKFBOUT,
output    CLKFBOUTB,
output    CLKOUT0,
output    CLKOUT0B,
output    CLKOUT1,
output    CLKOUT1B,
output    CLKOUT2,
output    CLKOUT2B,
output    CLKOUT3,
output    CLKOUT3B,
output    CLKOUT4,
output    CLKOUT5,
output    CLKOUT6,

output    CLKINSTOPPED,
output    CLKFBSTOPPED,

input     PWRDWN,
input     RST,
output    LOCKED,

input     PSCLK,
input     PSEN,
input     PSINCDEC,
output    PSDONE,

input     DCLK,
input     DEN,
input     DWE,
output    DRDY,
input     DADDR0,
input     DADDR1,
input     DADDR2,
input     DADDR3,
input     DADDR4,
input     DADDR5,
input     DADDR6,
input     DI0,
input     DI1,
input     DI2,
input     DI3,
input     DI4,
input     DI5,
input     DI6,
input     DI7,
input     DI8,
input     DI9,
input     DI10,
input     DI11,
input     DI12,
input     DI13,
input     DI14,
input     DI15,
output    DO0,
output    DO1,
output    DO2,
output    DO3,
output    DO4,
output    DO5,
output    DO6,
output    DO7,
output    DO8,
output    DO9,
output    DO10,
output    DO11,
output    DO12,
output    DO13,
output    DO14,
output    DO15
);

  parameter [0:0] INV_CLKINSEL = 1'd0;
  parameter [0:0] ZINV_PWRDWN = 1'd0;
  parameter [0:0] ZINV_RST = 1'd1;
  parameter [0:0] ZINV_PSEN = 1'd1;
  parameter [0:0] ZINV_PSINCDEC = 1'd1;

  parameter [0:0] STARTUP_WAIT = 1'd0;

  // Compensation
  parameter [0:0] COMP_ZHOLD = 1'd0;
  parameter [0:0] COMP_Z_ZHOLD = 1'd0;

  // Spread spectrum
  parameter [0:0] SS_EN = 1'd0;
  // TODO: Fuzz and add more

  // Tables
  parameter [9:0] TABLE = 10'd0;
  parameter [39:0] LKTABLE = 40'd0;
  parameter [15:0] POWER_REG = 16'd0;
  parameter [11:0] FILTREG1_RESERVED = 12'd0;
  parameter [9:0] FILTREG2_RESERVED = 10'd0;
  parameter [5:0] LOCKREG1_RESERVED = 6'd0;
  parameter [0:0] LOCKREG2_RESERVED = 1'b0;
  parameter [0:0] LOCKREG3_RESERVED = 1'b0;

  // DIVCLK
  parameter [5:0] DIVCLK_DIVCLK_HIGH_TIME = 6'd0;
  parameter [5:0] DIVCLK_DIVCLK_LOW_TIME = 6'd0;
  parameter [0:0] DIVCLK_DIVCLK_NO_COUNT = 1'b1;
  parameter [0:0] DIVCLK_DIVCLK_EDGE = 1'b0;

  // CLKFBOUT
  parameter [5:0] CLKFBOUT_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKFBOUT_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKFBOUT_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKFBOUT_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKFBOUT_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT0
  parameter [5:0] CLKOUT0_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT0_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT0_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_EDGE = 1'b0;
  parameter [2:0] CLKOUT0_CLKOUT2_FRAC = 3'd0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_EN = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_FRAC_WF_R = 1'b0;
  parameter [0:0] CLKOUT0_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT1
  parameter [5:0] CLKOUT1_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT1_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT1_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT1_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT1_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT1_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT2
  parameter [5:0] CLKOUT2_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT2_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT2_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT2_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT2_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT2_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT3
  parameter [5:0] CLKOUT3_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT3_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT3_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT3_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT3_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT3_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT4
  parameter [5:0] CLKOUT4_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT4_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT4_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT4_CLKOUT2_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT4_CLKOUT2_EDGE = 1'b0;
  parameter [0:0] CLKOUT4_CLKOUT2_NO_COUNT = 1'b1;

  // CLKOUT5
  parameter [5:0] CLKOUT5_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT5_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT5_CLKOUT2_FRACTIONAL_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRACTIONAL_EDGE = 1'b0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRACTIONAL_FRAC_WF_F = 1'd0;
  parameter [0:0] CLKOUT5_CLKOUT2_FRACTIONAL_NO_COUNT = 1'b0;
  parameter [2:0] CLKOUT5_CLKOUT1_FRACTIONAL_PHASE_MUX_F = 3'd0;

  // CLKOUT6
  parameter [5:0] CLKOUT6_CLKOUT1_HIGH_TIME = 6'd0;
  parameter [5:0] CLKOUT6_CLKOUT1_LOW_TIME = 6'd0;
  parameter [0:0] CLKOUT6_CLKOUT1_OUTPUT_ENABLE = 1'b0;
  parameter [2:0] CLKOUT6_CLKOUT1_PHASE_MUX = 3'd0;
  parameter [5:0] CLKOUT6_CLKOUT2_FRACTIONAL_DELAY_TIME = 6'd0;
  parameter [0:0] CLKOUT6_CLKOUT2_FRACTIONAL_EDGE = 1'b0;
  parameter [0:0] CLKOUT6_CLKOUT2_FRACTIONAL_FRAC_WF_F = 1'd0;
  parameter [0:0] CLKOUT6_CLKOUT2_FRACTIONAL_NO_COUNT = 1'b0;
  parameter [2:0] CLKOUT6_CLKOUT1_FRACTIONAL_PHASE_MUX_F = 3'd0;

endmodule

// ============================================================================
// The Zynq PS7

(* blackbox *)
module PS7_VPR (
  input  [ 3: 0] DDRARB,
  input          DMA0ACLK,
  input          DMA0DAREADY,
  output [ 1: 0] DMA0DATYPE,
  output         DMA0DAVALID,
  input          DMA0DRLAST,
  output         DMA0DRREADY,
  input  [ 1: 0] DMA0DRTYPE,
  input          DMA0DRVALID,
  output         DMA0RSTN,
  input          DMA1ACLK,
  input          DMA1DAREADY,
  output [ 1: 0] DMA1DATYPE,
  output         DMA1DAVALID,
  input          DMA1DRLAST,
  output         DMA1DRREADY,
  input  [ 1: 0] DMA1DRTYPE,
  input          DMA1DRVALID,
  output         DMA1RSTN,
  input          DMA2ACLK,
  input          DMA2DAREADY,
  output [ 1: 0] DMA2DATYPE,
  output         DMA2DAVALID,
  input          DMA2DRLAST,
  output         DMA2DRREADY,
  input  [ 1: 0] DMA2DRTYPE,
  input          DMA2DRVALID,
  output         DMA2RSTN,
  input          DMA3ACLK,
  input          DMA3DAREADY,
  output [ 1: 0] DMA3DATYPE,
  output         DMA3DAVALID,
  input          DMA3DRLAST,
  output         DMA3DRREADY,
  input  [ 1: 0] DMA3DRTYPE,
  input          DMA3DRVALID,
  output         DMA3RSTN,
  input          EMIOCAN0PHYRX,
  output         EMIOCAN0PHYTX,
  input          EMIOCAN1PHYRX,
  output         EMIOCAN1PHYTX,
  input          EMIOENET0EXTINTIN,
  input          EMIOENET0GMIICOL,
  input          EMIOENET0GMIICRS,
  input          EMIOENET0GMIIRXCLK,
  input  [ 7: 0] EMIOENET0GMIIRXD,
  input          EMIOENET0GMIIRXDV,
  input          EMIOENET0GMIIRXER,
  input          EMIOENET0GMIITXCLK,
  output [ 7: 0] EMIOENET0GMIITXD,
  output         EMIOENET0GMIITXEN,
  output         EMIOENET0GMIITXER,
  input          EMIOENET0MDIOI,
  output         EMIOENET0MDIOMDC,
  output         EMIOENET0MDIOO,
  output         EMIOENET0MDIOTN,
  output         EMIOENET0PTPDELAYREQRX,
  output         EMIOENET0PTPDELAYREQTX,
  output         EMIOENET0PTPPDELAYREQRX,
  output         EMIOENET0PTPPDELAYREQTX,
  output         EMIOENET0PTPPDELAYRESPRX,
  output         EMIOENET0PTPPDELAYRESPTX,
  output         EMIOENET0PTPSYNCFRAMERX,
  output         EMIOENET0PTPSYNCFRAMETX,
  output         EMIOENET0SOFRX,
  output         EMIOENET0SOFTX,
  input          EMIOENET1EXTINTIN,
  input          EMIOENET1GMIICOL,
  input          EMIOENET1GMIICRS,
  input          EMIOENET1GMIIRXCLK,
  input  [ 7: 0] EMIOENET1GMIIRXD,
  input          EMIOENET1GMIIRXDV,
  input          EMIOENET1GMIIRXER,
  input          EMIOENET1GMIITXCLK,
  output [ 7: 0] EMIOENET1GMIITXD,
  output         EMIOENET1GMIITXEN,
  output         EMIOENET1GMIITXER,
  input          EMIOENET1MDIOI,
  output         EMIOENET1MDIOMDC,
  output         EMIOENET1MDIOO,
  output         EMIOENET1MDIOTN,
  output         EMIOENET1PTPDELAYREQRX,
  output         EMIOENET1PTPDELAYREQTX,
  output         EMIOENET1PTPPDELAYREQRX,
  output         EMIOENET1PTPPDELAYREQTX,
  output         EMIOENET1PTPPDELAYRESPRX,
  output         EMIOENET1PTPPDELAYRESPTX,
  output         EMIOENET1PTPSYNCFRAMERX,
  output         EMIOENET1PTPSYNCFRAMETX,
  output         EMIOENET1SOFRX,
  output         EMIOENET1SOFTX,
  input  [63: 0] EMIOGPIOI,
  output [63: 0] EMIOGPIOO,
  output [63: 0] EMIOGPIOTN,
  input          EMIOI2C0SCLI,
  output         EMIOI2C0SCLO,
  output         EMIOI2C0SCLTN,
  input          EMIOI2C0SDAI,
  output         EMIOI2C0SDAO,
  output         EMIOI2C0SDATN,
  input          EMIOI2C1SCLI,
  output         EMIOI2C1SCLO,
  output         EMIOI2C1SCLTN,
  input          EMIOI2C1SDAI,
  output         EMIOI2C1SDAO,
  output         EMIOI2C1SDATN,
  input          EMIOPJTAGTCK,
  input          EMIOPJTAGTDI,
  output         EMIOPJTAGTDO,
  output         EMIOPJTAGTDTN,
  input          EMIOPJTAGTMS,
  output         EMIOSDIO0BUSPOW,
  output [ 2: 0] EMIOSDIO0BUSVOLT,
  input          EMIOSDIO0CDN,
  output         EMIOSDIO0CLK,
  input          EMIOSDIO0CLKFB,
  input          EMIOSDIO0CMDI,
  output         EMIOSDIO0CMDO,
  output         EMIOSDIO0CMDTN,
  input  [ 3: 0] EMIOSDIO0DATAI,
  output [ 3: 0] EMIOSDIO0DATAO,
  output [ 3: 0] EMIOSDIO0DATATN,
  output         EMIOSDIO0LED,
  input          EMIOSDIO0WP,
  output         EMIOSDIO1BUSPOW,
  output [ 2: 0] EMIOSDIO1BUSVOLT,
  input          EMIOSDIO1CDN,
  output         EMIOSDIO1CLK,
  input          EMIOSDIO1CLKFB,
  input          EMIOSDIO1CMDI,
  output         EMIOSDIO1CMDO,
  output         EMIOSDIO1CMDTN,
  input  [ 3: 0] EMIOSDIO1DATAI,
  output [ 3: 0] EMIOSDIO1DATAO,
  output [ 3: 0] EMIOSDIO1DATATN,
  output         EMIOSDIO1LED,
  input          EMIOSDIO1WP,
  input          EMIOSPI0MI,
  output         EMIOSPI0MO,
  output         EMIOSPI0MOTN,
  input          EMIOSPI0SCLKI,
  output         EMIOSPI0SCLKO,
  output         EMIOSPI0SCLKTN,
  input          EMIOSPI0SI,
  output         EMIOSPI0SO,
  input          EMIOSPI0SSIN,
  output         EMIOSPI0SSNTN,
  output [ 2: 0] EMIOSPI0SSON,
  output         EMIOSPI0STN,
  input          EMIOSPI1MI,
  output         EMIOSPI1MO,
  output         EMIOSPI1MOTN,
  input          EMIOSPI1SCLKI,
  output         EMIOSPI1SCLKO,
  output         EMIOSPI1SCLKTN,
  input          EMIOSPI1SI,
  output         EMIOSPI1SO,
  input          EMIOSPI1SSIN,
  output         EMIOSPI1SSNTN,
  output [ 2: 0] EMIOSPI1SSON,
  output         EMIOSPI1STN,
  input          EMIOSRAMINTIN,
  input          EMIOTRACECLK,
  output         EMIOTRACECTL,
  output [31: 0] EMIOTRACEDATA,
  input  [ 2: 0] EMIOTTC0CLKI,
  output [ 2: 0] EMIOTTC0WAVEO,
  input  [ 2: 0] EMIOTTC1CLKI,
  output [ 2: 0] EMIOTTC1WAVEO,
  input          EMIOUART0CTSN,
  input          EMIOUART0DCDN,
  input          EMIOUART0DSRN,
  output         EMIOUART0DTRN,
  input          EMIOUART0RIN,
  output         EMIOUART0RTSN,
  input          EMIOUART0RX,
  output         EMIOUART0TX,
  input          EMIOUART1CTSN,
  input          EMIOUART1DCDN,
  input          EMIOUART1DSRN,
  output         EMIOUART1DTRN,
  input          EMIOUART1RIN,
  output         EMIOUART1RTSN,
  input          EMIOUART1RX,
  output         EMIOUART1TX,
  output [ 1: 0] EMIOUSB0PORTINDCTL,
  input          EMIOUSB0VBUSPWRFAULT,
  output         EMIOUSB0VBUSPWRSELECT,
  output [ 1: 0] EMIOUSB1PORTINDCTL,
  input          EMIOUSB1VBUSPWRFAULT,
  output         EMIOUSB1VBUSPWRSELECT,
  input          EMIOWDTCLKI,
  output         EMIOWDTRSTO,
  input          EVENTEVENTI,
  output         EVENTEVENTO,
  output [ 1: 0] EVENTSTANDBYWFE,
  output [ 1: 0] EVENTSTANDBYWFI,
  output [ 3: 0] FCLKCLK,
  input  [ 3: 0] FCLKCLKTRIGN,
  output [ 3: 0] FCLKRESETN,
  input          FPGAIDLEN,
  input  [ 3: 0] FTMDTRACEINATID,
  input          FTMDTRACEINCLOCK,
  input  [31: 0] FTMDTRACEINDATA,
  input          FTMDTRACEINVALID,
  input  [31: 0] FTMTF2PDEBUG,
  input  [ 3: 0] FTMTF2PTRIG,
  output [ 3: 0] FTMTF2PTRIGACK,
  output [31: 0] FTMTP2FDEBUG,
  output [ 3: 0] FTMTP2FTRIG,
  input  [ 3: 0] FTMTP2FTRIGACK,
  input  [19: 0] IRQF2P,
  output [28: 0] IRQP2F,
  input          MAXIGP0ACLK,
  output [31: 0] MAXIGP0ARADDR,
  output [ 1: 0] MAXIGP0ARBURST,
  output [ 3: 0] MAXIGP0ARCACHE,
  output         MAXIGP0ARESETN,
  output [11: 0] MAXIGP0ARID,
  output [ 3: 0] MAXIGP0ARLEN,
  output [ 1: 0] MAXIGP0ARLOCK,
  output [ 2: 0] MAXIGP0ARPROT,
  output [ 3: 0] MAXIGP0ARQOS,
  input          MAXIGP0ARREADY,
  output [ 1: 0] MAXIGP0ARSIZE,
  output         MAXIGP0ARVALID,
  output [31: 0] MAXIGP0AWADDR,
  output [ 1: 0] MAXIGP0AWBURST,
  output [ 3: 0] MAXIGP0AWCACHE,
  output [11: 0] MAXIGP0AWID,
  output [ 3: 0] MAXIGP0AWLEN,
  output [ 1: 0] MAXIGP0AWLOCK,
  output [ 2: 0] MAXIGP0AWPROT,
  output [ 3: 0] MAXIGP0AWQOS,
  input          MAXIGP0AWREADY,
  output [ 1: 0] MAXIGP0AWSIZE,
  output         MAXIGP0AWVALID,
  input  [11: 0] MAXIGP0BID,
  output         MAXIGP0BREADY,
  input  [ 1: 0] MAXIGP0BRESP,
  input          MAXIGP0BVALID,
  input  [31: 0] MAXIGP0RDATA,
  input  [11: 0] MAXIGP0RID,
  input          MAXIGP0RLAST,
  output         MAXIGP0RREADY,
  input  [ 1: 0] MAXIGP0RRESP,
  input          MAXIGP0RVALID,
  output [31: 0] MAXIGP0WDATA,
  output [11: 0] MAXIGP0WID,
  output         MAXIGP0WLAST,
  input          MAXIGP0WREADY,
  output [ 3: 0] MAXIGP0WSTRB,
  output         MAXIGP0WVALID,
  input          MAXIGP1ACLK,
  output [31: 0] MAXIGP1ARADDR,
  output [ 1: 0] MAXIGP1ARBURST,
  output [ 3: 0] MAXIGP1ARCACHE,
  output         MAXIGP1ARESETN,
  output [11: 0] MAXIGP1ARID,
  output [ 3: 0] MAXIGP1ARLEN,
  output [ 1: 0] MAXIGP1ARLOCK,
  output [ 2: 0] MAXIGP1ARPROT,
  output [ 3: 0] MAXIGP1ARQOS,
  input          MAXIGP1ARREADY,
  output [ 1: 0] MAXIGP1ARSIZE,
  output         MAXIGP1ARVALID,
  output [31: 0] MAXIGP1AWADDR,
  output [ 1: 0] MAXIGP1AWBURST,
  output [ 3: 0] MAXIGP1AWCACHE,
  output [11: 0] MAXIGP1AWID,
  output [ 3: 0] MAXIGP1AWLEN,
  output [ 1: 0] MAXIGP1AWLOCK,
  output [ 2: 0] MAXIGP1AWPROT,
  output [ 3: 0] MAXIGP1AWQOS,
  input          MAXIGP1AWREADY,
  output [ 1: 0] MAXIGP1AWSIZE,
  output         MAXIGP1AWVALID,
  input  [11: 0] MAXIGP1BID,
  output         MAXIGP1BREADY,
  input  [ 1: 0] MAXIGP1BRESP,
  input          MAXIGP1BVALID,
  input  [31: 0] MAXIGP1RDATA,
  input  [11: 0] MAXIGP1RID,
  input          MAXIGP1RLAST,
  output         MAXIGP1RREADY,
  input  [ 1: 0] MAXIGP1RRESP,
  input          MAXIGP1RVALID,
  output [31: 0] MAXIGP1WDATA,
  output [11: 0] MAXIGP1WID,
  output         MAXIGP1WLAST,
  input          MAXIGP1WREADY,
  output [ 3: 0] MAXIGP1WSTRB,
  output         MAXIGP1WVALID,
  input          SAXIACPACLK,
  input  [31: 0] SAXIACPARADDR,
  input  [ 1: 0] SAXIACPARBURST,
  input  [ 3: 0] SAXIACPARCACHE,
  output         SAXIACPARESETN,
  input  [ 2: 0] SAXIACPARID,
  input  [ 3: 0] SAXIACPARLEN,
  input  [ 1: 0] SAXIACPARLOCK,
  input  [ 2: 0] SAXIACPARPROT,
  input  [ 3: 0] SAXIACPARQOS,
  output         SAXIACPARREADY,
  input  [ 1: 0] SAXIACPARSIZE,
  input  [ 4: 0] SAXIACPARUSER,
  input          SAXIACPARVALID,
  input  [31: 0] SAXIACPAWADDR,
  input  [ 1: 0] SAXIACPAWBURST,
  input  [ 3: 0] SAXIACPAWCACHE,
  input  [ 2: 0] SAXIACPAWID,
  input  [ 3: 0] SAXIACPAWLEN,
  input  [ 1: 0] SAXIACPAWLOCK,
  input  [ 2: 0] SAXIACPAWPROT,
  input  [ 3: 0] SAXIACPAWQOS,
  output         SAXIACPAWREADY,
  input  [ 1: 0] SAXIACPAWSIZE,
  input  [ 4: 0] SAXIACPAWUSER,
  input          SAXIACPAWVALID,
  output [ 2: 0] SAXIACPBID,
  input          SAXIACPBREADY,
  output [ 1: 0] SAXIACPBRESP,
  output         SAXIACPBVALID,
  output [63: 0] SAXIACPRDATA,
  output [ 2: 0] SAXIACPRID,
  output         SAXIACPRLAST,
  input          SAXIACPRREADY,
  output [ 1: 0] SAXIACPRRESP,
  output         SAXIACPRVALID,
  input  [63: 0] SAXIACPWDATA,
  input  [ 2: 0] SAXIACPWID,
  input          SAXIACPWLAST,
  output         SAXIACPWREADY,
  input  [ 7: 0] SAXIACPWSTRB,
  input          SAXIACPWVALID,
  input          SAXIGP0ACLK,
  input  [31: 0] SAXIGP0ARADDR,
  input  [ 1: 0] SAXIGP0ARBURST,
  input  [ 3: 0] SAXIGP0ARCACHE,
  output         SAXIGP0ARESETN,
  input  [ 5: 0] SAXIGP0ARID,
  input  [ 3: 0] SAXIGP0ARLEN,
  input  [ 1: 0] SAXIGP0ARLOCK,
  input  [ 2: 0] SAXIGP0ARPROT,
  input  [ 3: 0] SAXIGP0ARQOS,
  output         SAXIGP0ARREADY,
  input  [ 1: 0] SAXIGP0ARSIZE,
  input          SAXIGP0ARVALID,
  input  [31: 0] SAXIGP0AWADDR,
  input  [ 1: 0] SAXIGP0AWBURST,
  input  [ 3: 0] SAXIGP0AWCACHE,
  input  [ 5: 0] SAXIGP0AWID,
  input  [ 3: 0] SAXIGP0AWLEN,
  input  [ 1: 0] SAXIGP0AWLOCK,
  input  [ 2: 0] SAXIGP0AWPROT,
  input  [ 3: 0] SAXIGP0AWQOS,
  output         SAXIGP0AWREADY,
  input  [ 1: 0] SAXIGP0AWSIZE,
  input          SAXIGP0AWVALID,
  output [ 5: 0] SAXIGP0BID,
  input          SAXIGP0BREADY,
  output [ 1: 0] SAXIGP0BRESP,
  output         SAXIGP0BVALID,
  output [31: 0] SAXIGP0RDATA,
  output [ 5: 0] SAXIGP0RID,
  output         SAXIGP0RLAST,
  input          SAXIGP0RREADY,
  output [ 1: 0] SAXIGP0RRESP,
  output         SAXIGP0RVALID,
  input  [31: 0] SAXIGP0WDATA,
  input  [ 5: 0] SAXIGP0WID,
  input          SAXIGP0WLAST,
  output         SAXIGP0WREADY,
  input  [ 3: 0] SAXIGP0WSTRB,
  input          SAXIGP0WVALID,
  input          SAXIGP1ACLK,
  input  [31: 0] SAXIGP1ARADDR,
  input  [ 1: 0] SAXIGP1ARBURST,
  input  [ 3: 0] SAXIGP1ARCACHE,
  output         SAXIGP1ARESETN,
  input  [ 5: 0] SAXIGP1ARID,
  input  [ 3: 0] SAXIGP1ARLEN,
  input  [ 1: 0] SAXIGP1ARLOCK,
  input  [ 2: 0] SAXIGP1ARPROT,
  input  [ 3: 0] SAXIGP1ARQOS,
  output         SAXIGP1ARREADY,
  input  [ 1: 0] SAXIGP1ARSIZE,
  input          SAXIGP1ARVALID,
  input  [31: 0] SAXIGP1AWADDR,
  input  [ 1: 0] SAXIGP1AWBURST,
  input  [ 3: 0] SAXIGP1AWCACHE,
  input  [ 5: 0] SAXIGP1AWID,
  input  [ 3: 0] SAXIGP1AWLEN,
  input  [ 1: 0] SAXIGP1AWLOCK,
  input  [ 2: 0] SAXIGP1AWPROT,
  input  [ 3: 0] SAXIGP1AWQOS,
  output         SAXIGP1AWREADY,
  input  [ 1: 0] SAXIGP1AWSIZE,
  input          SAXIGP1AWVALID,
  output [ 5: 0] SAXIGP1BID,
  input          SAXIGP1BREADY,
  output [ 1: 0] SAXIGP1BRESP,
  output         SAXIGP1BVALID,
  output [31: 0] SAXIGP1RDATA,
  output [ 5: 0] SAXIGP1RID,
  output         SAXIGP1RLAST,
  input          SAXIGP1RREADY,
  output [ 1: 0] SAXIGP1RRESP,
  output         SAXIGP1RVALID,
  input  [31: 0] SAXIGP1WDATA,
  input  [ 5: 0] SAXIGP1WID,
  input          SAXIGP1WLAST,
  output         SAXIGP1WREADY,
  input  [ 3: 0] SAXIGP1WSTRB,
  input          SAXIGP1WVALID,
  input          SAXIHP0ACLK,
  input  [31: 0] SAXIHP0ARADDR,
  input  [ 1: 0] SAXIHP0ARBURST,
  input  [ 3: 0] SAXIHP0ARCACHE,
  output         SAXIHP0ARESETN,
  input  [ 5: 0] SAXIHP0ARID,
  input  [ 3: 0] SAXIHP0ARLEN,
  input  [ 1: 0] SAXIHP0ARLOCK,
  input  [ 2: 0] SAXIHP0ARPROT,
  input  [ 3: 0] SAXIHP0ARQOS,
  output         SAXIHP0ARREADY,
  input  [ 1: 0] SAXIHP0ARSIZE,
  input          SAXIHP0ARVALID,
  input  [31: 0] SAXIHP0AWADDR,
  input  [ 1: 0] SAXIHP0AWBURST,
  input  [ 3: 0] SAXIHP0AWCACHE,
  input  [ 5: 0] SAXIHP0AWID,
  input  [ 3: 0] SAXIHP0AWLEN,
  input  [ 1: 0] SAXIHP0AWLOCK,
  input  [ 2: 0] SAXIHP0AWPROT,
  input  [ 3: 0] SAXIHP0AWQOS,
  output         SAXIHP0AWREADY,
  input  [ 1: 0] SAXIHP0AWSIZE,
  input          SAXIHP0AWVALID,
  output [ 5: 0] SAXIHP0BID,
  input          SAXIHP0BREADY,
  output [ 1: 0] SAXIHP0BRESP,
  output         SAXIHP0BVALID,
  output [ 2: 0] SAXIHP0RACOUNT,
  output [ 7: 0] SAXIHP0RCOUNT,
  output [63: 0] SAXIHP0RDATA,
  input          SAXIHP0RDISSUECAP1EN,
  output [ 5: 0] SAXIHP0RID,
  output         SAXIHP0RLAST,
  input          SAXIHP0RREADY,
  output [ 1: 0] SAXIHP0RRESP,
  output         SAXIHP0RVALID,
  output [ 5: 0] SAXIHP0WACOUNT,
  output [ 7: 0] SAXIHP0WCOUNT,
  input  [63: 0] SAXIHP0WDATA,
  input  [ 5: 0] SAXIHP0WID,
  input          SAXIHP0WLAST,
  output         SAXIHP0WREADY,
  input          SAXIHP0WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP0WSTRB,
  input          SAXIHP0WVALID,
  input          SAXIHP1ACLK,
  input  [31: 0] SAXIHP1ARADDR,
  input  [ 1: 0] SAXIHP1ARBURST,
  input  [ 3: 0] SAXIHP1ARCACHE,
  output         SAXIHP1ARESETN,
  input  [ 5: 0] SAXIHP1ARID,
  input  [ 3: 0] SAXIHP1ARLEN,
  input  [ 1: 0] SAXIHP1ARLOCK,
  input  [ 2: 0] SAXIHP1ARPROT,
  input  [ 3: 0] SAXIHP1ARQOS,
  output         SAXIHP1ARREADY,
  input  [ 1: 0] SAXIHP1ARSIZE,
  input          SAXIHP1ARVALID,
  input  [31: 0] SAXIHP1AWADDR,
  input  [ 1: 0] SAXIHP1AWBURST,
  input  [ 3: 0] SAXIHP1AWCACHE,
  input  [ 5: 0] SAXIHP1AWID,
  input  [ 3: 0] SAXIHP1AWLEN,
  input  [ 1: 0] SAXIHP1AWLOCK,
  input  [ 2: 0] SAXIHP1AWPROT,
  input  [ 3: 0] SAXIHP1AWQOS,
  output         SAXIHP1AWREADY,
  input  [ 1: 0] SAXIHP1AWSIZE,
  input          SAXIHP1AWVALID,
  output [ 5: 0] SAXIHP1BID,
  input          SAXIHP1BREADY,
  output [ 1: 0] SAXIHP1BRESP,
  output         SAXIHP1BVALID,
  output [ 2: 0] SAXIHP1RACOUNT,
  output [ 7: 0] SAXIHP1RCOUNT,
  output [63: 0] SAXIHP1RDATA,
  input          SAXIHP1RDISSUECAP1EN,
  output [ 5: 0] SAXIHP1RID,
  output         SAXIHP1RLAST,
  input          SAXIHP1RREADY,
  output [ 1: 0] SAXIHP1RRESP,
  output         SAXIHP1RVALID,
  output [ 5: 0] SAXIHP1WACOUNT,
  output [ 7: 0] SAXIHP1WCOUNT,
  input  [63: 0] SAXIHP1WDATA,
  input  [ 5: 0] SAXIHP1WID,
  input          SAXIHP1WLAST,
  output         SAXIHP1WREADY,
  input          SAXIHP1WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP1WSTRB,
  input          SAXIHP1WVALID,
  input          SAXIHP2ACLK,
  input  [31: 0] SAXIHP2ARADDR,
  input  [ 1: 0] SAXIHP2ARBURST,
  input  [ 3: 0] SAXIHP2ARCACHE,
  output         SAXIHP2ARESETN,
  input  [ 5: 0] SAXIHP2ARID,
  input  [ 3: 0] SAXIHP2ARLEN,
  input  [ 1: 0] SAXIHP2ARLOCK,
  input  [ 2: 0] SAXIHP2ARPROT,
  input  [ 3: 0] SAXIHP2ARQOS,
  output         SAXIHP2ARREADY,
  input  [ 1: 0] SAXIHP2ARSIZE,
  input          SAXIHP2ARVALID,
  input  [31: 0] SAXIHP2AWADDR,
  input  [ 1: 0] SAXIHP2AWBURST,
  input  [ 3: 0] SAXIHP2AWCACHE,
  input  [ 5: 0] SAXIHP2AWID,
  input  [ 3: 0] SAXIHP2AWLEN,
  input  [ 1: 0] SAXIHP2AWLOCK,
  input  [ 2: 0] SAXIHP2AWPROT,
  input  [ 3: 0] SAXIHP2AWQOS,
  output         SAXIHP2AWREADY,
  input  [ 1: 0] SAXIHP2AWSIZE,
  input          SAXIHP2AWVALID,
  output [ 5: 0] SAXIHP2BID,
  input          SAXIHP2BREADY,
  output [ 1: 0] SAXIHP2BRESP,
  output         SAXIHP2BVALID,
  output [ 2: 0] SAXIHP2RACOUNT,
  output [ 7: 0] SAXIHP2RCOUNT,
  output [63: 0] SAXIHP2RDATA,
  input          SAXIHP2RDISSUECAP1EN,
  output [ 5: 0] SAXIHP2RID,
  output         SAXIHP2RLAST,
  input          SAXIHP2RREADY,
  output [ 1: 0] SAXIHP2RRESP,
  output         SAXIHP2RVALID,
  output [ 5: 0] SAXIHP2WACOUNT,
  output [ 7: 0] SAXIHP2WCOUNT,
  input  [63: 0] SAXIHP2WDATA,
  input  [ 5: 0] SAXIHP2WID,
  input          SAXIHP2WLAST,
  output         SAXIHP2WREADY,
  input          SAXIHP2WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP2WSTRB,
  input          SAXIHP2WVALID,
  input          SAXIHP3ACLK,
  input  [31: 0] SAXIHP3ARADDR,
  input  [ 1: 0] SAXIHP3ARBURST,
  input  [ 3: 0] SAXIHP3ARCACHE,
  output         SAXIHP3ARESETN,
  input  [ 5: 0] SAXIHP3ARID,
  input  [ 3: 0] SAXIHP3ARLEN,
  input  [ 1: 0] SAXIHP3ARLOCK,
  input  [ 2: 0] SAXIHP3ARPROT,
  input  [ 3: 0] SAXIHP3ARQOS,
  output         SAXIHP3ARREADY,
  input  [ 1: 0] SAXIHP3ARSIZE,
  input          SAXIHP3ARVALID,
  input  [31: 0] SAXIHP3AWADDR,
  input  [ 1: 0] SAXIHP3AWBURST,
  input  [ 3: 0] SAXIHP3AWCACHE,
  input  [ 5: 0] SAXIHP3AWID,
  input  [ 3: 0] SAXIHP3AWLEN,
  input  [ 1: 0] SAXIHP3AWLOCK,
  input  [ 2: 0] SAXIHP3AWPROT,
  input  [ 3: 0] SAXIHP3AWQOS,
  output         SAXIHP3AWREADY,
  input  [ 1: 0] SAXIHP3AWSIZE,
  input          SAXIHP3AWVALID,
  output [ 5: 0] SAXIHP3BID,
  input          SAXIHP3BREADY,
  output [ 1: 0] SAXIHP3BRESP,
  output         SAXIHP3BVALID,
  output [ 2: 0] SAXIHP3RACOUNT,
  output [ 7: 0] SAXIHP3RCOUNT,
  output [63: 0] SAXIHP3RDATA,
  input          SAXIHP3RDISSUECAP1EN,
  output [ 5: 0] SAXIHP3RID,
  output         SAXIHP3RLAST,
  input          SAXIHP3RREADY,
  output [ 1: 0] SAXIHP3RRESP,
  output         SAXIHP3RVALID,
  output [ 5: 0] SAXIHP3WACOUNT,
  output [ 7: 0] SAXIHP3WCOUNT,
  input  [63: 0] SAXIHP3WDATA,
  input  [ 5: 0] SAXIHP3WID,
  input          SAXIHP3WLAST,
  output         SAXIHP3WREADY,
  input          SAXIHP3WRISSUECAP1EN,
  input  [ 7: 0] SAXIHP3WSTRB,
  input          SAXIHP3WVALID
);

endmodule

module BANK();

parameter KEEP = 1;
parameter DONT_TOUCH = 1;
parameter FASM_EXTRA = "";
parameter INTERNAL_VREF = "";
parameter NUMBER = "";

endmodule

module IPAD_GTP_VPR (
  input I,
  output O
  );

  assign O = I;
endmodule

module OPAD_GTP_VPR (
  input I,
  output O
  );

  assign O = I;
endmodule

module IBUFDS_GTE2_VPR (
  output O,
  output ODIV2,
  input CEB,
  input I,
  input IB
  );

  parameter CLKCM_CFG = 1'b1;
  parameter CLKRCV_TRST = 1'b1;
endmodule

module GTPE2_COMMON_VPR (
  output DRPRDY,
  output PLL0FBCLKLOST,
  output PLL0LOCK,
  output PLL0OUTCLK,
  output PLL0OUTREFCLK,
  output PLL0REFCLKLOST,
  output PLL1FBCLKLOST,
  output PLL1LOCK,
  output PLL1OUTCLK,
  output PLL1OUTREFCLK,
  output PLL1REFCLKLOST,
  output REFCLKOUTMONITOR0,
  output REFCLKOUTMONITOR1,
  output [15:0] DRPDO,
  output [15:0] PMARSVDOUT,
  output [7:0] DMONITOROUT,
  input BGBYPASSB,
  input BGMONITORENB,
  input BGPDB,
  input BGRCALOVRDENB,
  input DRPCLK,
  input DRPEN,
  input DRPWE,
  input GTREFCLK0,
  input GTREFCLK1,
  input GTGREFCLK0,
  input GTGREFCLK1,
  input PLL0LOCKDETCLK,
  input PLL0LOCKEN,
  input PLL0PD,
  input PLL0RESET,
  input PLL1LOCKDETCLK,
  input PLL1LOCKEN,
  input PLL1PD,
  input PLL1RESET,
  input RCALENB,
  input [15:0] DRPDI,
  input [2:0] PLL0REFCLKSEL,
  input [2:0] PLL1REFCLKSEL,
  input [4:0] BGRCALOVRD,
  input [7:0] DRPADDR,
  input [7:0] PMARSVD
);
  parameter [63:0] BIAS_CFG = 64'h0000000000000000;
  parameter [31:0] COMMON_CFG = 32'h00000000;
  parameter [26:0] PLL0_CFG = 27'h01F03DC;
  parameter [0:0] PLL0_DMON_CFG = 1'b0;
  parameter [5:0] PLL0_FBDIV = 6'b000010;
  parameter PLL0_FBDIV_45 = 1'b1;
  parameter [23:0] PLL0_INIT_CFG = 24'h00001E;
  parameter [8:0] PLL0_LOCK_CFG = 9'h1E8;
  parameter [4:0] PLL0_REFCLK_DIV = 5'b10000;
  parameter [26:0] PLL1_CFG = 27'h01F03DC;
  parameter [0:0] PLL1_DMON_CFG = 1'b0;
  parameter [5:0] PLL1_FBDIV = 6'b000010;
  parameter PLL1_FBDIV_45 = 1'b1;
  parameter [23:0] PLL1_INIT_CFG = 24'h00001E;
  parameter [8:0] PLL1_LOCK_CFG = 9'h1E8;
  parameter [4:0] PLL1_REFCLK_DIV = 5'b10000;
  parameter [7:0] PLL_CLKOUT_CFG = 8'b00000000;
  parameter [15:0] RSVD_ATTR0 = 16'h0000;
  parameter [15:0] RSVD_ATTR1 = 16'h0000;
  parameter INV_DRPCLK = 1'b0;
  parameter INV_PLL1LOCKDETCLK = 1'b0;
  parameter INV_PLL0LOCKDETCLK = 1'b0;
  parameter GTREFCLK0_USED = 1'b0;
  parameter GTREFCLK1_USED = 1'b0;
  parameter BOTH_GTREFCLK_USED = 1'b0;
  parameter ENABLE_DRP = 1'b1;

  // This parameter should never be changed according to UG482 (v1.9), pg 24
  parameter [1:0] IBUFDS_GTE2_CLKSWING_CFG = 2'b11;

endmodule

module GTPE2_CHANNEL_VPR (
  input GTPRXN,
  input GTPRXP,
  output GTPTXN,
  output GTPTXP,
  output DRPRDY,
  output EYESCANDATAERROR,
  output PHYSTATUS,
  output PMARSVDOUT0,
  output PMARSVDOUT1,
  output RXBYTEISALIGNED,
  output RXBYTEREALIGN,
  output RXCDRLOCK,
  output RXCHANBONDSEQ,
  output RXCHANISALIGNED,
  output RXCHANREALIGN,
  output RXCOMINITDET,
  output RXCOMMADET,
  output RXCOMSASDET,
  output RXCOMWAKEDET,
  output RXDLYSRESETDONE,
  output RXELECIDLE,
  output RXHEADERVALID,
  output RXOSINTDONE,
  output RXOSINTSTARTED,
  output RXOSINTSTROBEDONE,
  output RXOSINTSTROBESTARTED,
  output RXOUTCLK,
  output RXOUTCLKFABRIC,
  output RXOUTCLKPCS,
  output RXPHALIGNDONE,
  output RXPMARESETDONE,
  output RXPRBSERR,
  output RXRATEDONE,
  output RXRESETDONE,
  output RXSYNCDONE,
  output RXSYNCOUT,
  output RXVALID,
  output TXCOMFINISH,
  output TXDLYSRESETDONE,
  output TXGEARBOXREADY,
  output TXOUTCLK,
  output TXOUTCLKFABRIC,
  output TXOUTCLKPCS,
  output TXPHALIGNDONE,
  output TXPHINITDONE,
  output TXPMARESETDONE,
  output TXRATEDONE,
  output TXRESETDONE,
  output TXSYNCDONE,
  output TXSYNCOUT,
  output [14:0] DMONITOROUT,
  output [15:0] DRPDO,
  output [15:0] PCSRSVDOUT,
  output [1:0] RXCLKCORCNT,
  output [1:0] RXDATAVALID,
  output [1:0] RXSTARTOFSEQ,
  output [1:0] TXBUFSTATUS,
  output [2:0] RXBUFSTATUS,
  output [2:0] RXHEADER,
  output [2:0] RXSTATUS,
  output [31:0] RXDATA,
  output [3:0] RXCHARISCOMMA,
  output [3:0] RXCHARISK,
  output [3:0] RXCHBONDO,
  output [3:0] RXDISPERR,
  output [3:0] RXNOTINTABLE,
  output [4:0] RXPHMONITOR,
  output [4:0] RXPHSLIPMONITOR,
  input CFGRESET,
  input CLKRSVD0,
  input CLKRSVD1,
  input DMONFIFORESET,
  input DMONITORCLK,
  input DRPCLK,
  input DRPEN,
  input DRPWE,
  input EYESCANMODE,
  input EYESCANRESET,
  input EYESCANTRIGGER,
  input GTRESETSEL,
  input GTRXRESET,
  input GTTXRESET,
  input PMARSVDIN0,
  input PMARSVDIN1,
  input PMARSVDIN2,
  input PMARSVDIN3,
  input PMARSVDIN4,
  input RESETOVRD,
  input RX8B10BEN,
  input RXBUFRESET,
  input RXCDRFREQRESET,
  input RXCDRHOLD,
  input RXCDROVRDEN,
  input RXCDRRESET,
  input RXCDRRESETRSV,
  input RXCHBONDEN,
  input RXCHBONDMASTER,
  input RXCHBONDSLAVE,
  input RXCOMMADETEN,
  input RXDDIEN,
  input RXDFEXYDEN,
  input RXDLYBYPASS,
  input RXDLYEN,
  input RXDLYOVRDEN,
  input RXDLYSRESET,
  input RXGEARBOXSLIP,
  input RXLPMHFHOLD,
  input RXLPMHFOVRDEN,
  input RXLPMLFHOLD,
  input RXLPMLFOVRDEN,
  input RXLPMOSINTNTRLEN,
  input RXLPMRESET,
  input RXMCOMMAALIGNEN,
  input RXOOBRESET,
  input RXOSCALRESET,
  input RXOSHOLD,
  input RXOSINTEN,
  input RXOSINTHOLD,
  input RXOSINTNTRLEN,
  input RXOSINTOVRDEN,
  input RXOSINTPD,
  input RXOSINTSTROBE,
  input RXOSINTTESTOVRDEN,
  input RXOSOVRDEN,
  input RXPCOMMAALIGNEN,
  input RXPCSRESET,
  input RXPHALIGN,
  input RXPHALIGNEN,
  input RXPHDLYPD,
  input RXPHDLYRESET,
  input RXPHOVRDEN,
  input RXPMARESET,
  input RXPOLARITY,
  input RXPRBSCNTRESET,
  input RXRATEMODE,
  input RXSLIDE,
  input RXSYNCALLIN,
  input RXSYNCIN,
  input RXSYNCMODE,
  input RXUSERRDY,
  input RXUSRCLK2,
  input RXUSRCLK,
  input SETERRSTATUS,
  input SIGVALIDCLK,
  input TX8B10BEN,
  input TXCOMINIT,
  input TXCOMSAS,
  input TXCOMWAKE,
  input TXDEEMPH,
  input TXDETECTRX,
  input TXDIFFPD,
  input TXDLYBYPASS,
  input TXDLYEN,
  input TXDLYHOLD,
  input TXDLYOVRDEN,
  input TXDLYSRESET,
  input TXDLYUPDOWN,
  input TXELECIDLE,
  input TXINHIBIT,
  input TXPCSRESET,
  input TXPDELECIDLEMODE,
  input TXPHALIGN,
  input TXPHALIGNEN,
  input TXPHDLYPD,
  input TXPHDLYRESET,
  input TXPHDLYTSTCLK,
  input TXPHINIT,
  input TXPHOVRDEN,
  input TXPIPPMEN,
  input TXPIPPMOVRDEN,
  input TXPIPPMPD,
  input TXPIPPMSEL,
  input TXPISOPD,
  input TXPMARESET,
  input TXPOLARITY,
  input TXPOSTCURSORINV,
  input TXPRBSFORCEERR,
  input TXPRECURSORINV,
  input TXRATEMODE,
  input TXSTARTSEQ,
  input TXSWING,
  input TXSYNCALLIN,
  input TXSYNCIN,
  input TXSYNCMODE,
  input TXUSERRDY,
  input TXUSRCLK2,
  input TXUSRCLK,
  input [13:0] RXADAPTSELTEST,
  input [15:0] DRPDI,
  input [15:0] GTRSVD,
  input [15:0] PCSRSVDIN,
  input [19:0] TSTIN,
  input [1:0] RXELECIDLEMODE,
  input [1:0] RXPD,
  input [1:0] RXSYSCLKSEL,
  input [1:0] TXPD,
  input [1:0] TXSYSCLKSEL,
  input [2:0] LOOPBACK,
  input [2:0] RXCHBONDLEVEL,
  input [2:0] RXOUTCLKSEL,
  input [2:0] RXPRBSSEL,
  input [2:0] RXRATE,
  input [2:0] TXBUFDIFFCTRL,
  input [2:0] TXHEADER,
  input [2:0] TXMARGIN,
  input [2:0] TXOUTCLKSEL,
  input [2:0] TXPRBSSEL,
  input [2:0] TXRATE,
  input [31:0] TXDATA,
  input [3:0] RXCHBONDI,
  input [3:0] RXOSINTCFG,
  input [3:0] RXOSINTID0,
  input [3:0] TX8B10BBYPASS,
  input [3:0] TXCHARDISPMODE,
  input [3:0] TXCHARDISPVAL,
  input [3:0] TXCHARISK,
  input [3:0] TXDIFFCTRL,
  input [4:0] TXPIPPMSTEPSIZE,
  input [4:0] TXPOSTCURSOR,
  input [4:0] TXPRECURSOR,
  input [6:0] TXMAINCURSOR,
  input [6:0] TXSEQUENCE,
  input [8:0] DRPADDR
);
  parameter [0:0] ACJTAG_DEBUG_MODE = 1'b0;
  parameter [0:0] ACJTAG_MODE = 1'b0;
  parameter [0:0] ACJTAG_RESET = 1'b0;
  parameter [19:0] ADAPT_CFG0 = 20'b00000000000000000000;
  parameter ALIGN_COMMA_DOUBLE = 1'b0;
  parameter [9:0] ALIGN_COMMA_ENABLE = 10'b0001111111;
  parameter [1:0] ALIGN_COMMA_WORD = 1;
  parameter ALIGN_MCOMMA_DET = 1'b1;
  parameter [9:0] ALIGN_MCOMMA_VALUE = 10'b1010000011;
  parameter ALIGN_PCOMMA_DET = 1'b1;
  parameter [9:0] ALIGN_PCOMMA_VALUE = 10'b0101111100;
  parameter CBCC_DATA_SOURCE_SEL_DECODED = 1'b1;
  parameter [42:0] CFOK_CFG = 43'b1001001000000000000000001000000111010000000;
  parameter [6:0] CFOK_CFG2 = 7'b0100000;
  parameter [6:0] CFOK_CFG3 = 7'b0100000;
  parameter [0:0] CFOK_CFG4 = 1'b0;
  parameter [1:0] CFOK_CFG5 = 2'b00;
  parameter [3:0] CFOK_CFG6 = 4'b0000;
  parameter CHAN_BOND_KEEP_ALIGN = 1'b0;
  parameter [3:0] CHAN_BOND_MAX_SKEW = 7;
  parameter [9:0] CHAN_BOND_SEQ_1_1 = 10'b0101111100;
  parameter [9:0] CHAN_BOND_SEQ_1_2 = 10'b0000000000;
  parameter [9:0] CHAN_BOND_SEQ_1_3 = 10'b0000000000;
  parameter [9:0] CHAN_BOND_SEQ_1_4 = 10'b0000000000;
  parameter [3:0] CHAN_BOND_SEQ_1_ENABLE = 4'b1111;
  parameter [9:0] CHAN_BOND_SEQ_2_1 = 10'b0100000000;
  parameter [9:0] CHAN_BOND_SEQ_2_2 = 10'b0100000000;
  parameter [9:0] CHAN_BOND_SEQ_2_3 = 10'b0100000000;
  parameter [9:0] CHAN_BOND_SEQ_2_4 = 10'b0100000000;
  parameter [3:0] CHAN_BOND_SEQ_2_ENABLE = 4'b1111;
  parameter CHAN_BOND_SEQ_2_USE = 1'b0;
  parameter [1:0] CHAN_BOND_SEQ_LEN = 2'b00;
  parameter [0:0] CLK_COMMON_SWING = 1'b0;
  parameter CLK_CORRECT_USE = 1'b1;
  parameter CLK_COR_KEEP_IDLE = 1'b0;
  parameter [5:0] CLK_COR_MAX_LAT = 20;
  parameter [5:0] CLK_COR_MIN_LAT = 18;
  parameter CLK_COR_PRECEDENCE = 1'b1;
  parameter [4:0] CLK_COR_REPEAT_WAIT = 0;
  parameter [9:0] CLK_COR_SEQ_1_1 = 10'b0100011100;
  parameter [9:0] CLK_COR_SEQ_1_2 = 10'b0000000000;
  parameter [9:0] CLK_COR_SEQ_1_3 = 10'b0000000000;
  parameter [9:0] CLK_COR_SEQ_1_4 = 10'b0000000000;
  parameter [3:0] CLK_COR_SEQ_1_ENABLE = 4'b1111;
  parameter [9:0] CLK_COR_SEQ_2_1 = 10'b0100000000;
  parameter [9:0] CLK_COR_SEQ_2_2 = 10'b0100000000;
  parameter [9:0] CLK_COR_SEQ_2_3 = 10'b0100000000;
  parameter [9:0] CLK_COR_SEQ_2_4 = 10'b0100000000;
  parameter [3:0] CLK_COR_SEQ_2_ENABLE = 4'b1111;
  parameter CLK_COR_SEQ_2_USE = 1'b0;
  parameter [1:0] CLK_COR_SEQ_LEN = 2'b00;
  parameter DEC_MCOMMA_DETECT = 1'b1;
  parameter DEC_PCOMMA_DETECT = 1'b1;
  parameter DEC_VALID_COMMA_ONLY = 1'b1;
  parameter [23:0] DMONITOR_CFG = 24'h000A00;
  parameter [0:0] ES_CLK_PHASE_SEL = 1'b0;
  parameter [5:0] ES_CONTROL = 6'b000000;
  parameter ES_ERRDET_EN = 1'b0;
  parameter ES_EYE_SCAN_EN = 1'b0;
  parameter [11:0] ES_HORZ_OFFSET = 12'h010;
  parameter [9:0] ES_PMA_CFG = 10'b0000000000;
  parameter [4:0] ES_PRESCALE = 5'b00000;
  parameter [79:0] ES_QUALIFIER = 80'h00000000000000000000;
  parameter [79:0] ES_QUAL_MASK = 80'h00000000000000000000;
  parameter [79:0] ES_SDATA_MASK = 80'h00000000000000000000;
  parameter [8:0] ES_VERT_OFFSET = 9'b000000000;
  parameter [3:0] FTS_DESKEW_SEQ_ENABLE = 4'b1111;
  parameter [3:0] FTS_LANE_DESKEW_CFG = 4'b1111;
  parameter FTS_LANE_DESKEW_EN = 1'b0;
  parameter [2:0] GEARBOX_MODE = 3'b000;
  parameter [0:0] LOOPBACK_CFG = 1'b0;
  parameter [1:0] OUTREFCLK_SEL_INV = 2'b11;
  parameter PCS_PCIE_EN = 1'b0;
  parameter [47:0] PCS_RSVD_ATTR = 48'h000000000000;
  parameter [11:0] PD_TRANS_TIME_FROM_P2 = 12'h03C;
  parameter [7:0] PD_TRANS_TIME_NONE_P2 = 8'h19;
  parameter [7:0] PD_TRANS_TIME_TO_P2 = 8'h64;
  parameter [0:0] PMA_LOOPBACK_CFG = 1'b0;
  parameter [31:0] PMA_RSV = 32'h00000333;
  parameter [31:0] PMA_RSV2 = 32'h00002050;
  parameter [1:0] PMA_RSV3 = 2'b00;
  parameter [3:0] PMA_RSV4 = 4'b0000;
  parameter [0:0] PMA_RSV5 = 1'b0;
  parameter [0:0] PMA_RSV6 = 1'b0;
  parameter [0:0] PMA_RSV7 = 1'b0;
  parameter [4:0] RXBUFRESET_TIME = 5'b00001;
  parameter RXBUF_ADDR_MODE_FAST = 1'b0;
  parameter [3:0] RXBUF_EIDLE_HI_CNT = 4'b1000;
  parameter [3:0] RXBUF_EIDLE_LO_CNT = 4'b0000;
  parameter RXBUF_EN = 1'b1;
  parameter RXBUF_RESET_ON_CB_CHANGE = 1'b1;
  parameter RXBUF_RESET_ON_COMMAALIGN = 1'b0;
  parameter RXBUF_RESET_ON_EIDLE = 1'b0;
  parameter RXBUF_RESET_ON_RATE_CHANGE = 1'b1;
  parameter [5:0] RXBUF_THRESH_OVFLW = 61;
  parameter RXBUF_THRESH_OVRD = 1'b0;
  parameter [5:0] RXBUF_THRESH_UNDFLW = 4;
  parameter [4:0] RXCDRFREQRESET_TIME = 5'b00001;
  parameter [4:0] RXCDRPHRESET_TIME = 5'b00001;
  parameter [82:0] RXCDR_CFG = 83'h0000107FE406001041010;
  parameter [0:0] RXCDR_FR_RESET_ON_EIDLE = 1'b0;
  parameter [0:0] RXCDR_HOLD_DURING_EIDLE = 1'b0;
  parameter [5:0] RXCDR_LOCK_CFG = 6'b001001;
  parameter [0:0] RXCDR_PH_RESET_ON_EIDLE = 1'b0;
  parameter [15:0] RXDLY_CFG = 16'h0010;
  parameter [8:0] RXDLY_LCFG = 9'h020;
  parameter [15:0] RXDLY_TAP_CFG = 16'h0000;
  parameter RXGEARBOX_EN = 1'b0;
  parameter [4:0] RXISCANRESET_TIME = 5'b00001;
  parameter [6:0] RXLPMRESET_TIME = 7'b0001111;
  parameter [0:0] RXLPM_BIAS_STARTUP_DISABLE = 1'b0;
  parameter [3:0] RXLPM_CFG = 4'b0110;
  parameter [0:0] RXLPM_CFG1 = 1'b0;
  parameter [0:0] RXLPM_CM_CFG = 1'b0;
  parameter [8:0] RXLPM_GC_CFG = 9'b111100010;
  parameter [2:0] RXLPM_GC_CFG2 = 3'b001;
  parameter [13:0] RXLPM_HF_CFG = 14'b00001111110000;
  parameter [4:0] RXLPM_HF_CFG2 = 5'b01010;
  parameter [3:0] RXLPM_HF_CFG3 = 4'b0000;
  parameter [0:0] RXLPM_HOLD_DURING_EIDLE = 1'b0;
  parameter [0:0] RXLPM_INCM_CFG = 1'b0;
  parameter [0:0] RXLPM_IPCM_CFG = 1'b0;
  parameter [17:0] RXLPM_LF_CFG = 18'b000000001111110000;
  parameter [4:0] RXLPM_LF_CFG2 = 5'b01010;
  parameter [2:0] RXLPM_OSINT_CFG = 3'b100;
  parameter [6:0] RXOOB_CFG = 7'b0000110;
  parameter RXOOB_CLK_CFG_FABRIC = 1'b0;
  parameter [4:0] RXOSCALRESET_TIME = 5'b00011;
  parameter [4:0] RXOSCALRESET_TIMEOUT = 5'b00000;
  parameter [1:0] RXOUT_DIV = 2'b01;
  parameter [4:0] RXPCSRESET_TIME = 5'b00001;
  parameter [23:0] RXPHDLY_CFG = 24'h084000;
  parameter [23:0] RXPH_CFG = 24'hC00002;
  parameter [4:0] RXPH_MONITOR_SEL = 5'b00000;
  parameter [2:0] RXPI_CFG0 = 3'b000;
  parameter [0:0] RXPI_CFG1 = 1'b0;
  parameter [0:0] RXPI_CFG2 = 1'b0;
  parameter [4:0] RXPMARESET_TIME = 5'b00011;
  parameter [0:0] RXPRBS_ERR_LOOPBACK = 1'b0;
  parameter [3:0] RXSLIDE_AUTO_WAIT = 7;
  parameter RXSLIDE_MODE_AUTO = 1'b0;
  parameter RXSLIDE_MODE_PCS = 1'b0;
  parameter RXSLIDE_MODE_PMA = 1'b0;
  parameter [0:0] RXSYNC_MULTILANE = 1'b0;
  parameter [0:0] RXSYNC_OVRD = 1'b0;
  parameter [0:0] RXSYNC_SKIP_DA = 1'b0;
  parameter [15:0] RX_BIAS_CFG = 16'b0000111100110011;
  parameter [5:0] RX_BUFFER_CFG = 6'b000000;
  parameter [4:0] RX_CLK25_DIV = 5'b00110;
  parameter [0:0] RX_CLKMUX_EN = 1'b1;
  parameter [1:0] RX_CM_SEL = 2'b11;
  parameter [3:0] RX_CM_TRIM = 4'b0100;
  parameter [2:0] RX_DATA_WIDTH = 3'b011;
  parameter [5:0] RX_DDI_SEL = 6'b000000;
  parameter [13:0] RX_DEBUG_CFG = 14'b00000000000000;
  parameter RX_DEFER_RESET_BUF_EN = 1'b1;
  parameter RX_DISPERR_SEQ_MATCH = 1'b1;
  parameter [12:0] RX_OS_CFG = 13'b0001111110000;
  parameter [4:0] RX_SIG_VALID_DLY = 5'b01001;
  parameter RX_XCLK_SEL_RXUSR = 1'b0;
  parameter [6:0] SAS_MAX_COM = 64;
  parameter [5:0] SAS_MIN_COM = 36;
  parameter [3:0] SATA_BURST_SEQ_LEN = 4'b1111;
  parameter [2:0] SATA_BURST_VAL = 3'b100;
  parameter [2:0] SATA_EIDLE_VAL = 3'b100;
  parameter [5:0] SATA_MAX_BURST = 8;
  parameter [5:0] SATA_MAX_INIT = 21;
  parameter [5:0] SATA_MAX_WAKE = 7;
  parameter [5:0] SATA_MIN_BURST = 4;
  parameter [5:0] SATA_MIN_INIT = 12;
  parameter [5:0] SATA_MIN_WAKE = 4;
  parameter SATA_PLL_CFG_VCO_1500MHZ = 1'b0;
  parameter SATA_PLL_CFG_VCO_750MHZ = 1'b0;
  parameter SHOW_REALIGN_COMMA = 1'b1;
  parameter SIM_RECEIVER_DETECT_PASS = 1'b1;
  parameter SIM_RESET_SPEEDUP = 1'b1;
  parameter SIM_TX_EIDLE_DRIVE_LEVEL = "X";
  parameter SIM_VERSION = "1.0";
  parameter [14:0] TERM_RCAL_CFG = 15'b100001000010000;
  parameter [2:0] TERM_RCAL_OVRD = 3'b000;
  parameter [7:0] TRANS_TIME_RATE = 8'h0E;
  parameter [31:0] TST_RSV = 32'h00000000;
  parameter TXBUF_EN = 1'b1;
  parameter TXBUF_RESET_ON_RATE_CHANGE = 1'b0;
  parameter [15:0] TXDLY_CFG = 16'h0010;
  parameter [8:0] TXDLY_LCFG = 9'h020;
  parameter [15:0] TXDLY_TAP_CFG = 16'h0000;
  parameter TXGEARBOX_EN = 1'b0;
  parameter [0:0] TXOOB_CFG = 1'b0;
  parameter [1:0] TXOUT_DIV = 2'b01;
  parameter [4:0] TXPCSRESET_TIME = 5'b00001;
  parameter [23:0] TXPHDLY_CFG = 24'h084000;
  parameter [15:0] TXPH_CFG = 16'h0400;
  parameter [4:0] TXPH_MONITOR_SEL = 5'b00000;
  parameter [1:0] TXPI_CFG0 = 2'b00;
  parameter [1:0] TXPI_CFG1 = 2'b00;
  parameter [1:0] TXPI_CFG2 = 2'b00;
  parameter [0:0] TXPI_CFG3 = 1'b0;
  parameter [0:0] TXPI_CFG4 = 1'b0;
  parameter [2:0] TXPI_CFG5 = 3'b000;
  parameter [0:0] TXPI_GREY_SEL = 1'b0;
  parameter [0:0] TXPI_INVSTROBE_SEL = 1'b0;
  parameter TXPI_PPMCLK_SEL_TXUSRCLK2 = 1'b1;
  parameter [7:0] TXPI_PPM_CFG = 8'b00000000;
  parameter [2:0] TXPI_SYNFREQ_PPM = 3'b000;
  parameter [4:0] TXPMARESET_TIME = 5'b00001;
  parameter [0:0] TXSYNC_MULTILANE = 1'b0;
  parameter [0:0] TXSYNC_OVRD = 1'b0;
  parameter [0:0] TXSYNC_SKIP_DA = 1'b0;
  parameter [4:0] TX_CLK25_DIV = 5'b00110;
  parameter [0:0] TX_CLKMUX_EN = 1'b1;
  parameter [2:0] TX_DATA_WIDTH = 3'b011;
  parameter [5:0] TX_DEEMPH0 = 6'b000000;
  parameter [5:0] TX_DEEMPH1 = 6'b000000;
  parameter TX_DRIVE_MODE_PIPE = 1'b0;
  parameter [2:0] TX_EIDLE_ASSERT_DELAY = 3'b110;
  parameter [2:0] TX_EIDLE_DEASSERT_DELAY = 3'b100;
  parameter TX_LOOPBACK_DRIVE_HIZ = 1'b0;
  parameter [0:0] TX_MAINCURSOR_SEL = 1'b0;
  parameter [6:0] TX_MARGIN_FULL_0 = 7'b1001110;
  parameter [6:0] TX_MARGIN_FULL_1 = 7'b1001001;
  parameter [6:0] TX_MARGIN_FULL_2 = 7'b1000101;
  parameter [6:0] TX_MARGIN_FULL_3 = 7'b1000010;
  parameter [6:0] TX_MARGIN_FULL_4 = 7'b1000000;
  parameter [6:0] TX_MARGIN_LOW_0 = 7'b1000110;
  parameter [6:0] TX_MARGIN_LOW_1 = 7'b1000100;
  parameter [6:0] TX_MARGIN_LOW_2 = 7'b1000010;
  parameter [6:0] TX_MARGIN_LOW_3 = 7'b1000000;
  parameter [6:0] TX_MARGIN_LOW_4 = 7'b1000000;
  parameter [0:0] TX_PREDRIVER_MODE = 1'b0;
  parameter [13:0] TX_RXDETECT_CFG = 14'h1832;
  parameter [2:0] TX_RXDETECT_REF = 3'b100;
  parameter TX_XCLK_SEL_TXUSR = 1'b1;
  parameter [0:0] UCODEER_CLR = 1'b0;
  parameter [0:0] USE_PCS_CLK_PHASE_SEL = 1'b0;

  parameter INV_TXUSRCLK = 1'b1;
  parameter INV_TXUSRCLK2 = 1'b1;
  parameter INV_TXPHDLYTSTCLK = 1'b1;
  parameter INV_SIGVALIDCLK = 1'b1;
  parameter INV_RXUSRCLK = 1'b1;
  parameter INV_RXUSRCLK2 = 1'b1;
  parameter INV_DRPCLK = 1'b1;
  parameter INV_DMONITORCLK = 1'b1;
  parameter INV_CLKRSVD0 = 1'b1;
  parameter INV_CLKRSVD1 = 1'b1;
endmodule

module PCIE_2_1_VPR (
  output CFGAERECRCCHECKEN,
  output CFGAERECRCGENEN,
  input [4:0] CFGAERINTERRUPTMSGNUM,
  output CFGAERROOTERRCORRERRRECEIVED,
  output CFGAERROOTERRCORRERRREPORTINGEN,
  output CFGAERROOTERRFATALERRRECEIVED,
  output CFGAERROOTERRFATALERRREPORTINGEN,
  output CFGAERROOTERRNONFATALERRRECEIVED,
  output CFGAERROOTERRNONFATALERRREPORTINGEN,
  output CFGBRIDGESERREN,
  output CFGCOMMANDBUSMASTERENABLE,
  output CFGCOMMANDINTERRUPTDISABLE,
  output CFGCOMMANDIOENABLE,
  output CFGCOMMANDMEMENABLE,
  output CFGCOMMANDSERREN,
  output CFGDEVCONTROL2ARIFORWARDEN,
  output CFGDEVCONTROL2ATOMICEGRESSBLOCK,
  output CFGDEVCONTROL2ATOMICREQUESTEREN,
  output CFGDEVCONTROL2CPLTIMEOUTDIS,
  output [3:0] CFGDEVCONTROL2CPLTIMEOUTVAL,
  output CFGDEVCONTROL2IDOCPLEN,
  output CFGDEVCONTROL2IDOREQEN,
  output CFGDEVCONTROL2LTREN,
  output CFGDEVCONTROL2TLPPREFIXBLOCK,
  output CFGDEVCONTROLAUXPOWEREN,
  output CFGDEVCONTROLCORRERRREPORTINGEN,
  output CFGDEVCONTROLENABLERO,
  output CFGDEVCONTROLEXTTAGEN,
  output CFGDEVCONTROLFATALERRREPORTINGEN,
  output [2:0] CFGDEVCONTROLMAXPAYLOAD,
  output [2:0] CFGDEVCONTROLMAXREADREQ,
  output CFGDEVCONTROLNONFATALREPORTINGEN,
  output CFGDEVCONTROLNOSNOOPEN,
  output CFGDEVCONTROLPHANTOMEN,
  output CFGDEVCONTROLURERRREPORTINGEN,
  input [15:0] CFGDEVID,
  output CFGDEVSTATUSCORRERRDETECTED,
  output CFGDEVSTATUSFATALERRDETECTED,
  output CFGDEVSTATUSNONFATALERRDETECTED,
  output CFGDEVSTATUSURDETECTED,
  input [7:0] CFGDSBUSNUMBER,
  input [4:0] CFGDSDEVICENUMBER,
  input [2:0] CFGDSFUNCTIONNUMBER,
  input [63:0] CFGDSN,
  input CFGERRACSN,
  input [127:0] CFGERRAERHEADERLOG,
  output CFGERRAERHEADERLOGSETN,
  input CFGERRATOMICEGRESSBLOCKEDN,
  input CFGERRCORN,
  input CFGERRCPLABORTN,
  output CFGERRCPLRDYN,
  input CFGERRCPLTIMEOUTN,
  input CFGERRCPLUNEXPECTN,
  input CFGERRECRCN,
  input CFGERRINTERNALCORN,
  input CFGERRINTERNALUNCORN,
  input CFGERRLOCKEDN,
  input CFGERRMALFORMEDN,
  input CFGERRMCBLOCKEDN,
  input CFGERRNORECOVERYN,
  input CFGERRPOISONEDN,
  input CFGERRPOSTEDN,
  input [47:0] CFGERRTLPCPLHEADER,
  input CFGERRURN,
  input CFGFORCECOMMONCLOCKOFF,
  input CFGFORCEEXTENDEDSYNCON,
  input [2:0] CFGFORCEMPS,
  input CFGINTERRUPTASSERTN,
  input [7:0] CFGINTERRUPTDI,
  output [7:0] CFGINTERRUPTDO,
  output [2:0] CFGINTERRUPTMMENABLE,
  output CFGINTERRUPTMSIENABLE,
  output CFGINTERRUPTMSIXENABLE,
  output CFGINTERRUPTMSIXFM,
  input CFGINTERRUPTN,
  output CFGINTERRUPTRDYN,
  input CFGINTERRUPTSTATN,
  output [1:0] CFGLINKCONTROLASPMCONTROL,
  output CFGLINKCONTROLAUTOBANDWIDTHINTEN,
  output CFGLINKCONTROLBANDWIDTHINTEN,
  output CFGLINKCONTROLCLOCKPMEN,
  output CFGLINKCONTROLCOMMONCLOCK,
  output CFGLINKCONTROLEXTENDEDSYNC,
  output CFGLINKCONTROLHWAUTOWIDTHDIS,
  output CFGLINKCONTROLLINKDISABLE,
  output CFGLINKCONTROLRCB,
  output CFGLINKCONTROLRETRAINLINK,
  output CFGLINKSTATUSAUTOBANDWIDTHSTATUS,
  output CFGLINKSTATUSBANDWIDTHSTATUS,
  output [1:0] CFGLINKSTATUSCURRENTSPEED,
  output CFGLINKSTATUSDLLACTIVE,
  output CFGLINKSTATUSLINKTRAINING,
  output [3:0] CFGLINKSTATUSNEGOTIATEDWIDTH,
  input [3:0] CFGMGMTBYTEENN,
  input [31:0] CFGMGMTDI,
  output [31:0] CFGMGMTDO,
  input [9:0] CFGMGMTDWADDR,
  input CFGMGMTRDENN,
  output CFGMGMTRDWRDONEN,
  input CFGMGMTWRENN,
  input CFGMGMTWRREADONLYN,
  input CFGMGMTWRRW1CASRWN,
  output [15:0] CFGMSGDATA,
  output CFGMSGRECEIVED,
  output CFGMSGRECEIVEDASSERTINTA,
  output CFGMSGRECEIVEDASSERTINTB,
  output CFGMSGRECEIVEDASSERTINTC,
  output CFGMSGRECEIVEDASSERTINTD,
  output CFGMSGRECEIVEDDEASSERTINTA,
  output CFGMSGRECEIVEDDEASSERTINTB,
  output CFGMSGRECEIVEDDEASSERTINTC,
  output CFGMSGRECEIVEDDEASSERTINTD,
  output CFGMSGRECEIVEDERRCOR,
  output CFGMSGRECEIVEDERRFATAL,
  output CFGMSGRECEIVEDERRNONFATAL,
  output CFGMSGRECEIVEDPMASNAK,
  output CFGMSGRECEIVEDPMETO,
  output CFGMSGRECEIVEDPMETOACK,
  output CFGMSGRECEIVEDPMPME,
  output CFGMSGRECEIVEDSETSLOTPOWERLIMIT,
  output CFGMSGRECEIVEDUNLOCK,
  input [4:0] CFGPCIECAPINTERRUPTMSGNUM,
  output [2:0] CFGPCIELINKSTATE,
  output CFGPMCSRPMEEN,
  output CFGPMCSRPMESTATUS,
  output [1:0] CFGPMCSRPOWERSTATE,
  input [1:0] CFGPMFORCESTATE,
  input CFGPMFORCESTATEENN,
  input CFGPMHALTASPML0SN,
  input CFGPMHALTASPML1N,
  output CFGPMRCVASREQL1N,
  output CFGPMRCVENTERL1N,
  output CFGPMRCVENTERL23N,
  output CFGPMRCVREQACKN,
  input CFGPMSENDPMETON,
  input CFGPMTURNOFFOKN,
  input CFGPMWAKEN,
  input [7:0] CFGPORTNUMBER,
  input [7:0] CFGREVID,
  output CFGROOTCONTROLPMEINTEN,
  output CFGROOTCONTROLSYSERRCORRERREN,
  output CFGROOTCONTROLSYSERRFATALERREN,
  output CFGROOTCONTROLSYSERRNONFATALERREN,
  output CFGSLOTCONTROLELECTROMECHILCTLPULSE,
  input [15:0] CFGSUBSYSID,
  input [15:0] CFGSUBSYSVENDID,
  output CFGTRANSACTION,
  output [6:0] CFGTRANSACTIONADDR,
  output CFGTRANSACTIONTYPE,
  input CFGTRNPENDINGN,
  output [6:0] CFGVCTCVCMAP,
  input [15:0] CFGVENDID,
  input CMRSTN,
  input CMSTICKYRSTN,
  input [1:0] DBGMODE,
  output DBGSCLRA,
  output DBGSCLRB,
  output DBGSCLRC,
  output DBGSCLRD,
  output DBGSCLRE,
  output DBGSCLRF,
  output DBGSCLRG,
  output DBGSCLRH,
  output DBGSCLRI,
  output DBGSCLRJ,
  output DBGSCLRK,
  input DBGSUBMODE,
  output [63:0] DBGVECA,
  output [63:0] DBGVECB,
  output [11:0] DBGVECC,
  input DLRSTN,
  input [8:0] DRPADDR,
  input DRPCLK,
  input [15:0] DRPDI,
  output [15:0] DRPDO,
  input DRPEN,
  output DRPRDY,
  input DRPWE,
  input FUNCLVLRSTN,
  output LL2BADDLLPERR,
  output LL2BADTLPERR,
  output [4:0] LL2LINKSTATUS,
  output LL2PROTOCOLERR,
  output LL2RECEIVERERR,
  output LL2REPLAYROERR,
  output LL2REPLAYTOERR,
  input LL2SENDASREQL1,
  input LL2SENDENTERL1,
  input LL2SENDENTERL23,
  input LL2SENDPMACK,
  input LL2SUSPENDNOW,
  output LL2SUSPENDOK,
  output LL2TFCINIT1SEQ,
  output LL2TFCINIT2SEQ,
  input LL2TLPRCV,
  output LL2TXIDLE,
  output LNKCLKEN,
  output [12:0] MIMRXRADDR,
  input [67:0] MIMRXRDATA,
  output MIMRXREN,
  output [12:0] MIMRXWADDR,
  output [67:0] MIMRXWDATA,
  output MIMRXWEN,
  output [12:0] MIMTXRADDR,
  input [68:0] MIMTXRDATA,
  output MIMTXREN,
  output [12:0] MIMTXWADDR,
  output [68:0] MIMTXWDATA,
  output MIMTXWEN,
  input PIPECLK,
  input PIPERX0CHANISALIGNED,
  input [1:0] PIPERX0CHARISK,
  input [15:0] PIPERX0DATA,
  input PIPERX0ELECIDLE,
  input PIPERX0PHYSTATUS,
  output PIPERX0POLARITY,
  input [2:0] PIPERX0STATUS,
  input PIPERX0VALID,
  input PIPERX1CHANISALIGNED,
  input [1:0] PIPERX1CHARISK,
  input [15:0] PIPERX1DATA,
  input PIPERX1ELECIDLE,
  input PIPERX1PHYSTATUS,
  output PIPERX1POLARITY,
  input [2:0] PIPERX1STATUS,
  input PIPERX1VALID,
  input PIPERX2CHANISALIGNED,
  input [1:0] PIPERX2CHARISK,
  input [15:0] PIPERX2DATA,
  input PIPERX2ELECIDLE,
  input PIPERX2PHYSTATUS,
  output PIPERX2POLARITY,
  input [2:0] PIPERX2STATUS,
  input PIPERX2VALID,
  input PIPERX3CHANISALIGNED,
  input [1:0] PIPERX3CHARISK,
  input [15:0] PIPERX3DATA,
  input PIPERX3ELECIDLE,
  input PIPERX3PHYSTATUS,
  output PIPERX3POLARITY,
  input [2:0] PIPERX3STATUS,
  input PIPERX3VALID,
  input PIPERX4CHANISALIGNED,
  input [1:0] PIPERX4CHARISK,
  input [15:0] PIPERX4DATA,
  input PIPERX4ELECIDLE,
  input PIPERX4PHYSTATUS,
  output PIPERX4POLARITY,
  input [2:0] PIPERX4STATUS,
  input PIPERX4VALID,
  input PIPERX5CHANISALIGNED,
  input [1:0] PIPERX5CHARISK,
  input [15:0] PIPERX5DATA,
  input PIPERX5ELECIDLE,
  input PIPERX5PHYSTATUS,
  output PIPERX5POLARITY,
  input [2:0] PIPERX5STATUS,
  input PIPERX5VALID,
  input PIPERX6CHANISALIGNED,
  input [1:0] PIPERX6CHARISK,
  input [15:0] PIPERX6DATA,
  input PIPERX6ELECIDLE,
  input PIPERX6PHYSTATUS,
  output PIPERX6POLARITY,
  input [2:0] PIPERX6STATUS,
  input PIPERX6VALID,
  input PIPERX7CHANISALIGNED,
  input [1:0] PIPERX7CHARISK,
  input [15:0] PIPERX7DATA,
  input PIPERX7ELECIDLE,
  input PIPERX7PHYSTATUS,
  output PIPERX7POLARITY,
  input [2:0] PIPERX7STATUS,
  input PIPERX7VALID,
  output [1:0] PIPETX0CHARISK,
  output PIPETX0COMPLIANCE,
  output [15:0] PIPETX0DATA,
  output PIPETX0ELECIDLE,
  output [1:0] PIPETX0POWERDOWN,
  output [1:0] PIPETX1CHARISK,
  output PIPETX1COMPLIANCE,
  output [15:0] PIPETX1DATA,
  output PIPETX1ELECIDLE,
  output [1:0] PIPETX1POWERDOWN,
  output [1:0] PIPETX2CHARISK,
  output PIPETX2COMPLIANCE,
  output [15:0] PIPETX2DATA,
  output PIPETX2ELECIDLE,
  output [1:0] PIPETX2POWERDOWN,
  output [1:0] PIPETX3CHARISK,
  output PIPETX3COMPLIANCE,
  output [15:0] PIPETX3DATA,
  output PIPETX3ELECIDLE,
  output [1:0] PIPETX3POWERDOWN,
  output [1:0] PIPETX4CHARISK,
  output PIPETX4COMPLIANCE,
  output [15:0] PIPETX4DATA,
  output PIPETX4ELECIDLE,
  output [1:0] PIPETX4POWERDOWN,
  output [1:0] PIPETX5CHARISK,
  output PIPETX5COMPLIANCE,
  output [15:0] PIPETX5DATA,
  output PIPETX5ELECIDLE,
  output [1:0] PIPETX5POWERDOWN,
  output [1:0] PIPETX6CHARISK,
  output PIPETX6COMPLIANCE,
  output [15:0] PIPETX6DATA,
  output PIPETX6ELECIDLE,
  output [1:0] PIPETX6POWERDOWN,
  output [1:0] PIPETX7CHARISK,
  output PIPETX7COMPLIANCE,
  output [15:0] PIPETX7DATA,
  output PIPETX7ELECIDLE,
  output [1:0] PIPETX7POWERDOWN,
  output PIPETXDEEMPH,
  output [2:0] PIPETXMARGIN,
  output PIPETXRATE,
  output PIPETXRCVRDET,
  output PIPETXRESET,
  input [4:0] PL2DIRECTEDLSTATE,
  output PL2L0REQ,
  output PL2LINKUP,
  output PL2RECEIVERERR,
  output PL2RECOVERY,
  output PL2RXELECIDLE,
  output [1:0] PL2RXPMSTATE,
  output PL2SUSPENDOK,
  input [2:0] PLDBGMODE,
  output [11:0] PLDBGVEC,
  output PLDIRECTEDCHANGEDONE,
  input PLDIRECTEDLINKAUTON,
  input [1:0] PLDIRECTEDLINKCHANGE,
  input PLDIRECTEDLINKSPEED,
  input [1:0] PLDIRECTEDLINKWIDTH,
  input [5:0] PLDIRECTEDLTSSMNEW,
  input PLDIRECTEDLTSSMNEWVLD,
  input PLDIRECTEDLTSSMSTALL,
  input PLDOWNSTREAMDEEMPHSOURCE,
  output [2:0] PLINITIALLINKWIDTH,
  output [1:0] PLLANEREVERSALMODE,
  output PLLINKGEN2CAP,
  output PLLINKPARTNERGEN2SUPPORTED,
  output PLLINKUPCFGCAP,
  output [5:0] PLLTSSMSTATE,
  output PLPHYLNKUPN,
  output PLRECEIVEDHOTRST,
  input PLRSTN,
  output [1:0] PLRXPMSTATE,
  output PLSELLNKRATE,
  output [1:0] PLSELLNKWIDTH,
  input PLTRANSMITHOTRST,
  output [2:0] PLTXPMSTATE,
  input PLUPSTREAMPREFERDEEMPH,
  output RECEIVEDFUNCLVLRSTN,
  input SYSRSTN,
  input TL2ASPMSUSPENDCREDITCHECK,
  output TL2ASPMSUSPENDCREDITCHECKOK,
  output TL2ASPMSUSPENDREQ,
  output TL2ERRFCPE,
  output [63:0] TL2ERRHDR,
  output TL2ERRMALFORMED,
  output TL2ERRRXOVERFLOW,
  output TL2PPMSUSPENDOK,
  input TL2PPMSUSPENDREQ,
  input TLRSTN,
  output [11:0] TRNFCCPLD,
  output [7:0] TRNFCCPLH,
  output [11:0] TRNFCNPD,
  output [7:0] TRNFCNPH,
  output [11:0] TRNFCPD,
  output [7:0] TRNFCPH,
  input [2:0] TRNFCSEL,
  output TRNLNKUP,
  output [7:0] TRNRBARHIT,
  output [127:0] TRNRD,
  output [63:0] TRNRDLLPDATA,
  output [1:0] TRNRDLLPSRCRDY,
  input TRNRDSTRDY,
  output TRNRECRCERR,
  output TRNREOF,
  output TRNRERRFWD,
  input TRNRFCPRET,
  input TRNRNPOK,
  input TRNRNPREQ,
  output [1:0] TRNRREM,
  output TRNRSOF,
  output TRNRSRCDSC,
  output TRNRSRCRDY,
  output [5:0] TRNTBUFAV,
  input TRNTCFGGNT,
  output TRNTCFGREQ,
  input [127:0] TRNTD,
  input [31:0] TRNTDLLPDATA,
  output TRNTDLLPDSTRDY,
  input TRNTDLLPSRCRDY,
  output [3:0] TRNTDSTRDY,
  input TRNTECRCGEN,
  input TRNTEOF,
  output TRNTERRDROP,
  input TRNTERRFWD,
  input [1:0] TRNTREM,
  input TRNTSOF,
  input TRNTSRCDSC,
  input TRNTSRCRDY,
  input TRNTSTR,
  input USERCLK,
  input USERCLK2,
  output USERRSTN
);
  parameter [11:0] AER_BASE_PTR = 12'd0;
  parameter AER_CAP_ECRC_CHECK_CAPABLE = "FALSE";
  parameter AER_CAP_ECRC_GEN_CAPABLE = "FALSE";
  parameter [15:0] AER_CAP_ID = 16'd0;
  parameter AER_CAP_MULTIHEADER = "FALSE";
  parameter [11:0] AER_CAP_NEXTPTR = 12'd0;
  parameter AER_CAP_ON = "FALSE";
  parameter [23:0] AER_CAP_OPTIONAL_ERR_SUPPORT = 24'd0;
  parameter AER_CAP_PERMIT_ROOTERR_UPDATE = "FALSE";
  parameter [3:0] AER_CAP_VERSION = 4'd0;
  parameter ALLOW_X8_GEN2 = "FALSE";
  parameter [31:0] BAR0 = 32'd0;
  parameter [31:0] BAR1 = 32'd0;
  parameter [31:0] BAR2 = 32'd0;
  parameter [31:0] BAR3 = 32'd0;
  parameter [31:0] BAR4 = 32'd0;
  parameter [31:0] BAR5 = 32'd0;
  parameter [7:0] CAPABILITIES_PTR = 8'd0;
  parameter [31:0] CARDBUS_CIS_POINTER = 32'd0;
  parameter [23:0] CLASS_CODE = 24'd0;
  parameter CMD_INTX_IMPLEMENTED = "FALSE";
  parameter CPL_TIMEOUT_DISABLE_SUPPORTED = "FALSE";
  parameter [3:0] CPL_TIMEOUT_RANGES_SUPPORTED = 4'd0;
  parameter [6:0] CRM_MODULE_RSTS = 7'd0;
  parameter DEV_CAP2_ARI_FORWARDING_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ATOMICOP32_COMPLETER_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ATOMICOP64_COMPLETER_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ATOMICOP_ROUTING_SUPPORTED = "FALSE";
  parameter DEV_CAP2_CAS128_COMPLETER_SUPPORTED = "FALSE";
  parameter DEV_CAP2_ENDEND_TLP_PREFIX_SUPPORTED = "FALSE";
  parameter DEV_CAP2_EXTENDED_FMT_FIELD_SUPPORTED = "FALSE";
  parameter DEV_CAP2_LTR_MECHANISM_SUPPORTED = "FALSE";
  parameter [1:0] DEV_CAP2_MAX_ENDEND_TLP_PREFIXES = 2'd0;
  parameter DEV_CAP2_NO_RO_ENABLED_PRPR_PASSING = "FALSE";
  parameter [1:0] DEV_CAP2_TPH_COMPLETER_SUPPORTED = 2'd0;
  parameter DEV_CAP_ENABLE_SLOT_PWR_LIMIT_SCALE = "FALSE";
  parameter DEV_CAP_ENABLE_SLOT_PWR_LIMIT_VALUE = "FALSE";
  parameter DEV_CAP_EXT_TAG_SUPPORTED = "FALSE";
  parameter DEV_CAP_FUNCTION_LEVEL_RESET_CAPABLE = "FALSE";
  parameter [2:0] DEV_CAP_MAX_PAYLOAD_SUPPORTED = 3'd0;
  parameter DEV_CAP_ROLE_BASED_ERROR = "FALSE";
  parameter [2:0] DEV_CAP_RSVD_14_12 = 3'd0;
  parameter [1:0] DEV_CAP_RSVD_17_16 = 2'd0;
  parameter [2:0] DEV_CAP_RSVD_31_29 = 3'd0;
  parameter DEV_CONTROL_AUX_POWER_SUPPORTED = "FALSE";
  parameter DEV_CONTROL_EXT_TAG_DEFAULT = "FALSE";
  parameter DISABLE_ASPM_L1_TIMER = "FALSE";
  parameter DISABLE_BAR_FILTERING = "FALSE";
  parameter DISABLE_ERR_MSG = "FALSE";
  parameter DISABLE_ID_CHECK = "FALSE";
  parameter DISABLE_LANE_REVERSAL = "FALSE";
  parameter DISABLE_LOCKED_FILTER = "FALSE";
  parameter DISABLE_PPM_FILTER = "FALSE";
  parameter DISABLE_RX_POISONED_RESP = "FALSE";
  parameter DISABLE_RX_TC_FILTER = "FALSE";
  parameter DISABLE_SCRAMBLING = "FALSE";
  parameter [7:0] DNSTREAM_LINK_NUM = 8'd0;
  parameter [11:0] DSN_BASE_PTR = 12'd0;
  parameter [15:0] DSN_CAP_ID = 16'd0;
  parameter [11:0] DSN_CAP_NEXTPTR = 12'd0;
  parameter DSN_CAP_ON = "FALSE";
  parameter [3:0] DSN_CAP_VERSION = 4'd0;
  parameter [10:0] ENABLE_MSG_ROUTE = 11'd0;
  parameter ENABLE_RX_TD_ECRC_TRIM = "FALSE";
  parameter ENDEND_TLP_PREFIX_FORWARDING_SUPPORTED = "FALSE";
  parameter ENTER_RVRY_EI_L0 = "FALSE";
  parameter EXIT_LOOPBACK_ON_EI = "FALSE";
  parameter [31:0] EXPANSION_ROM = 32'd0;
  parameter [5:0] EXT_CFG_CAP_PTR = 6'd0;
  parameter [9:0] EXT_CFG_XP_CAP_PTR = 10'd0;
  parameter [7:0] HEADER_TYPE = 8'd0;
  parameter [4:0] INFER_EI = 5'd0;
  parameter [7:0] INTERRUPT_PIN = 8'd0;
  parameter INTERRUPT_STAT_AUTO = "FALSE";
  parameter IS_SWITCH = "FALSE";
  parameter [9:0] LAST_CONFIG_DWORD = 10'd0;
  parameter LINK_CAP_ASPM_OPTIONALITY = "FALSE";
  parameter [1:0] LINK_CAP_ASPM_SUPPORT = 2'd0;
  parameter LINK_CAP_CLOCK_POWER_MANAGEMENT = "FALSE";
  parameter LINK_CAP_DLL_LINK_ACTIVE_REPORTING_CAP = "FALSE";
  parameter LINK_CAP_LINK_BANDWIDTH_NOTIFICATION_CAP = "FALSE";
  parameter [3:0] LINK_CAP_MAX_LINK_SPEED = 4'd0;
  parameter [5:0] LINK_CAP_MAX_LINK_WIDTH = 6'd0;
  parameter [0:0] LINK_CAP_RSVD_23 = 1'd0;
  parameter LINK_CAP_SURPRISE_DOWN_ERROR_CAPABLE = "FALSE";
  parameter LINK_CTRL2_DEEMPHASIS = "FALSE";
  parameter LINK_CTRL2_HW_AUTONOMOUS_SPEED_DISABLE = "FALSE";
  parameter [3:0] LINK_CTRL2_TARGET_LINK_SPEED = 4'd0;
  parameter LINK_STATUS_SLOT_CLOCK_CONFIG = "FALSE";
  parameter [14:0] LL_ACK_TIMEOUT = 15'd0;
  parameter LL_ACK_TIMEOUT_EN = "FALSE";
  parameter [1:0] LL_ACK_TIMEOUT_FUNC = 2'd0;
  parameter [14:0] LL_REPLAY_TIMEOUT = 15'd0;
  parameter LL_REPLAY_TIMEOUT_EN = "FALSE";
  parameter [1:0] LL_REPLAY_TIMEOUT_FUNC = 2'd0;
  parameter [5:0] LTSSM_MAX_LINK_WIDTH = 6'd0;
  parameter MPS_FORCE = "FALSE";
  parameter [7:0] MSIX_BASE_PTR = 8'd0;
  parameter [7:0] MSIX_CAP_ID = 8'd0;
  parameter [7:0] MSIX_CAP_NEXTPTR = 8'd0;
  parameter MSIX_CAP_ON = "FALSE";
  parameter [2:0] MSIX_CAP_PBA_BIR = 3'd0;
  parameter [28:0] MSIX_CAP_PBA_OFFSET = 29'd0;
  parameter [2:0] MSIX_CAP_TABLE_BIR = 3'd0;
  parameter [28:0] MSIX_CAP_TABLE_OFFSET = 29'd0;
  parameter [10:0] MSIX_CAP_TABLE_SIZE = 11'd0;
  parameter [7:0] MSI_BASE_PTR = 8'd0;
  parameter MSI_CAP_64_BIT_ADDR_CAPABLE = "FALSE";
  parameter [7:0] MSI_CAP_ID = 8'd0;
  parameter [2:0] MSI_CAP_MULTIMSGCAP = 3'd0;
  parameter [7:0] MSI_CAP_NEXTPTR = 8'd0;
  parameter MSI_CAP_ON = "FALSE";
  parameter MSI_CAP_PER_VECTOR_MASKING_CAPABLE = "FALSE";
  parameter [7:0] N_FTS_COMCLK_GEN1 = 8'd255;
  parameter [7:0] N_FTS_COMCLK_GEN2 = 8'd255;
  parameter [7:0] N_FTS_GEN1 = 8'd255;
  parameter [7:0] N_FTS_GEN2 = 8'd255;
  parameter [7:0] PCIE_BASE_PTR = 8'd0;
  parameter [7:0] PCIE_CAP_CAPABILITY_ID = 8'd0;
  parameter [3:0] PCIE_CAP_CAPABILITY_VERSION = 4'd0;
  parameter [3:0] PCIE_CAP_DEVICE_PORT_TYPE = 4'd0;
  parameter [7:0] PCIE_CAP_NEXTPTR = 8'd0;
  parameter PCIE_CAP_ON = "FALSE";
  parameter [1:0] PCIE_CAP_RSVD_15_14 = 2'd0;
  parameter PCIE_CAP_SLOT_IMPLEMENTED = "FALSE";
  parameter [3:0] PCIE_REVISION = 4'd2;
  parameter PL_FAST_TRAIN = "FALSE";
  parameter [14:0] PM_ASPML0S_TIMEOUT = 15'd0;
  parameter PM_ASPML0S_TIMEOUT_EN = "FALSE";
  parameter [1:0] PM_ASPML0S_TIMEOUT_FUNC = 2'd0;
  parameter PM_ASPM_FASTEXIT = "FALSE";
  parameter [7:0] PM_BASE_PTR = 8'd0;
  parameter PM_CAP_D1SUPPORT = "FALSE";
  parameter PM_CAP_D2SUPPORT = "FALSE";
  parameter PM_CAP_DSI = "FALSE";
  parameter [7:0] PM_CAP_ID = 8'd0;
  parameter [7:0] PM_CAP_NEXTPTR = 8'd0;
  parameter PM_CAP_ON = "FALSE";
  parameter [4:0] PM_CAP_PMESUPPORT = 5'd0;
  parameter PM_CAP_PME_CLOCK = "FALSE";
  parameter [0:0] PM_CAP_RSVD_04 = 1'd0;
  parameter [2:0] PM_CAP_VERSION = 3'd3;
  parameter PM_CSR_B2B3 = "FALSE";
  parameter PM_CSR_BPCCEN = "FALSE";
  parameter PM_CSR_NOSOFTRST = "FALSE";
  parameter [7:0] PM_DATA0 = 8'd0;
  parameter [7:0] PM_DATA1 = 8'd0;
  parameter [7:0] PM_DATA2 = 8'd0;
  parameter [7:0] PM_DATA3 = 8'd0;
  parameter [7:0] PM_DATA4 = 8'd0;
  parameter [7:0] PM_DATA5 = 8'd0;
  parameter [7:0] PM_DATA6 = 8'd0;
  parameter [7:0] PM_DATA7 = 8'd0;
  parameter [1:0] PM_DATA_SCALE0 = 2'd0;
  parameter [1:0] PM_DATA_SCALE1 = 2'd0;
  parameter [1:0] PM_DATA_SCALE2 = 2'd0;
  parameter [1:0] PM_DATA_SCALE3 = 2'd0;
  parameter [1:0] PM_DATA_SCALE4 = 2'd0;
  parameter [1:0] PM_DATA_SCALE5 = 2'd0;
  parameter [1:0] PM_DATA_SCALE6 = 2'd0;
  parameter [1:0] PM_DATA_SCALE7 = 2'd0;
  parameter PM_MF = "FALSE";
  parameter [11:0] RBAR_BASE_PTR = 12'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR0 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR1 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR2 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR3 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR4 = 5'd0;
  parameter [4:0] RBAR_CAP_CONTROL_ENCODEDBAR5 = 5'd0;
  parameter [15:0] RBAR_CAP_ID = 16'd0;
  parameter [2:0] RBAR_CAP_INDEX0 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX1 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX2 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX3 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX4 = 3'd0;
  parameter [2:0] RBAR_CAP_INDEX5 = 3'd0;
  parameter [11:0] RBAR_CAP_NEXTPTR = 12'd0;
  parameter RBAR_CAP_ON = "FALSE";
  parameter [31:0] RBAR_CAP_SUP0 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP1 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP2 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP3 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP4 = 32'd0;
  parameter [31:0] RBAR_CAP_SUP5 = 32'd0;
  parameter [3:0] RBAR_CAP_VERSION = 4'd0;
  parameter [2:0] RBAR_NUM = 3'd0;
  parameter [1:0] RECRC_CHK = 2'd0;
  parameter RECRC_CHK_TRIM = "FALSE";
  parameter ROOT_CAP_CRS_SW_VISIBILITY = "FALSE";
  parameter [1:0] RP_AUTO_SPD = 2'd0;
  parameter [4:0] RP_AUTO_SPD_LOOPCNT = 5'd0;
  parameter SELECT_DLL_IF = "FALSE";
  parameter SLOT_CAP_ATT_BUTTON_PRESENT = "FALSE";
  parameter SLOT_CAP_ATT_INDICATOR_PRESENT = "FALSE";
  parameter SLOT_CAP_ELEC_INTERLOCK_PRESENT = "FALSE";
  parameter SLOT_CAP_HOTPLUG_CAPABLE = "FALSE";
  parameter SLOT_CAP_HOTPLUG_SURPRISE = "FALSE";
  parameter SLOT_CAP_MRL_SENSOR_PRESENT = "FALSE";
  parameter SLOT_CAP_NO_CMD_COMPLETED_SUPPORT = "FALSE";
  parameter [12:0] SLOT_CAP_PHYSICAL_SLOT_NUM = 13'd0;
  parameter SLOT_CAP_POWER_CONTROLLER_PRESENT = "FALSE";
  parameter SLOT_CAP_POWER_INDICATOR_PRESENT = "FALSE";
  parameter [7:0] SLOT_CAP_SLOT_POWER_LIMIT_VALUE = 8'd0;
  parameter [0:0] SPARE_BIT0 = 1'd0;
  parameter [0:0] SPARE_BIT1 = 1'd0;
  parameter [0:0] SPARE_BIT2 = 1'd0;
  parameter [0:0] SPARE_BIT3 = 1'd0;
  parameter [0:0] SPARE_BIT4 = 1'd0;
  parameter [0:0] SPARE_BIT5 = 1'd0;
  parameter [0:0] SPARE_BIT6 = 1'd0;
  parameter [0:0] SPARE_BIT7 = 1'd0;
  parameter [0:0] SPARE_BIT8 = 1'd0;
  parameter [7:0] SPARE_BYTE0 = 8'd0;
  parameter [7:0] SPARE_BYTE1 = 8'd0;
  parameter [7:0] SPARE_BYTE2 = 8'd0;
  parameter [7:0] SPARE_BYTE3 = 8'd0;
  parameter [31:0] SPARE_WORD0 = 32'd0;
  parameter [31:0] SPARE_WORD1 = 32'd0;
  parameter [31:0] SPARE_WORD2 = 32'd0;
  parameter [31:0] SPARE_WORD3 = 32'd0;
  parameter SSL_MESSAGE_AUTO = "FALSE";
  parameter TECRC_EP_INV = "FALSE";
  parameter TL_RBYPASS = "FALSE";
  parameter [1:0] TL_RX_RAM_RDATA_LATENCY = 2'd1;
  parameter TL_TFC_DISABLE = "FALSE";
  parameter TL_TX_CHECKS_DISABLE = "FALSE";
  parameter [1:0] TL_TX_RAM_RDATA_LATENCY = 2'd1;
  parameter TRN_DW = "FALSE";
  parameter TRN_NP_FC = "FALSE";
  parameter UPCONFIG_CAPABLE = "FALSE";
  parameter UPSTREAM_FACING = "FALSE";
  parameter UR_ATOMIC = "FALSE";
  parameter UR_CFG1 = "FALSE";
  parameter UR_INV_REQ = "FALSE";
  parameter UR_PRS_RESPONSE = "FALSE";
  parameter USER_CLK2_DIV2 = "FALSE";
  parameter USE_RID_PINS = "FALSE";
  parameter VC0_CPL_INFINITE = "FALSE";
  parameter [12:0] VC0_RX_RAM_LIMIT = 13'd0;
  parameter [6:0] VC0_TOTAL_CREDITS_CH = 7'd36;
  parameter [6:0] VC0_TOTAL_CREDITS_NPH = 7'd12;
  parameter [6:0] VC0_TOTAL_CREDITS_PH = 7'd32;
  parameter [11:0] VC_BASE_PTR = 12'd0;
  parameter [15:0] VC_CAP_ID = 16'd0;
  parameter [11:0] VC_CAP_NEXTPTR = 12'd0;
  parameter VC_CAP_ON = "FALSE";
  parameter VC_CAP_REJECT_SNOOP_TRANSACTIONS = "FALSE";
  parameter [3:0] VC_CAP_VERSION = 4'd0;
  parameter [11:0] VSEC_BASE_PTR = 12'd0;
  parameter [15:0] VSEC_CAP_HDR_ID = 16'd0;
  parameter [11:0] VSEC_CAP_HDR_LENGTH = 12'd0;
  parameter [3:0] VSEC_CAP_HDR_REVISION = 4'd0;
  parameter [15:0] VSEC_CAP_ID = 16'd0;
  parameter VSEC_CAP_IS_LINK_VISIBLE = "FALSE";
  parameter [11:0] VSEC_CAP_NEXTPTR = 12'd0;
  parameter VSEC_CAP_ON = "FALSE";
  parameter [3:0] VSEC_CAP_VERSION = 4'd0;
  parameter [2:0] DEV_CAP_ENDPOINT_L0S_LATENCY = 3'd0;
  parameter [2:0] DEV_CAP_ENDPOINT_L1_LATENCY = 3'd0;
  parameter [1:0] DEV_CAP_PHANTOM_FUNCTIONS_SUPPORT = 2'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_COMCLK_GEN2 = 3'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L0S_EXIT_LATENCY_GEN2 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_COMCLK_GEN2 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_GEN1 = 3'd0;
  parameter [2:0] LINK_CAP_L1_EXIT_LATENCY_GEN2 = 3'd0;
  parameter [0:0] LINK_CONTROL_RCB = 1'd0;
  parameter [0:0] MSI_CAP_MULTIMSG_EXTENSION = 1'd0;
  parameter [2:0] PM_CAP_AUXCURRENT = 3'd0;
  parameter [1:0] SLOT_CAP_SLOT_POWER_LIMIT_SCALE = 2'd0;
  parameter [2:0] USER_CLK_FREQ = 3'd0;
  parameter [2:0] PL_AUTO_CONFIG = 3'd0;
  parameter [0:0] TL_RX_RAM_RADDR_LATENCY = 1'd0;
  parameter [0:0] TL_RX_RAM_WRITE_LATENCY = 1'd0;
  parameter [0:0] TL_TX_RAM_RADDR_LATENCY = 1'd0;
  parameter [0:0] TL_TX_RAM_WRITE_LATENCY = 1'd0;
  parameter [10:0] VC0_TOTAL_CREDITS_CD = 11'd0;
  parameter [10:0] VC0_TOTAL_CREDITS_NPD = 11'd0;
  parameter [10:0] VC0_TOTAL_CREDITS_PD = 11'd0;
  parameter [4:0] VC0_TX_LASTPACKET = 5'd0;
  parameter [1:0] CFG_ECRC_ERR_CPLSTAT = 2'd0;
endmodule

// ============================================================================
// CFG_CENTER_MID

(* blackbox *)
module BSCANE2_VPR (
  output CAPTURE,
  output DRCK,
  output RESET,
  output RUNTEST,
  output SEL,
  output SHIFT,
  output TCK,
  output TDI,
  input TDO,
  output TMS,
  output UPDATE
);
  parameter integer JTAG_CHAIN = 1;
endmodule

(* blackbox *)
module CAPTUREE2_VPR (
  input CAP,
  input CLK
);
  parameter ONESHOT = "TRUE";
endmodule

(* blackbox *)
module DCIRESET_VPR (
  output LOCKED,
  input RST
);
endmodule

(* blackbox *)
module FRAME_ECCE2_VPR (
  output CRCERROR,
  output ECCERROR,
  output ECCERRORSINGLE,
  output [25:0] FAR,
  output [4:0] SYNBIT,
  output [12:0] SYNDROME,
  output SYNDROMEVALID,
  output [6:0] SYNWORD
);
  parameter FARSRC = "EFAR";
  parameter FRAME_RBT_IN_FILENAME = "NONE";
endmodule

(* blackbox *)
module ICAPE2_VPR (
  input CLK,
  input CSIB,
  input [31:0] I,
  output [31:0] O,
  input RDWRB
);
  parameter [31:0] DEVICE_ID = 32'h3651093;
  parameter ICAP_WIDTH = "X32";
  parameter SIM_CFG_FILE_NAME ="NONE";
endmodule

(* blackbox *)
module STARTUPE2_VPR (
  output CFGCLK,
  output CFGMCLK,
  input CLK,
  output EOS,
  input GSR,
  input GTS,
  input KEYCLEARB,
  input PACK,
  output PREQ,
  input USRCCLKO,
  input USRCCLKTS,
  input USRDONEO,
  input USRDONETS
);
  parameter PROG_USR = "FALSE";
  parameter SIM_CCLK_FREQ = 0.0;
endmodule

(* blackbox *)
module USR_ACCESSE2_VPR (
  output CFGCLK,
  output [31:0] DATA,
  output DATAVALID
);
endmodule
