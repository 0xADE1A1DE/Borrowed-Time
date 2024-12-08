`timescale 1ns/1ps
module MSKreg #(parameter d=1, parameter count=1) (clk, in, out);

input clk;
input  [count*d-1:0] in;
output [count*d-1:0] out;

reg [count*d-1:0] state;

always @(posedge clk)
    state <= in;

assign out = state;

endmodule
