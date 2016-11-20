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


module pavana_xbar_ooo_4buf
(
	input clk_i, rst_i,

	input master_0_req,
	input [31:0] master_0_addr,
	input master_0_cmd,
	input [31:0] master_0_wdata,
	output master_0_ack,
	output [31:0] master_0_rdata,
	output master_0_resp,

	input master_1_req,
	input [31:0] master_1_addr,
	input master_1_cmd,
	input [31:0] master_1_wdata,
	output master_1_ack,
	output [31:0] master_1_rdata,
	output master_1_resp,

	input master_2_req,
	input [31:0] master_2_addr,
	input master_2_cmd,
	input [31:0] master_2_wdata,
	output master_2_ack,
	output [31:0] master_2_rdata,
	output master_2_resp,

	input master_3_req,
	input [31:0] master_3_addr,
	input master_3_cmd,
	input [31:0] master_3_wdata,
	output master_3_ack,
	output [31:0] master_3_rdata,
	output master_3_resp,

	output slave_0_req,
	output [31:0] slave_0_addr,
	output slave_0_cmd,
	input [1:0] slave_0_reqtid,
	output [31:0] slave_0_wdata,
	input slave_0_ack,
	input [1:0] slave_0_resptid,
	input [31:0] slave_0_rdata,
	input slave_0_resp,

	output slave_1_req,
	output [31:0] slave_1_addr,
	output slave_1_cmd,
	input [1:0] slave_1_reqtid,
	output [31:0] slave_1_wdata,
	input slave_1_ack,
	input [1:0] slave_1_resptid,
	input [31:0] slave_1_rdata,
	input slave_1_resp,

	output slave_2_req,
	output [31:0] slave_2_addr,
	output slave_2_cmd,
	input [1:0] slave_2_reqtid,
	output [31:0] slave_2_wdata,
	input slave_2_ack,
	input [1:0] slave_2_resptid,
	input [31:0] slave_2_rdata,
	input slave_2_resp,

	output slave_3_req,
	output [31:0] slave_3_addr,
	output slave_3_cmd,
	input [1:0] slave_3_reqtid,
	output [31:0] slave_3_wdata,
	input slave_3_ack,
	input [1:0] slave_3_resptid,
	input [31:0] slave_3_rdata,
	input slave_3_resp
);

localparam SLAVE_BUFSIZE_ORDER = 2;

wire slave_0_resp_ordered, slave_1_resp_ordered, slave_2_resp_ordered, slave_3_resp_ordered;
wire [31:0] slave_0_rdata_ordered, slave_1_rdata_ordered, slave_2_rdata_ordered, slave_3_rdata_ordered;

