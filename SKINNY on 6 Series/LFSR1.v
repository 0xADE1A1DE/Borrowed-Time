`timescale 1ns / 1ps
module LFSR1 (
    clk,
    sel,
    en,
    rounded_cst
);

input clk, sel, en;
output [5:0] rounded_cst;

reg [5:0] rounding_cst;
wire [5:0] outmux1, outmux2;
wire out1;

assign outmux1 = (sel) ? {(6){1'b0}} : rounded_cst;

assign outmux2 = (en) ? outmux1 : rounding_cst;

always @ (posedge clk) begin
    rounding_cst <= outmux2;
end

assign out1 = rounding_cst[5] ^ rounding_cst[4];
assign rounded_cst[0] = ~out1;

assign rounded_cst[5:1] = rounding_cst[4:0];

endmodule