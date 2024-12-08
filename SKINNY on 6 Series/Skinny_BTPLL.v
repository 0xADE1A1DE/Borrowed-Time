`timescale 1ns / 1ps

module Skinny_BTPLL(
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
	input clear
//	output clear
    );

//	wire sys_clk;
	wire clkfb;
	wire locked;
//	wire clear;
	
//assign clear = ~locked;


Skinny_128_128_d2_TriviumPRNGBT Skinny_128_128_d2_TriviumPRNGBT (
//.clk(sys_clk),
.clk(clk), .rst(rst), .plaintext_s0(plaintext_s0), .plaintext_s1(plaintext_s1), 
.key_s0(key_s0), .key_s1(key_s1), .seed(seed), .ciphertext_s0(ciphertext_s0), 
.ciphertext_s1(ciphertext_s1), .done(done), .clear(clear)
);
/*
// PLL_ADV primitive instantiation for BT
(* S = "TRUE", DONT_TOUCH = "TRUE" *)    PLL_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT(34),
    .CLKOUT0_DIVIDE(4),
    .CLKIN1_PERIOD(8.333),
    .COMPENSATION("SYSTEM_SYNCHRONOUS")
) pll_BT (
    .CLKFBIN(clkfb),
    .CLKIN1(clk),
    .CLKOUT0(sys_clk),
    .LOCKED(locked),
    .RST(rst),
    .CLKFBOUT(clkfb)
); // PLL Max lock time is 100us
*/



endmodule
