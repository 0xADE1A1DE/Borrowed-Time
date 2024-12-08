`timescale 1ns / 1ps
module MSKsboxBT #(parameter d = 2) (in, en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd, rnd_BT, clk, clear, out);
localparam and_pini_mul_nrnd = d*(d-1)/2;
localparam and_pini_nrnd = and_pini_mul_nrnd;
input  [8*d-1:0] in;
(* keep = "true" *) input [2*and_pini_nrnd-1:0] rnd;
input clk;
output [8*d-1:0] out;
input en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2;

// BT
(* keep = "true" *) input [3:0] rnd_BT;
input clear;

wire [d-1:0] in8, in1, in2, in3, in4, in5, in6, in7, in3_F, in3_FF, ina_1, ina_2, inb_1, inb_2, inv_a_1, inv_a_2, inv_b_1, inv_b_2, inxor_1, inxor_2, nand_1, nand_2;
wire [d-1:0] out0, out1, out2, out3, out4, out5, out6, out7, out1_F;
wire [d-1:0] mux1a1_out, mux2a1_out, mux1b1_out, mux2b1_out, mux1x1_out, mux2x1_out, mux1a2_out, mux2a2_out, mux1b2_out, mux2b2_out, mux1x2_out, mux2x2_out;
wire [d-1:0] in1_F, in1_FF,in1_FFF, in2_F, in2_FF, in2_FFF, in2_FFFF, in2_FFFFF, in2_FFFFFF, in2_FFFFFFF, in3_FFF, in3_FFFF, in3_FFFFF, in3_FFFFFF, in3_FFFFFFF;
wire [d-1:0] in4_F, in4_FF, in4_FFF, in4_FFFF, in4_FFFFF, in4_FFFFFF, in5_F, in5_FF, in5_FFF, in6_F, in6_FF, in6_FFF, in6_FFFF, in6_FFFFF, in7_F, in7_FF, in7_FFF, in7_FFFF;
wire [d-1:0] in8_F, in8_FF, in8_FFF, in8_FFFF, in8_FFFFF, in8_FFFFFF;
wire [7:0] umsk_in, umsk_out;

// BT
reg [39:0] rnd_acc = 40'b0;
reg [39:0] unused_rnd = 40'b0;	// bitmask indicating unused fresh randomness
wire [39:0] fresh_clear;
reg clear_D = 0;
wire clear_pulse;
// BT
assign fresh_clear = unused_rnd & {40{clear_pulse}};
assign clear_pulse = clear & ~clear_D;

genvar a;
generate
	for(a=0; a<8; a=a+1) begin
		assign umsk_in[a] = ^(in[d*(a+1)-1:d*a]);
	end
endgenerate


genvar b;
generate
	for(b=0; b<8; b=b+1) begin
		assign umsk_out[b] = ^(out[d*(b+1)-1:d*b]);
	end
endgenerate

assign in1 = in[0 +: d];
assign in2 = in[d +: d];
assign in3 = in[2*d +: d];
assign in4 = in[3*d +: d];
assign in5 = in[4*d +: d];
assign in6 = in[5*d +: d];
assign in7 = in[6*d +: d];
assign in8 = in[7*d +: d];

// Module 1

MSKinv #(d) inv1 (ina_1, inv_a_1);
MSKinv #(d) inv2 (inb_1, inv_b_1);
MSKand_HPC2 #(d) andg1(inv_a_1, inv_b_1, rnd[0 +: and_pini_nrnd], clk, nand_1);
MSKxor #(d) xorg1(nand_1, inxor_1, out1);

// Module 2
MSKinv #(d) inv3 (ina_2, inv_a_2);
MSKinv #(d) inv4 (inb_2, inv_b_2);
MSKand_HPC2 #(d) andg2(inv_a_2, inv_b_2, rnd[and_pini_nrnd-1 +: and_pini_nrnd], clk, nand_2);
MSKxor #(d) xorg2(nand_2, inxor_2, out2);

// Regs

MSKregBT #(d) reg_in1_F (clk, in1, rnd_acc[0], fresh_clear[0], in1_F);
MSKregBT #(d) reg_in1_FF (clk, in1_F, rnd_acc[8], fresh_clear[8], in1_FF);
//MSKregBT #(d) reg_in1_FFF (clk, in1_FF, fresh_clear[], in1_FFF);		// this and all other last ones seem to be unused

MSKregBT #(d) reg_in2_F (clk, in2, rnd_acc[1], fresh_clear[1], in2_F);
MSKregBT #(d) reg_in2_FF (clk, in2_F, rnd_acc[9], fresh_clear[9], in2_FF);
MSKregBT #(d) reg_in2_FFF (clk, in2_FF, rnd_acc[18], fresh_clear[18], in2_FFF);
MSKregBT #(d) reg_in2_FFFF (clk, in2_FFF, rnd_acc[25], fresh_clear[25], in2_FFFF);
//MSKregBT #(d) reg_in2_FFFFF (clk, in2_FFFF, rnd_acc[], fresh_clear[], in2_FFFFF);

MSKregBT #(d) reg_in3_F (clk, in3, rnd_acc[2], fresh_clear[2], in3_F);
MSKregBT #(d) reg_in3_FF (clk, in3_F, rnd_acc[10], fresh_clear[10], in3_FF);
MSKregBT #(d) reg_in3_FFF (clk, in3_FF, rnd_acc[19], fresh_clear[19], in3_FFF);
MSKregBT #(d) reg_in3_FFFF (clk, in3_FFF, rnd_acc[26], fresh_clear[26], in3_FFFF);
MSKregBT #(d) reg_in3_FFFFF (clk, in3_FFFF, rnd_acc[32], fresh_clear[32], in3_FFFFF);
MSKregBT #(d) reg_in3_FFFFFF (clk, in3_FFFFF, rnd_acc[37], fresh_clear[37], in3_FFFFFF);
//MSKregBT #(d) reg_in3_FFFFFFF (clk, in3_FFFFFF, rnd_acc[], fresh_clear[], in3_FFFFFFF);

MSKregBT #(d) reg_in4_F (clk, in4, rnd_acc[3], fresh_clear[3], in4_F);
MSKregBT #(d) reg_in4_FF (clk, in4_F, rnd_acc[11], fresh_clear[11], in4_FF);
MSKregBT #(d) reg_in4_FFF (clk, in4_FF, rnd_acc[20], fresh_clear[20], in4_FFF);
MSKregBT #(d) reg_in4_FFFF (clk, in4_FFF, rnd_acc[27], fresh_clear[27], in4_FFFF);
MSKregBT #(d) reg_in4_FFFFF (clk, in4_FFFF, rnd_acc[33], fresh_clear[33], in4_FFFFF);
//MSKregBT #(d) reg_in4_FFFFFF (clk, in4_FFFFF, rnd_acc[], fresh_clear[], in4_FFFFFF);

MSKregBT #(d) reg_in5_F (clk, in5, rnd_acc[4], fresh_clear[4], in5_F);
MSKregBT #(d) reg_in5_FF (clk, in5_F, rnd_acc[12], fresh_clear[12], in5_FF);
//MSKregBT #(d) reg_in5_FFF (clk, in5_FF, rnd_acc[], fresh_clear[], in5_FFF);

MSKregBT #(d) reg_in6_F (clk, in6, rnd_acc[5], fresh_clear[5], in6_F);
MSKregBT #(d) reg_in6_FF (clk, in6_F, rnd_acc[13], fresh_clear[13], in6_FF);
MSKregBT #(d) reg_in6_FFF (clk, in6_FF, rnd_acc[21], fresh_clear[21], in6_FFF);
MSKregBT #(d) reg_in6_FFFF (clk, in6_FFF, rnd_acc[28], fresh_clear[28], in6_FFFF);
//MSKregBT #(d) reg_in6_FFFFF (clk, in6_FFFF, rnd_acc[], fresh_clear[], in6_FFFFF);

MSKregBT #(d) reg_in7_F (clk, in7, rnd_acc[6], fresh_clear[6], in7_F);
MSKregBT #(d) reg_in7_FF (clk, in7_F, rnd_acc[14], fresh_clear[14], in7_FF);
MSKregBT #(d) reg_in7_FFF (clk, in7_FF, rnd_acc[22], fresh_clear[22], in7_FFF);
//MSKregBT #(d) reg_in7_FFFF (clk, in7_FFF, rnd_acc[], fresh_clear[], in7_FFFF);

MSKregBT #(d) reg_in8_F (clk, in8, rnd_acc[7], fresh_clear[7], in8_F);
MSKregBT #(d) reg_in8_FF (clk, in8_F, rnd_acc[15], fresh_clear[15], in8_FF);
MSKregBT #(d) reg_in8_FFF (clk, in8_FF, rnd_acc[23], fresh_clear[23], in8_FFF);
MSKregBT #(d) reg_in8_FFFF (clk, in8_FFF, rnd_acc[29], fresh_clear[29], in8_FFFF);
MSKregBT #(d) reg_in8_FFFFF (clk, in8_FFFF, rnd_acc[34], fresh_clear[34], in8_FFFFF);
//MSKregBT #(d) reg_in8_FFFFFF (clk, in8_FFFFF, rnd_acc[], fresh_clear[], in8_FFFFFF);

MSKregEnBT  #(d) reg_o_0 (clk, en2, out1, rnd_acc[16], fresh_clear[16], out[7*d-1 : 6*d]);
MSKregEnBT  #(d) reg_o_1 (clk, en2, out2, rnd_acc[17], fresh_clear[17], out[6*d-1 : 5*d]);
MSKregEnBT  #(d) reg_o_2 (clk, en3, out1, rnd_acc[24], fresh_clear[24], out[3*d-1 : 2*d]);
MSKregEnBT  #(d) reg_o_3 (clk, en4, out2, rnd_acc[30], fresh_clear[30], out[8*d-1 : 7*d]);
MSKregEnBT  #(d) reg_o_4 (clk, en4, out1, rnd_acc[31], fresh_clear[31], out[4*d-1 : 3*d]);
MSKregEnBT  #(d) reg_o_5 (clk, en5, out2, rnd_acc[35], fresh_clear[35], out[2*d-1 : d]);
MSKregEnBT  #(d) reg_o_6 (clk, en5, out1, rnd_acc[36], fresh_clear[36], out[5*d-1:4*d]);
assign out[d-1 : 0] = out2;

// Muxs

//  Stage 1
MSKmux #(d) mux1a1 (sel1a1, in3_FF, in8_F, mux1a1_out);
MSKmux #(d) mux2a1 (sel1a1, out2, out[6*d-1:5*d], mux2a1_out);
MSKmux #(d) mux3a1 (sel2a1, mux2a1_out, mux1a1_out, ina_1);

MSKmux #(d) mux1b1 (sel1b1, in2_F, in7, mux1b1_out);
MSKmux #(d) mux2b1 (sel1b1, out[7*d-1:6*d], in4_FF, mux2b1_out);
MSKmux #(d) mux3b1 (sel2b1, mux2b1_out, mux1b1_out, inb_1);

MSKmux #(d) mux1x1 (sel1x1, in7_FFF, in5_FF, mux1x1_out);
MSKmux #(d) mux2x1 (sel1x1, in4_FFFFF, in2_FFFF, mux2x1_out);
MSKmux #(d) mux3x1 (sel2x1, mux2x1_out, mux1x1_out, inxor_1);
//  Stage 2
MSKmux #(d) mux1a2 (sel1a2, out[7*d-1:6*d], in4_F, mux1a2_out);
MSKmux #(d) mux2a2 (sel1a2, out2 , out2, mux2a2_out); //out2 = out[8*d-1:7*d]
MSKmux #(d) mux3a2 (sel2a2, mux2a2_out, mux1a2_out, ina_2);

MSKmux #(d) mux1b2 (sel1b2, out2, in3, mux1b2_out); //out2 = out[6*d-1:5*d]
MSKmux #(d) mux2b2 (sel1b2, out1, out1, mux2b2_out); //out1 = out[4*d-1:3*d]
MSKmux #(d) mux3b2 (sel2b2, mux2b2_out, mux1b2_out, inb_2);

MSKmux #(d) mux1x2 (sel1x2, in6_FFFF, in1_FF, mux1x2_out);
MSKmux #(d) mux2x2 (sel1x2, in3_FFFFFF, in8_FFFFF, mux2x2_out);
MSKmux #(d) mux3x2 (sel2x2, mux2x2_out, mux1x2_out, inxor_2);

// BT
always @ (posedge clk)
begin
	if ( clear_pulse ) begin
		unused_rnd <= 40'b0;
	end
	else if ( unused_rnd != 40'hFFFFFFFFFF ) begin
		unused_rnd <= { unused_rnd[35:0], 4'b1111 };
	end
	rnd_acc <= { rnd_acc[35:0], rnd_BT };
	clear_D <= clear;
end

endmodule