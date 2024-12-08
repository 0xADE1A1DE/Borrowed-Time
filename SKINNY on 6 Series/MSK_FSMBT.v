`timescale 1ns / 1ps
module MSK_FSMBT #(parameter d = 2) (clk, start, reset, rnd, rnd_BT, K_in, PT_in, CT, done, clear);
localparam and_pini_mul_nrnd = d*(d-1)/2;
localparam and_pini_nrnd = and_pini_mul_nrnd;
input clk;
input start;
input reset;
input [16*2*and_pini_nrnd-1:0] rnd;
input [128*d-1 : 0] K_in;
input [128*d-1 : 0] PT_in;
output reg done;
output [128*d-1 : 0] CT;

// BT
input [63:0] rnd_BT;
input clear;

reg[3:0] cycle_cnt;
reg[5:0] round_cnt;
reg state, next_state;
reg sel, reset_round_cnt, start_round;
wire en;
reg en_glitch;
reg [56*d-1 : 0] D;
wire [128*d-1:0] K;

reg sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2;
reg en2, en3, en4, en5;


`define IDLE 0
`define COMPUTE 1

assign en = start_round;

MSKskinny_encryptBT #(d) skinnyfsm (clk, en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, sel, en, en_glitch, done, rnd, rnd_BT, K_in, PT_in, CT, clear);

always @ (posedge clk) begin
	if(reset) begin
		state <= `IDLE; 
	end
	else begin
		state <= next_state;
	end
end

always@(*)begin
next_state = state;
done = 0;
sel = 0; 
reset_round_cnt = 0;
start_round = 0;
en_glitch = 0;

sel1a1 = 0;
sel2a1 = 0;
sel1b1 = 0;
sel2b1 = 0;
sel1x1 = 0;
sel2x1 = 0;
sel1a2 = 0;
sel2a2 = 0;
sel1b2 = 0;
sel2b2 = 0;
sel1x2 = 0;
sel2x2 = 0;

en2 = 0;
en3 = 0;
en4 = 0;
en5 = 0;

case(state)

	`IDLE: begin
		if(start) begin
			next_state = `COMPUTE;
			start_round = 1;
			reset_round_cnt = 1;
			sel = 1;

		end
		
	end
	`COMPUTE: begin
		if(round_cnt == 39 & cycle_cnt == 5) begin
			next_state = `IDLE;
			done = 1; 
			sel = 1;
			start_round = 1;
            sel1x2 = 1;
            sel2x2 = 1;
            start_round = 1;

		end
		else begin
		if(round_cnt == 39 & cycle_cnt == 5) begin
			done = 1;
			sel = 1;
			start_round = 1;
            sel1x2 = 1;
            sel2x2 = 1;
            start_round = 1;
			reset_round_cnt = 1;

		end
		else begin
		if(round_cnt == 39 & cycle_cnt == 5) begin
			next_state = `IDLE;
			done = 1; 
			sel = 1;
			start_round = 1;
            sel1x2 = 1;
            sel2x2 = 1;
            start_round = 1;
    

		end
		if(cycle_cnt == 0) begin


            sel1b1 = 1;

        end
		else begin
		if (cycle_cnt == 1) begin
            sel2b1 = 1;
            sel1a1 = 1;
		    sel1b2 = 1;

            en2 = 1;
		end
		else begin
		if (cycle_cnt == 2) begin
            sel2b2 = 1;

            sel1b1 = 1;
            sel2b1 = 1;
            sel2a1 = 1;
            sel1x1 = 1;
            sel1a2 = 1;
            en3 = 1;

		end
        else begin
        if(cycle_cnt == 3) begin

            sel1a1 = 1;
            sel2a1 = 1;
            sel2x1 = 1;
            sel1b2 = 1;
            sel2b2 = 1;
            sel2a2 = 1;
            sel1x2 = 1;
            en4 = 1;

		end
		else begin
		if(cycle_cnt == 4) begin


           sel1x1 = 1;
            sel2x1 = 1;
        sel1a2 = 1;
            sel2a2 = 1;
            sel2x2 = 1;
            en5 = 1;

			en_glitch = 1;

		end
		else begin
		if(cycle_cnt == 5) begin
            sel1x2 = 1;
            sel2x2 = 1;
            start_round = 1;
    


		end
		end
		end
		end
		end
		end
		end
		end
	end
	default: begin

	end
endcase

end

always @(posedge clk) begin
if((state == `COMPUTE) & ~start_round) begin
	cycle_cnt <= cycle_cnt + 1;
end 
else begin
	cycle_cnt <= 0;
	end
end

always @(posedge clk) begin
if(reset_round_cnt) begin
	round_cnt <= 0;
end else if (start_round) begin
	round_cnt <= round_cnt + 1;
end


end

endmodule