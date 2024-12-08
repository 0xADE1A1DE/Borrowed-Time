`timescale 1ns / 1ps
module MSKskinny_encryptBT #(parameter d = 2)(clk, en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, sel, en, en_glitch, done, rnd, rnd_BT, K, PT, update_CKSM_o, clear);
localparam and_pini_mul_nrnd = d*(d-1)/2;
localparam and_pini_nrnd = and_pini_mul_nrnd;
localparam W = 8;
//INPUT / OUTPUT
input clk;
input sel, en, done, en_glitch, en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2;
input [16*2*and_pini_nrnd-1:0] rnd;
input [128*d-1 : 0] K;
input [128*d-1 : 0] PT;
output [128*d-1 : 0] update_CKSM_o;

//BT
input [63:0] rnd_BT;
input clear;

// INTERMEDIATE VALUES
wire [128*d-1 : 0] update_C;
wire [128*d-1 : 0] TK1, PT_rounded;
wire [64*d-1 : 0] msk_K, msk_K_ok, cst_0, msk_K_ok_F;
wire  [128*d-1 : 0] PT_rounding;
wire [128*d-1 : 0] update, update_CK, update_CKS;
wire [6*d-1 : 0] roundcst;
wire[127 : 0] UMSKupdate_C, UMSKupdate_CK, UMSKupdate, UMSKupdate_CKS;
wire [127:0] PT_umsk;
wire [128*d-1 : 0] update_CKSM, K_out;
wire [128*d-1 : 0] outzeros;
wire [64-1:0] umsk_K;

wire [5:0] roundcst_test;

MSKgen_K #(d) Kgen (sel, en, clk, K, TK1);

MSKmux #(.d(d), .count(128)) mux1 (sel, PT, PT_rounding, PT_rounded);

// SBOX 

MSKsboxBT #(d) sbox1 (PT_rounded[W*d-1 : 0], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[0 +: 2*and_pini_nrnd], rnd_BT[3:0], clk, clear, update[W*d-1 : 0]);
MSKsboxBT #(d) sbox2 (PT_rounded[2*W*d-1 : W*d], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[7:4], clk, clear, update[2*W*d-1 : W*d]);
MSKsboxBT #(d) sbox3 (PT_rounded[3*W*d-1 : 2*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[2*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[11:8], clk, clear, update[3*W*d-1 : 2*d*W]);
MSKsboxBT #(d) sbox4 (PT_rounded[4*W*d-1 : 3*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[3*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[15:12], clk, clear, update[4*W*d-1 : 3*d*W]);

MSKsboxBT #(d) sbox5 (PT_rounded[5*W*d-1 : 4*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[4*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[19:16], clk, clear, update[5*W*d-1 : 4*d*W]);
MSKsboxBT #(d) sbox6 (PT_rounded[6*W*d-1 : 5*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[5*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[23:20], clk, clear, update[6*W*d-1 : 5*d*W]);
MSKsboxBT #(d) sbox7 (PT_rounded[7*W*d-1 : 6*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[6*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[27:24], clk, clear, update[7*W*d-1 : 6*d*W]);
MSKsboxBT #(d) sbox8 (PT_rounded[8*W*d-1 : 7*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[7*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[31:28], clk, clear, update[8*W*d-1 : 7*d*W]);

MSKsboxBT #(d) sbox9 (PT_rounded[9*W*d-1 : 8*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[8*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[35:32], clk, clear, update[9*W*d-1 : 8*d*W]);
MSKsboxBT #(d) sbox10 (PT_rounded[10*W*d-1 : 9*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[9*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[39:36], clk, clear, update[10*W*d-1 : 9*d*W]);
MSKsboxBT #(d) sbox11 (PT_rounded[11*W*d-1 : 10*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[10*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[43:40], clk, clear, update[11*W*d-1 : 10*d*W]);
MSKsboxBT #(d) sbox12 (PT_rounded[12*W*d-1 : 11*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[11*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[47:44], clk, clear, update[12*W*d-1 : 11*d*W]);

MSKsboxBT #(d) sbox13 (PT_rounded[13*W*d-1 : 12*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[12*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[51:48], clk, clear, update[13*W*d-1 : 12*d*W]);
MSKsboxBT #(d) sbox14 (PT_rounded[14*W*d-1 : 13*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[13*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[55:52], clk, clear, update[14*W*d-1 : 13*d*W]);
MSKsboxBT #(d) sbox15 (PT_rounded[15*W*d-1 : 14*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[14*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[59:56], clk, clear, update[15*W*d-1 : 14*d*W]);
MSKsboxBT #(d) sbox16 (PT_rounded[16*W*d-1 : 15*d*W], en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd[15*2*and_pini_nrnd +: 2*and_pini_nrnd], rnd_BT[63:60], clk, clear, update[16*W*d-1 : 15*d*W]);

genvar i;
generate
	for(i=0; i<128; i=i+1) begin
		assign PT_umsk[i] = ^(PT_rounded[d*(i+1)-1:d*i]);
	end
endgenerate


genvar k;
generate
	for(k=0; k<128; k=k+1) begin
		assign UMSKupdate[k] = ^(update[d*(k+1)-1:d*k]);
	end
endgenerate

// ARC ART MC SR

// ARC
LFSR1 lfsr1 (clk, sel, en, roundcst_test);
MSKcst #(.d(d), .count(6)) roundcstmsk (roundcst_test, roundcst);

MSKaddConst #(d) addConst1 (update, roundcst, update_C);

// ART
assign msk_K = TK1[16*d*W-1 : 8*d*W];

MSKcst #(.d(d), .count(64)) cst_key ({(64){1'b0}}, cst_0);
MSKmux #(.d(d), .count(64)) mux_key (en_glitch, msk_K, cst_0, msk_K_ok);

MSKreg #(.d(d), .count(64)) reg_key (clk, msk_K_ok, msk_K_ok_F);

MSKxor #(.d(d), .count(64)) xor3 (update_C[128*d-1 : 64*d], msk_K_ok_F, update_CK[128*d-1 : 64*d]);

assign update_CK[64*d-1 : 0] = update_C[64*d-1 : 0];

// SR
MSKShiftRows #(d) ShiftRow1 (update_CK, update_CKS);

// MC
MSKMixColumn #(d) MixCol1 (update_CKS, PT_rounding);
assign update_CKSM = PT_rounding;


MSKcst #(.d(d), .count(128)) cst_out ({(128){1'b0}}, outzeros);

MSKmux #(.d(d), .count(128)) mux_out (done, update_CKSM, outzeros, update_CKSM_o);

endmodule