`timescale 1ns / 1ps
module MSKShiftRows #(parameter d=2) (state, update);

localparam W = 8;

input [d*128-1 : 0] state;
output [d*128-1 : 0] update;

//ROW 1
assign update [16*d*W - 1 : 12*d*W] = state [16*d*W - 1 : 12*d*W];
//ROW 2
assign update [12*d*W - 1 : 11*d*W] = state [9*d*W - 1 : 8*d*W];
assign update [11*d*W - 1 : 8*d*W] = state [12*d*W - 1 : 9*d*W];
//ROW 3
assign update [8*d*W - 1 : 6*d*W] = state [6*d*W - 1 : 4*d*W];
assign update [6*d*W - 1 : 4*d*W] = state [8*d*W - 1 : 6*d*W];

//ROW 4
assign update [4*d*W - 1 : d*W] = state [3*d*W - 1 : 0];
assign update [d*W - 1 : 0] = state [4*d*W - 1 : 3*d*W];

endmodule