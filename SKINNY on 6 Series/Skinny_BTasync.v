/*-------------------------------------------------------------------------

	Implementation of Borrowed Time protection based on asynchronous circuitry
	
  This file contains clock monitor (raising stop_detect alarm signal) and 
  delayed_edge generation circuitry, masked clearing circuitry can be found
  in SKINNY module within 

 -------------------------------------------------------------------------*/

`timescale 1ns / 1ps

module Skinny_BTasync(
   input clk,
	input rst,
	input [127:0] plaintext_s0,
	input [127:0] plaintext_s1,
	input [127:0] key_s0,
	input [127:0] key_s1,
	input [79:0] seed,
	output [127:0] ciphertext_s0,
	output [127:0] ciphertext_s1,
	output done,
	output clear,
	output out_clk
    );

	//-------------------------------------------------------------------------
	//
	//	BT:	Set 'keep' attributes for each signal so EDA tools don't optimise
	// 		away signals on the delay chains or monitor circuit.
	//			
	//			delayed_edge, stop_detect - signals as labelled in paper
	//
	//			LUT outputs: EQUAL, EQUAL1, EQUAL2, EQUAL3, EQUAL4, CLK_IND
	//			for below corresponding LUTs:
	//			LUT6_1, LUT6_2, LUT6_3, LUT6_4, LUT6_5, LUT6_6
	//			all of which are input to LUT6_7, whose output is stop_detect
	//			
	//			Delay chain made up of Q_out, Q_out0, ..., Q_out90
	//			these correspond to c0, c1, ..., cn in paper (Figure 4)
	//			they sit between delay elements: LUT5_inst, ... LUT5_inst90
	//			taps on the chain fed are the inputs to the above listed LUTs
	//			
	//			Delayed edge delay chain made up of Q_out_dp0, ..., Q_out_dp49
	//			these correspond to s0, s1, ..., sm in paper (Figure 4)
	//			they sit between delay elements: LUT5_dpinst0, ... LUT5_dpinst50
	//
	//			PRNG instantiated in Skinny_128_128_d2_TriviumPRNGBT module
	//
	//-------------------------------------------------------------------------

	(* S = "true" *)  
	(* KEEP = "true" *) 
	wire sys_clk;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire stop_detect;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire delayed_edge;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire CLK_IND;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire EQUAL;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire EQUAL1;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire EQUAL2;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire EQUAL3;

	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire EQUAL4;
	
	(* S = "true" *)  
	(* KEEP = "true" *)  
	wire Q_out;


(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out1;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out2;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out3;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out4;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out5;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out6;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out7;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out8;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out9;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out10;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out11;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out12;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out13;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out14;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out15;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out16;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out17;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out18;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out19;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out20;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out21;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out22;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out23;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out24;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out25;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out26;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out27;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out28;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out29;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out30;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out31;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out32;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out33;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out34;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out35;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out36;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out37;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out38;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out39;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out40;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out41;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out42;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out43;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out44;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out45;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out46;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out47;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out48;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out49;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out50;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out51;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out52;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out53;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out54;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out55;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out56;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out57;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out58;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out59;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out60;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out61;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out62;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out63;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out64;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out65;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out66;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out67;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out68;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out69;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out70;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out71;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out72;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out73;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out74;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out75;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out76;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out77;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out78;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out79;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out80;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out81;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out82;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out83;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out84;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out85;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out86;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out87;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out88;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out89;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out90;

	
(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp0;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp1;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp2;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp3;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp4;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp5;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp6;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp7;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp8;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp9;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp10;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp11;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp12;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp13;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp14;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp15;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp16;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp17;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp18;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp19;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp20;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp21;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp22;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp23;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp24;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp25;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp26;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp27;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp28;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp29;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp30;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp31;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp32;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp33;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp34;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp35;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp36;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp37;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp38;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp39;


(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp40;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp41;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp42;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp43;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp44;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp45;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp46;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp47;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp48;

(* S = "true" *)
	(* KEEP = "true" *)
 	wire Q_out_dp49;

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst0(
		.O(Q_out_dp0), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(stop_detect) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst1(
		.O(Q_out_dp1), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp0) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst2(
		.O(Q_out_dp2), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp1) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst3(
		.O(Q_out_dp3), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp2) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst4(
		.O(Q_out_dp4), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp3) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst5(
		.O(Q_out_dp5), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp4) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst6(
		.O(Q_out_dp6), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp5) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst7(
		.O(Q_out_dp7), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp6) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst8(
		.O(Q_out_dp8), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp7) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst9(
		.O(Q_out_dp9), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp8) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst10(
		.O(Q_out_dp10), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp9) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst11(
		.O(Q_out_dp11), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp10) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst12(
		.O(Q_out_dp12), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp11) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst13(
		.O(Q_out_dp13), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp12) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst14(
		.O(Q_out_dp14), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp13) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst15(
		.O(Q_out_dp15), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp14) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst16(
		.O(Q_out_dp16), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp15) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst17(
		.O(Q_out_dp17), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp16) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst18(
		.O(Q_out_dp18), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp17) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst19(
		.O(Q_out_dp19), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp18) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst20(
		.O(Q_out_dp20), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp19) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst21(
		.O(Q_out_dp21), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp20) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst22(
		.O(Q_out_dp22), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp21) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst23(
		.O(Q_out_dp23), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp22) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst24(
		.O(Q_out_dp24), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp23) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst25(
		.O(Q_out_dp25), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp24) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst26(
		.O(Q_out_dp26), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp25) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst27(
		.O(Q_out_dp27), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp26) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst28(
		.O(Q_out_dp28), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp27) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst29(
		.O(Q_out_dp29), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp28) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst30(
		.O(Q_out_dp30), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp29) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst31(
		.O(Q_out_dp31), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp30) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst32(
		.O(Q_out_dp32), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp31) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst33(
		.O(Q_out_dp33), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp32) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst34(
		.O(Q_out_dp34), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp33) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst35(
		.O(Q_out_dp35), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp34) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst36(
		.O(Q_out_dp36), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp35) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst37(
		.O(Q_out_dp37), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp36) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst38(
		.O(Q_out_dp38), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp37) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst39(
		.O(Q_out_dp39), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp38) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst40(
		.O(Q_out_dp40), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp39) // LUT input
	);

	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst41(
		.O(Q_out_dp41), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp40) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst42(
		.O(Q_out_dp42), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp41) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst43(
		.O(Q_out_dp43), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp42) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst44(
		.O(Q_out_dp44), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp43) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst45(
		.O(Q_out_dp45), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp44) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst46(
		.O(Q_out_dp46), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp45) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst47(
		.O(Q_out_dp47), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp46) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst48(
		.O(Q_out_dp48), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp47) // LUT input
	);
	
(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst49(
		.O(Q_out_dp49), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp48) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_dpinst50(
		.O(delayed_edge), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out_dp49) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
.INIT(32'hffff0000) // Specify LUT Contents
) LUT5_inst0 (
.O(Q_out), // LUT general output
.I0(1'b0), // LUT input
.I1(1'b0), // LUT input
.I2(1'b0), // LUT input
.I3(1'b0), // LUT input
.I4(clk) // LUT input
);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
.INIT(32'hffff0000) // Specify LUT Contents
) LUT5_inst1 (
.O(Q_out1), // LUT general output
.I0(1'b0), // LUT input
.I1(1'b0), // LUT input
.I2(1'b0), // LUT input
.I3(1'b0), // LUT input
.I4(Q_out) // LUT input
);


(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst2(
		.O(Q_out2), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out1) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst3(
		.O(Q_out3), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out2) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst4(
		.O(Q_out4), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out3) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst5(
		.O(Q_out5), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out4) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst6(
		.O(Q_out6), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out5) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst7(
		.O(Q_out7), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out6) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst8(
		.O(Q_out8), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out7) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst9(
		.O(Q_out9), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out8) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst10(
		.O(Q_out10), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out9) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst11(
		.O(Q_out11), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out10) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst12(
		.O(Q_out12), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out11) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst13(
		.O(Q_out13), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out12) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst14(
		.O(Q_out14), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out13) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst15(
		.O(Q_out15), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out14) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst16(
		.O(Q_out16), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out15) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst17(
		.O(Q_out17), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out16) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst18(
		.O(Q_out18), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out17) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst19(
		.O(Q_out19), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out18) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst20(
		.O(Q_out20), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out19) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst21(
		.O(Q_out21), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out20) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst22(
		.O(Q_out22), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out21) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst23(
		.O(Q_out23), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out22) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst24(
		.O(Q_out24), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out23) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst25(
		.O(Q_out25), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out24) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst26(
		.O(Q_out26), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out25) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst27(
		.O(Q_out27), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out26) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst28(
		.O(Q_out28), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out27) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst29(
		.O(Q_out29), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out28) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst30(
		.O(Q_out30), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out29) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst31(
		.O(Q_out31), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out30) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst32(
		.O(Q_out32), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out31) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst33(
		.O(Q_out33), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out32) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst34(
		.O(Q_out34), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out33) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst35(
		.O(Q_out35), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out34) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst36(
		.O(Q_out36), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out35) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst37(
		.O(Q_out37), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out36) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst38(
		.O(Q_out38), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out37) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst39(
		.O(Q_out39), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out38) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst40(
		.O(Q_out40), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out39) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst41(
		.O(Q_out41), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out40) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst42(
		.O(Q_out42), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out41) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst43(
		.O(Q_out43), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out42) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst44(
		.O(Q_out44), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out43) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst45(
		.O(Q_out45), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out44) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst46(
		.O(Q_out46), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out45) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst47(
		.O(Q_out47), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out46) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst48(
		.O(Q_out48), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out47) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst49(
		.O(Q_out49), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out48) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst50(
		.O(Q_out50), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out49) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst51(
		.O(Q_out51), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out50) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst52(
		.O(Q_out52), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out51) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst53(
		.O(Q_out53), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out52) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst54(
		.O(Q_out54), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out53) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst55(
		.O(Q_out55), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out54) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst56(
		.O(Q_out56), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out55) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst57(
		.O(Q_out57), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out56) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst58(
		.O(Q_out58), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out57) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst59(
		.O(Q_out59), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out58) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst60(
		.O(Q_out60), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out59) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst61(
		.O(Q_out61), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out60) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst62(
		.O(Q_out62), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out61) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst63(
		.O(Q_out63), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out62) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst64(
		.O(Q_out64), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out63) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst65(
		.O(Q_out65), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out64) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst66(
		.O(Q_out66), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out65) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst67(
		.O(Q_out67), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out66) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst68(
		.O(Q_out68), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out67) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst69(
		.O(Q_out69), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out68) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst70(
		.O(Q_out70), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out69) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst71(
		.O(Q_out71), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out70) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst72(
		.O(Q_out72), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out71) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst73(
		.O(Q_out73), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out72) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst74(
		.O(Q_out74), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out73) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst75(
		.O(Q_out75), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out74) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst76(
		.O(Q_out76), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out75) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst77(
		.O(Q_out77), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out76) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst78(
		.O(Q_out78), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out77) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst79(
		.O(Q_out79), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out78) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst80(
		.O(Q_out80), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out79) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst81(
		.O(Q_out81), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out80) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst82(
		.O(Q_out82), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out81) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst83(
		.O(Q_out83), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out82) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst84(
		.O(Q_out84), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out83) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst85(
		.O(Q_out85), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out84) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst86(
		.O(Q_out86), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out85) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst87(
		.O(Q_out87), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out86) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst88(
		.O(Q_out88), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out87) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst89(
		.O(Q_out89), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out88) // LUT input
	);

(* S = "TRUE", DONT_TOUCH = "TRUE" *) LUT5 #(
		.INIT(32'hffff0000) // Specify LUT Contents
		) LUT5_inst90(
		.O(Q_out90), // LUT general output
		.I0(1'b0), // LUT input
		.I1(1'b0), // LUT input
		.I2(1'b0), // LUT input
		.I3(1'b0), // LUT input
		.I4(Q_out89) // LUT input
	);


LUT6 #(
	.INIT(64'h8000000000000001) // BT: this configuration sets O high if all inputs equal
) LUT6_1 (
	.O(EQUAL), // 1-bit LUT6 output
	.I0(Q_out), // LUT input
	.I1(Q_out3), // LUT input
	.I2(Q_out6), // LUT input
	.I3(Q_out9), // LUT input
	.I4(Q_out12), // LUT input
	.I5(Q_out15)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

LUT6 #(
	.INIT(64'h8000000000000001) // BT: this configuration sets O high if all inputs equal
) LUT62 (
	.O(EQUAL1), // 1-bit LUT6 output
	.I0(Q_out18), // LUT input
	.I1(Q_out21), // LUT input
	.I2(Q_out24), // LUT input
	.I3(Q_out27), // LUT input
	.I4(Q_out30), // LUT input
	.I5(Q_out33)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

LUT6 #(
	.INIT(64'h8000000000000001) // BT: this configuration sets O high if all inputs equal
) LUT6_3 (
	.O(EQUAL2), // 1-bit LUT6 output
	.I0(Q_out36), // LUT input
	.I1(Q_out39), // LUT input
	.I2(Q_out42), // LUT input
	.I3(Q_out45), // LUT input
	.I4(Q_out48), // LUT input
	.I5(Q_out51)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

LUT6 #(
	.INIT(64'h8000000000000001) // BT: this configuration sets O high if all inputs equal
) LUT6_4 (
	.O(EQUAL3), // 1-bit LUT6 output
	.I0(Q_out54), // LUT input
	.I1(Q_out57), // LUT input
	.I2(Q_out60), // LUT input
	.I3(Q_out63), // LUT input
	.I4(Q_out66), // LUT input
	.I5(Q_out69)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

LUT6 #(
	.INIT(64'h8000000000000001) // BT: this configuration sets O high if all inputs equal
) LUT6_5 (
	.O(EQUAL4), // 1-bit LUT6 output
	.I0(Q_out72), // LUT input
	.I1(Q_out75), // LUT input
	.I2(Q_out78), // LUT input
	.I3(Q_out81), // LUT input
	.I4(Q_out84), // LUT input
	.I5(Q_out87)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

LUT6 #(
	.INIT(64'h8000000000000001) // BT: this configuration sets O high if all inputs equal
) LUT6_6 (
	.O(CLK_IND), // 1-bit LUT6 output
	.I0(Q_out15), // LUT input
	.I1(Q_out30), // LUT input
	.I2(Q_out45), // LUT input
	.I3(Q_out60), // LUT input
	.I4(Q_out75), // LUT input
	.I5(Q_out87)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

LUT6 #(
	.INIT(64'h8000000000000000) // BT: this configuration sets O high if all inputs equal
) LUT6_7 (
	.O(stop_detect), // 1-bit LUT6 output
	.I0(EQUAL), // LUT input
	.I1(EQUAL1), // LUT inputl
	.I2(EQUAL2), // LUT input
	.I3(EQUAL3), // LUT input
	.I4(EQUAL4), // LUT input
	.I5(CLK_IND)  // 1-bit LUT input (fast MUX select only available to O6 output)
);

BUFGMUX #(
	.CLK_SEL_TYPE("ASYNC") // Glitchles ("SYNC") or fast ("ASYNC") clock switch-over
)
clk_mux (
	.O(sys_clk), // 1-bit output: Clock buffer output
	.I0(clk), // 1-bit input: Clock buffer input (S=0)
	.I1(delayed_edge), // 1-bit input: Clock buffer input (S=1)
	.S(stop_detect) // 1-bit input: Clock buffer select
);

assign clear = stop_detect;
assign out_clk = sys_clk;

Skinny_128_128_d2_TriviumPRNGBT Skinny_128_128_d2_TriviumPRNGBT (
.clk(sys_clk), .rst(rst), .plaintext_s0(plaintext_s0), .plaintext_s1(plaintext_s1), 
.key_s0(key_s0), .key_s1(key_s1), .seed(seed), .ciphertext_s0(ciphertext_s0), 
.ciphertext_s1(ciphertext_s1), .done(done), .clear(stop_detect)
);


endmodule
