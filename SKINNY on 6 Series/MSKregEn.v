`timescale 1ns/1ps
module MSKregEn #(parameter d=1, parameter count=1) (clk, en, in, out);

input clk;
input en;
input  [count*d-1:0] in;
output [count*d-1:0] out;

wire [count*d-1:0] reg_in;

MSKmux #(.d(d), .count(count)) mux (.sel(en), .in_true(in), .in_false(out), .out(reg_in));
MSKreg #(.d(d), .count(count)) state_reg (.clk(clk), .in(reg_in), .out(out));

endmodule
