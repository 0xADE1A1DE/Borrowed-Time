`timescale 1ns / 1ps
module MSKMixColumn #(parameter d=2) (state, update);

localparam W = 8;

input [d*128-1 : 0] state;
output [d*128-1 : 0] update;

wire [d*W - 1 : 0] x1,x2,x3,x4;
// ROW4
MSKxor #(.d(d), .count(8)) xorg1(state[16*d*W - 1 : 15*d*W], state[8*d*W - 1 : 7*d*W], update[4*d*W - 1 : 3*d*W]);
MSKxor #(.d(d), .count(8)) xorg2(state[15*d*W - 1 : 14*d*W], state[7*d*W - 1 : 6*d*W], update[3*d*W - 1 : 2*d*W]);
MSKxor #(.d(d), .count(8)) xorg3(state[14*d*W - 1 : 13*d*W], state[6*d*W - 1 : 5*d*W], update[2*d*W - 1 : d*W]);
MSKxor #(.d(d), .count(8)) xorg4(state[13*d*W - 1 : 12*d*W], state[5*d*W - 1 : 4*d*W], update[d*W - 1 : 0]);
// ROW3
MSKxor #(.d(d), .count(8)) xorg5(state[12*d*W - 1 : 11*d*W], state[8*d*W - 1 : 7*d*W], update[8*d*W - 1 : 7*d*W]);
MSKxor #(.d(d), .count(8)) xorg6(state[11*d*W - 1 : 10*d*W], state[7*d*W - 1 : 6*d*W], update[7*d*W - 1 : 6*d*W]);
MSKxor #(.d(d), .count(8)) xorg7(state[10*d*W - 1 : 9*d*W], state[6*d*W - 1 : 5*d*W], update[6*d*W - 1 : 5*d*W]);
MSKxor #(.d(d), .count(8)) xorg8(state[9*d*W - 1 : 8*d*W], state[5*d*W - 1 : 4*d*W], update[5*d*W - 1 : 4*d*W]);
// ROW2
assign update[12*d*W - 1 : 11*d*W] = state[16*d*W - 1 : 15*d*W];
assign update[11*d*W - 1 : 10*d*W] = state[15*d*W - 1 : 14*d*W];
assign update[10*d*W - 1 : 9*d*W] = state[14*d*W - 1 : 13*d*W];
assign update[9*d*W - 1 : 8*d*W] = state[13*d*W - 1 : 12*d*W];
// ROW1
MSKxor #(.d(d), .count(8)) xorg9(state[16*d*W - 1 : 15*d*W], state[4*d*W - 1 : 3*d*W], x1);
MSKxor #(.d(d), .count(8)) xorg10(state[15*d*W - 1 : 14*d*W], state[3*d*W - 1 : 2*d*W], x2);
MSKxor #(.d(d), .count(8)) xorg11(state[14*d*W - 1 : 13*d*W], state[2*d*W - 1 : d*W], x3);
MSKxor #(.d(d), .count(8)) xorg12(state[13*d*W - 1 : 12*d*W], state[d*W - 1 : 0], x4);

MSKxor #(.d(d), .count(8)) xorg13(state[8*d*W - 1 : 7*d*W], x1, update[16*d*W - 1 : 15*d*W]);
MSKxor #(.d(d), .count(8)) xorg14(state[7*d*W - 1 : 6*d*W], x2, update[15*d*W - 1 : 14*d*W]);
MSKxor #(.d(d), .count(8)) xorg15(state[6*d*W - 1 : 5*d*W], x3, update[14*d*W - 1 : 13*d*W]);
MSKxor #(.d(d), .count(8)) xorg16(state[5*d*W - 1 : 4*d*W], x4, update[13*d*W - 1 : 12*d*W]);

endmodule