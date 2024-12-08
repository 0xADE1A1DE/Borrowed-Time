`timescale 1ns/1ps
module MSKand_HPC2 #(parameter d=2) (ina, inb, rnd, clk, out);

localparam and_pini_mul_nrnd = d*(d-1)/2;
localparam and_pini_nrnd = and_pini_mul_nrnd;// INPUT / OUTPUT

input  [d-1:0] ina;
input  [d-1:0] inb;
input [and_pini_nrnd-1:0] rnd;
input clk;
output [d-1:0] out;

genvar i,j;

// unpack vector to matrix --> easier for randomness handling
reg [and_pini_nrnd-1:0] rnd_prev;
always @(posedge clk) rnd_prev <= rnd;

wire [d-1:0] rnd_mat [d-1:0]; 
wire [d-1:0] rnd_mat_prev [d-1:0]; 
for(i=0; i<d; i=i+1) begin: igen
    assign rnd_mat[i][i] = 0;
    assign rnd_mat_prev[i][i] = 0;
    for(j=i+1; j<d; j=j+1) begin: jgen
        assign rnd_mat[j][i] = rnd[((i*d)-i*(i+1)/2)+(j-1-i)];
        assign rnd_mat[i][j] = rnd_mat[j][i];
        assign rnd_mat_prev[j][i] = rnd_prev[((i*d)-i*(i+1)/2)+(j-1-i)];
        assign rnd_mat_prev[i][j] = rnd_mat_prev[j][i];
    end
end

wire [d-1:0] not_ina = ~ina;
reg [d-1:0] inb_prev;
always @(posedge clk) inb_prev <= inb;

for(i=0; i<d; i=i+1) begin: ParProdI
    reg [d-2:0] u, v, w;
    reg aibi;
    wire aibi_comb = ina[i] & inb_prev[i];
    always @(posedge clk) aibi <= aibi_comb;
    assign out[i] = aibi ^ ^u ^ ^w;
    for(j=0; j<d; j=j+1) begin: ParProdJ
        if (i != j) begin: NotEq
            localparam j2 = j < i ?  j : j-1;
            wire u_j2_comb = not_ina[i] & rnd_mat_prev[i][j];
            wire v_j2_comb = inb[j] ^ rnd_mat[i][j];
            wire w_j2_comb = ina[i] & v[j2];
            always @(posedge clk)
            begin
                u[j2] <= u_j2_comb;
                v[j2] <= v_j2_comb;
                w[j2] <= w_j2_comb;
            end
        end
    end
end

endmodule
