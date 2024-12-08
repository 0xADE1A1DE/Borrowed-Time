`timescale 1ns / 1ps
module MSKaddConst#(parameter d = 2) (in, roundcst, out);
input [128*d-1 : 0] in;
input [6*d-1 : 0] roundcst;
output [128*d-1 : 0] out;

MSKxor  #(.d(d), .count(4)) xor1 (in[124*d-1 : 120*d], roundcst[4*d-1: 0], out[124*d-1 : 120*d]);
MSKxor  #(.d(d), .count(2)) xor2 (in[90*d-1 : 88*d], roundcst[6*d-1 : 4*d], out[90*d-1 : 88*d]);
MSKinv  #(.d(d)) inv1 (in[58*d-1 : 57*d], out[58*d -1 : 57*d]);
assign out[128*d - 1 : 124*d] = in[128*d - 1 : 124*d];
assign out[120*d - 1 : 90*d] = in[120*d - 1 : 90*d];
assign out[88*d - 1 : 58*d] = in[88*d - 1 : 58*d];
assign out[57*d - 1 : 0*d] = in[57*d - 1 : 0*d];

endmodule