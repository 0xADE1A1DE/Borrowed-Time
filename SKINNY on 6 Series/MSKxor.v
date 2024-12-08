`timescale 1ns/1ps
module MSKxor #(parameter d=1, parameter count=1) (ina, inb, out);

input  [count*d-1:0] ina, inb;
output [count*d-1:0] out;

assign out = ina ^ inb ;

endmodule
