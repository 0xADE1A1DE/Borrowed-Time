`timescale 1ns/1ps
module MSKregBT #(parameter d=1, parameter count=1) (clk, in, rnd, clear, out);

input clk;
input  [count*d-1:0] in;
output [count*d-1:0] out;

// BT
input  [count-1:0] rnd;
input  clear;

reg [count*d-1:0] state;

integer i;

always @(posedge clk)
	if ( clear ) begin
		// BT masked clear on all bits of share 0
		for ( i=0; i<count*d; i = i + d ) begin
			state[i] <= rnd[i/d];
		end
	end
	else begin
		state <= in;
	end

assign out = state;

endmodule
