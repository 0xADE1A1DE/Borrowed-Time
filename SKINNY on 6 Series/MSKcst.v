`timescale 1ns/1ps
module MSKcst #(parameter d=1, parameter count=1) (cst, out);

input [count-1:0] cst;
output [count*d-1:0] out;

genvar i;
for(i=0; i<count; i=i+1) begin: i_gen_m
    assign out[i*d +: d] = { cst[i], {(d-1){1'b0}}};
end

endmodule
