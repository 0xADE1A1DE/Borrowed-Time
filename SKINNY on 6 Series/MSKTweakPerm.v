`timescale 1ns / 1ps
module MSKTweakPerm #(parameter d=2) (state, update);

localparam W = 8;

input [d*128-1 : 0] state;
output [d*128-1 : 0] update;

assign update[12*d*W-1 : 11*d*W] = state[6*d*W-1 : 5*d*W];
assign update[11*d*W-1 : 10*d*W] = state[2*d*W-1 : d*W];
assign update[10*d*W-1 : 9*d*W] = state[4*d*W-1 : 3*d*W];
assign update[9*d*W-1 : 8*d*W] = state[5*d*W-1 : 4*d*W];

assign update[16*d*W-1 : 15*d*W] = state[7*d*W-1 : 6*d*W];
assign update[15*d*W-1 : 14*d*W] = state[d*W-1 : 0];
assign update[14*d*W-1 : 13*d*W] = state[8*d*W-1 : 7*d*W];
assign update[13*d*W-1 : 12*d*W] = state[3*d*W-1 : 2*d*W];

assign update[d*W-1 : 0] = state[9*d*W-1 : 8*d*W];
assign update[2*d*W-1 : d*W] = state[10*d*W-1 : 9*d*W];
assign update[3*d*W-1 : 2*d*W] = state[11*d*W-1 : 10*d*W];
assign update[4*d*W-1 : 3*d*W] = state[12*d*W-1 : 11*d*W];

assign update[5*d*W-1 : 4*d*W] = state[13*d*W-1 : 12*d*W];
assign update[6*d*W-1 : 5*d*W] = state[14*d*W-1 : 13*d*W];
assign update[7*d*W-1 : 6*d*W] = state[15*d*W-1 : 14*d*W];
assign update[8*d*W-1 : 7*d*W] = state[16*d*W-1 : 15*d*W];

endmodule