pavana_xbar_inorder_4buf
#(
	.SLAVE_BUFSIZE_ORDER(SLAVE_BUFSIZE_ORDER)
) pavana_xbar_inorder (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.master_0_req(master_0_req),
	.master_0_addr(master_0_addr),
	.master_0_cmd(master_0_cmd),
	.master_0_wdata(master_0_wdata),
	.master_0_ack(master_0_ack),
	.master_0_rdata(master_0_rdata),
	.master_0_resp(master_0_resp),

	.master_1_req(master_1_req),
	.master_1_addr(master_1_addr),
	.master_1_cmd(master_1_cmd),
	.master_1_wdata(master_1_wdata),
	.master_1_ack(master_1_ack),
	.master_1_rdata(master_1_rdata),
	.master_1_resp(master_1_resp),

	.master_2_req(master_2_req),
	.master_2_addr(master_2_addr),
	.master_2_cmd(master_2_cmd),
	.master_2_wdata(master_2_wdata),
	.master_2_ack(master_2_ack),
	.master_2_rdata(master_2_rdata),
	.master_2_resp(master_2_resp),

	.master_3_req(master_3_req),
	.master_3_addr(master_3_addr),
	.master_3_cmd(master_3_cmd),
	.master_3_wdata(master_3_wdata),
	.master_3_ack(master_3_ack),
	.master_3_rdata(master_3_rdata),
	.master_3_resp(master_3_resp),

	.slave_0_req(slave_0_req),
	.slave_0_addr(slave_0_addr),
	.slave_0_cmd(slave_0_cmd),
	.slave_0_wdata(slave_0_wdata),
	.slave_0_ack(slave_0_ack),
	.slave_0_rdata(slave_0_rdata_ordered),
	.slave_0_resp(slave_0_resp_ordered),

	.slave_1_req(slave_1_req),
	.slave_1_addr(slave_1_addr),
	.slave_1_cmd(slave_1_cmd),
	.slave_1_wdata(slave_1_wdata),
	.slave_1_ack(slave_1_ack),
	.slave_1_rdata(slave_1_rdata_ordered),
	.slave_1_resp(slave_1_resp_ordered),

	.slave_2_req(slave_2_req),
	.slave_2_addr(slave_2_addr),
	.slave_2_cmd(slave_2_cmd),
	.slave_2_wdata(slave_2_wdata),
	.slave_2_ack(slave_2_ack),
	.slave_2_rdata(slave_2_rdata_ordered),
	.slave_2_resp(slave_2_resp_ordered),

	.slave_3_req(slave_3_req),
	.slave_3_addr(slave_3_addr),
	.slave_3_cmd(slave_3_cmd),
	.slave_3_wdata(slave_3_wdata),
	.slave_3_ack(slave_3_ack),
	.slave_3_rdata(slave_3_rdata_ordered),
	.slave_3_resp(slave_3_resp_ordered)
);

wire slave_0_sequencer_fifo_full, slave_1_sequencer_fifo_full, slave_2_sequencer_fifo_full, slave_3_sequencer_fifo_full;

sequencer_1wr_4buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) slave_0_sequencer (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr_i(slave_0_resp),
	.wrdata_bi(slave_0_rdata),
	.wrtag_i(slave_0_resptid),

	.tag_fifo_full(slave_0_sequencer_fifo_full),
	.tag_fifo_wrreq(slave_0_req & slave_0_ack & !slave_0_cmd),
	.tag_fifo_wdata(slave_0_reqtid),

	.wr_o(slave_0_resp_ordered),
	.wrdata_bo(slave_0_rdata_ordered)
);

sequencer_1wr_4buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) slave_1_sequencer (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr_i(slave_1_resp),
	.wrdata_bi(slave_1_rdata),
	.wrtag_i(slave_1_resptid),

	.tag_fifo_full(slave_1_sequencer_fifo_full),
	.tag_fifo_wrreq(slave_1_req & slave_1_ack & !slave_1_cmd),
	.tag_fifo_wdata(slave_1_reqtid),

	.wr_o(slave_1_resp_ordered),
	.wrdata_bo(slave_1_rdata_ordered)
);

sequencer_1wr_4buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) slave_2_sequencer (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr_i(slave_2_resp),
	.wrdata_bi(slave_2_rdata),
	.wrtag_i(slave_2_resptid),

	.tag_fifo_full(slave_2_sequencer_fifo_full),
	.tag_fifo_wrreq(slave_2_req & slave_2_ack & !slave_2_cmd),
	.tag_fifo_wdata(slave_2_reqtid),

	.wr_o(slave_2_resp_ordered),
	.wrdata_bo(slave_2_rdata_ordered)
);

sequencer_1wr_4buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) slave_3_sequencer (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr_i(slave_3_resp),
	.wrdata_bi(slave_3_rdata),
	.wrtag_i(slave_3_resptid),

	.tag_fifo_full(slave_3_sequencer_fifo_full),
	.tag_fifo_wrreq(slave_3_req & slave_3_ack & !slave_3_cmd),
	.tag_fifo_wdata(slave_3_reqtid),

	.wr_o(slave_3_resp_ordered),
	.wrdata_bo(slave_3_rdata_ordered)
);

endmodule
