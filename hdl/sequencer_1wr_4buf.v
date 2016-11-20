/*
 PAVANA_XBAR

 Copyright (c) 2016 Alexander Antonov <153287@niuitmo.ru>
 All rights reserved.

 Version 1.0

 The FreeBSD license
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials
    provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 PAVANA_XBAR PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


module sequencer_1wr_4buf
#(
	parameter TAG_WIDTH = 2,
	DATA_WIDTH = 32
)
(
	input clk_i, rst_i,

	input wr_i,
	input [DATA_WIDTH-1:0] wrdata_bi,
	input [TAG_WIDTH-1:0] wrtag_i,

	output tag_fifo_full,
	input tag_fifo_wrreq,
	input [TAG_WIDTH-1:0] tag_fifo_wdata,

	output reg wr_o,
	output reg [DATA_WIDTH-1:0] wrdata_bo
);

localparam BUFSIZE_POW = 3;

reg [DATA_WIDTH-1:0] array_reg 		[2**BUFSIZE_POW-1:0];
reg [DATA_WIDTH-1:0] array_reg_next [2**BUFSIZE_POW-1:0];

reg [TAG_WIDTH-1:0] tag_reg 		[2**BUFSIZE_POW-1:0];
reg [TAG_WIDTH-1:0] tag_reg_next 	[2**BUFSIZE_POW-1:0];

reg [BUFSIZE_POW:0] cursize, cursize_next;

reg wr_o_next;
reg [DATA_WIDTH-1:0] wrdata_bo_next;

// tag interface
wire tag_fifo_empty;
reg tag_fifo_rdreq;
wire [TAG_WIDTH-1:0] tag_fifo_rdata;

fifo
#(
	.B(TAG_WIDTH),
	.W(BUFSIZE_POW)
) tag_fifo (
	.clk(clk_i),
	.reset(rst_i),
	.rd(tag_fifo_rdreq),
	.wr(tag_fifo_wrreq),
	.w_data(tag_fifo_wdata),
	.empty(tag_fifo_empty),
	.full(tag_fifo_full),
	.r_data(tag_fifo_rdata)
);

// register logic
integer k;
always @(posedge clk_i)
	begin
	if (rst_i)
		begin
		cursize <= 0;

		wr_o <= 1'b0;
		wrdata_bo <= 0;

		for (k = 0; k < (1<<BUFSIZE_POW); k = k + 1)
			begin
			array_reg[k] <= 0;
			tag_reg[k] <= 0;
			end
		end
	else
		begin
		cursize <= cursize_next;

		wr_o <= wr_o_next;
		wrdata_bo <= wrdata_bo_next;

		for (k = 0; k < (1<<BUFSIZE_POW); k = k + 1)
			begin
			array_reg[k] <= array_reg_next[k];
			tag_reg[k] <= tag_reg_next[k];
			end
		end
	end

// next state logic
integer i;
always @*
	begin

	cursize_next = cursize;
	wr_o_next = 1'b0;
	wrdata_bo_next = 0;
	tag_fifo_rdreq = 1'b0;


	for (i = 0; i < (1<<BUFSIZE_POW); i = i + 1)
		begin
		array_reg_next[i] = array_reg[i];
		tag_reg_next[i] = tag_reg[i];
		end

	// reading next value
	if (!tag_fifo_empty)
		begin

		if ((tag_reg_next[0] == tag_fifo_rdata) && (cursize_next > 0))
			begin
			wr_o_next = 1'b1;
			wrdata_bo_next = array_reg_next[0];
			tag_fifo_rdreq = 1'b1;
			cursize_next = cursize_next - 1;

			for (i = 0; i < ((1<<BUFSIZE_POW)-1); i = i + 1)
				begin
				array_reg_next[i] = array_reg_next[i + 1];
				tag_reg_next[i] = tag_reg_next[i + 1];
				end
			end

		else if ((tag_reg_next[1] == tag_fifo_rdata) && (cursize_next > 1))
			begin
			wr_o_next = 1'b1;
			wrdata_bo_next = array_reg_next[1];
			tag_fifo_rdreq = 1'b1;
			cursize_next = cursize_next - 1;

			for (i = 1; i < ((1<<BUFSIZE_POW)-1); i = i + 1)
				begin
				array_reg_next[i] = array_reg_next[i + 1];
				tag_reg_next[i] = tag_reg_next[i + 1];
				end
			end

		else if ((tag_reg_next[2] == tag_fifo_rdata) && (cursize_next > 2))
			begin
			wr_o_next = 1'b1;
			wrdata_bo_next = array_reg_next[2];
			tag_fifo_rdreq = 1'b1;
			cursize_next = cursize_next - 1;

			for (i = 2; i < ((1<<BUFSIZE_POW)-1); i = i + 1)
				begin
				array_reg_next[i] = array_reg_next[i + 1];
				tag_reg_next[i] = tag_reg_next[i + 1];
				end
			end

		else if ((tag_reg_next[3] == tag_fifo_rdata) && (cursize_next > 3))
			begin
			wr_o_next = 1'b1;
			wrdata_bo_next = array_reg_next[3];
			tag_fifo_rdreq = 1'b1;
			cursize_next = cursize_next - 1;
			end
		end

	if (wr_i)
		begin
		array_reg_next[cursize_next] = wrdata_bi;
		tag_reg_next[cursize_next] = wrtag_i;
		cursize_next = cursize_next + 1;
		end

	end

endmodule
