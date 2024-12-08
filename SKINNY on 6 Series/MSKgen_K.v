`timescale 1ns / 1ps
module MSKgen_K #(parameter d = 2) (sel, en, clk, K, K_rounding_F);

localparam W = 8;

input [128*d - 1 : 0] K;
input clk;
input sel, en;
output [128*d - 1 : 0] K_rounding_F;

wire [128*d-1 : 0] K_rounding, K_P;

MSKmux #(.d(d), .count(128)) mux1 (sel, K, K_P, K_rounding);

MSKregEn #(.d(d), .count(128)) reg1 (clk, en, K_rounding, K_rounding_F);

MSKTweakPerm #(d) TweakPerm (K_rounding_F, K_P);

endmodule