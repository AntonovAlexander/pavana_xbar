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


module pavana_xbar_inorder_8buf
#(
	parameter SLAVE_BUFSIZE_ORDER = 3
)
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
	output [31:0] slave_0_wdata,
	input slave_0_ack,
	input [31:0] slave_0_rdata,
	input slave_0_resp,

	output slave_1_req,
	output [31:0] slave_1_addr,
	output slave_1_cmd,
	output [31:0] slave_1_wdata,
	input slave_1_ack,
	input [31:0] slave_1_rdata,
	input slave_1_resp,

	output slave_2_req,
	output [31:0] slave_2_addr,
	output slave_2_cmd,
	output [31:0] slave_2_wdata,
	input slave_2_ack,
	input [31:0] slave_2_rdata,
	input slave_2_resp,

	output slave_3_req,
	output [31:0] slave_3_addr,
	output slave_3_cmd,
	output [31:0] slave_3_wdata,
	input slave_3_ack,
	input [31:0] slave_3_rdata,
	input slave_3_resp
);

wire master_0_rdreq_full, master_1_rdreq_full, master_2_rdreq_full, master_3_rdreq_full;

wire master_0_req_gated, master_1_req_gated, master_2_req_gated, master_3_req_gated;
assign master_0_req_gated = (master_0_cmd == 1'b0) ? (master_0_req & (!master_0_rdreq_full)) : master_0_req;
assign master_1_req_gated = (master_1_cmd == 1'b0) ? (master_1_req & (!master_1_rdreq_full)) : master_1_req;
assign master_2_req_gated = (master_2_cmd == 1'b0) ? (master_2_req & (!master_2_rdreq_full)) : master_2_req;
assign master_3_req_gated = (master_3_cmd == 1'b0) ? (master_3_req & (!master_3_rdreq_full)) : master_3_req;

wire master_0_ack_togate, master_1_ack_togate, master_2_ack_togate, master_3_ack_togate;
assign master_0_ack = master_0_ack_togate & master_0_req_gated;
assign master_1_ack = master_1_ack_togate & master_1_req_gated;
assign master_2_ack = master_2_ack_togate & master_2_req_gated;
assign master_3_ack = master_3_ack_togate & master_3_req_gated;

wire reqbuf_slave_0_req, reqbuf_slave_1_req, reqbuf_slave_2_req, reqbuf_slave_3_req;
wire [31:0] reqbuf_slave_0_addr, reqbuf_slave_1_addr, reqbuf_slave_2_addr, reqbuf_slave_3_addr;
wire reqbuf_slave_0_cmd, reqbuf_slave_1_cmd, reqbuf_slave_2_cmd, reqbuf_slave_3_cmd;
wire [31:0] reqbuf_slave_0_wdata, reqbuf_slave_1_wdata, reqbuf_slave_2_wdata, reqbuf_slave_3_wdata;
wire reqbuf_slave_0_ack, reqbuf_slave_1_ack, reqbuf_slave_2_ack, reqbuf_slave_3_ack;

wire [1:0] reqbuf_slave_0_mnum, reqbuf_slave_1_mnum, reqbuf_slave_2_mnum, reqbuf_slave_3_mnum;
wire [1:0] slave_0_mnum, slave_1_mnum, slave_2_mnum, slave_3_mnum;


arbiter_4x4_rr_comb
#(
	.WIDTH(65)
) arbiter_4x4_rr_comb (
	.clk_i(clk_i),
	.rst_i(rst_i),

	// master interfaces
	.master_0_req(master_0_req_gated),
	.master_0_snum(master_0_addr[31:30]),
	.master_0_data({master_0_addr, master_0_cmd, master_0_wdata}),
	.master_0_ack(master_0_ack_togate),

	.master_1_req(master_1_req_gated),
	.master_1_snum(master_1_addr[31:30]),
	.master_1_data({master_1_addr, master_1_cmd, master_1_wdata}),
	.master_1_ack(master_1_ack_togate),

	.master_2_req(master_2_req_gated),
	.master_2_snum(master_2_addr[31:30]),
	.master_2_data({master_2_addr, master_2_cmd, master_2_wdata}),
	.master_2_ack(master_2_ack_togate),

	.master_3_req(master_3_req_gated),
	.master_3_snum(master_3_addr[31:30]),
	.master_3_data({master_3_addr, master_3_cmd, master_3_wdata}),
	.master_3_ack(master_3_ack_togate),

	// slave interfaces
	.slave_0_req(reqbuf_slave_0_req),
	.slave_0_data({reqbuf_slave_0_addr, reqbuf_slave_0_cmd, reqbuf_slave_0_wdata}),
	.slave_0_mnum(reqbuf_slave_0_mnum),
	.slave_0_ack(reqbuf_slave_0_ack),

	.slave_1_req(reqbuf_slave_1_req),
	.slave_1_data({reqbuf_slave_1_addr, reqbuf_slave_1_cmd, reqbuf_slave_1_wdata}),
	.slave_1_mnum(reqbuf_slave_1_mnum),
	.slave_1_ack(reqbuf_slave_1_ack),

	.slave_2_req(reqbuf_slave_2_req),
	.slave_2_data({reqbuf_slave_2_addr, reqbuf_slave_2_cmd, reqbuf_slave_2_wdata}),
	.slave_2_mnum(reqbuf_slave_2_mnum),
	.slave_2_ack(reqbuf_slave_2_ack),

	.slave_3_req(reqbuf_slave_3_req),
	.slave_3_data({reqbuf_slave_3_addr, reqbuf_slave_3_cmd, reqbuf_slave_3_wdata}),
	.slave_3_mnum(reqbuf_slave_3_mnum),
	.slave_3_ack(reqbuf_slave_3_ack)
);

wire [1:0] slave_0_route_mnum, slave_1_route_mnum, slave_2_route_mnum, slave_3_route_mnum;

sequencer_4wr_8buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) sequencer_master_0 (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr0_i(slave_0_resp & (slave_0_route_mnum == 2'h0)),
	.wrdata0_bi(slave_0_rdata),
	.wrtag0_i(2'h0),

	.wr1_i(slave_1_resp & (slave_1_route_mnum == 2'h0)),
	.wrdata1_bi(slave_1_rdata),
	.wrtag1_i(2'h1),

	.wr2_i(slave_2_resp & (slave_2_route_mnum == 2'h0)),
	.wrdata2_bi(slave_2_rdata),
	.wrtag2_i(2'h2),

	.wr3_i(slave_3_resp & (slave_3_route_mnum == 2'h0)),
	.wrdata3_bi(slave_3_rdata),
	.wrtag3_i(2'h3),

	.tag_fifo_full(master_0_rdreq_full),
	.tag_fifo_wrreq(master_0_req & master_0_ack & !master_0_cmd),
	.tag_fifo_wdata(master_0_addr[31:30]),

	.wr_o(master_0_resp),
	.wrdata_bo(master_0_rdata)
);

sequencer_4wr_8buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) sequencer_master_1 (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr0_i(slave_0_resp & (slave_0_route_mnum == 2'h1)),
	.wrdata0_bi(slave_0_rdata),
	.wrtag0_i(2'h0),

	.wr1_i(slave_1_resp & (slave_1_route_mnum == 2'h1)),
	.wrdata1_bi(slave_1_rdata),
	.wrtag1_i(2'h1),

	.wr2_i(slave_2_resp & (slave_2_route_mnum == 2'h1)),
	.wrdata2_bi(slave_2_rdata),
	.wrtag2_i(2'h2),

	.wr3_i(slave_3_resp & (slave_3_route_mnum == 2'h1)),
	.wrdata3_bi(slave_3_rdata),
	.wrtag3_i(2'h3),

	.tag_fifo_full(master_1_rdreq_full),
	.tag_fifo_wrreq(master_1_req & master_1_ack & !master_1_cmd),
	.tag_fifo_wdata(master_1_addr[31:30]),

	.wr_o(master_1_resp),
	.wrdata_bo(master_1_rdata)
);

sequencer_4wr_8buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) sequencer_master_2 (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr0_i(slave_0_resp & (slave_0_route_mnum == 2'h2)),
	.wrdata0_bi(slave_0_rdata),
	.wrtag0_i(2'h0),

	.wr1_i(slave_1_resp & (slave_1_route_mnum == 2'h2)),
	.wrdata1_bi(slave_1_rdata),
	.wrtag1_i(2'h1),

	.wr2_i(slave_2_resp & (slave_2_route_mnum == 2'h2)),
	.wrdata2_bi(slave_2_rdata),
	.wrtag2_i(2'h2),

	.wr3_i(slave_3_resp & (slave_3_route_mnum == 2'h2)),
	.wrdata3_bi(slave_3_rdata),
	.wrtag3_i(2'h3),

	.tag_fifo_full(master_2_rdreq_full),
	.tag_fifo_wrreq(master_2_req & master_2_ack & !master_2_cmd),
	.tag_fifo_wdata(master_2_addr[31:30]),

	.wr_o(master_2_resp),
	.wrdata_bo(master_2_rdata)
);

sequencer_4wr_8buf
#(
	.TAG_WIDTH(2),
	.DATA_WIDTH(32)
) sequencer_master_3 (
	.clk_i(clk_i),
	.rst_i(rst_i),

	.wr0_i(slave_0_resp & (slave_0_route_mnum == 2'h3)),
	.wrdata0_bi(slave_0_rdata),
	.wrtag0_i(2'h0),

	.wr1_i(slave_1_resp & (slave_1_route_mnum == 2'h3)),
	.wrdata1_bi(slave_1_rdata),
	.wrtag1_i(2'h1),

	.wr2_i(slave_2_resp & (slave_2_route_mnum == 2'h3)),
	.wrdata2_bi(slave_2_rdata),
	.wrtag2_i(2'h2),

	.wr3_i(slave_3_resp & (slave_3_route_mnum == 2'h3)),
	.wrdata3_bi(slave_3_rdata),
	.wrtag3_i(2'h3),

	.tag_fifo_full(master_3_rdreq_full),
	.tag_fifo_wrreq(master_3_req & master_3_ack & !master_3_cmd),
	.tag_fifo_wdata(master_3_addr[31:30]),

	.wr_o(master_3_resp),
	.wrdata_bo(master_3_rdata)
);

fifo
#(
	.B(2),
	.W(SLAVE_BUFSIZE_ORDER)
) slave_0_resp_router_fifo (
	.clk(clk_i),
	.reset(rst_i),
	.rd(slave_0_resp),
	.wr(slave_0_req & slave_0_ack & !slave_0_cmd),
	.w_data(slave_0_mnum),
	.full(slave_0_rdreq_full),
	.r_data(slave_0_route_mnum)
);

fifo
#(
	.B(2),
	.W(SLAVE_BUFSIZE_ORDER)
) slave_1_resp_router_fifo (
	.clk(clk_i),
	.reset(rst_i),
	.rd(slave_1_resp),
	.wr(slave_1_req & slave_1_ack & !slave_1_cmd),
	.w_data(slave_1_mnum),
	.full(slave_1_rdreq_full),
	.r_data(slave_1_route_mnum)
);

fifo
#(
	.B(2),
	.W(SLAVE_BUFSIZE_ORDER)
) slave_2_resp_router_fifo (
	.clk(clk_i),
	.reset(rst_i),
	.rd(slave_2_resp),
	.wr(slave_2_req & slave_2_ack & !slave_2_cmd),
	.w_data(slave_2_mnum),
	.full(slave_2_rdreq_full),
	.r_data(slave_2_route_mnum)
);

fifo
#(
	.B(2),
	.W(SLAVE_BUFSIZE_ORDER)
) slave_3_resp_router_fifo (
	.clk(clk_i),
	.reset(rst_i),
	.rd(slave_3_resp),
	.wr(slave_3_req & slave_3_ack & !slave_3_cmd),
	.w_data(slave_3_mnum),
	.full(slave_3_rdreq_full),
	.r_data(slave_3_route_mnum)
);

wire slave_0_req_togate, slave_1_req_togate, slave_2_req_togate, slave_3_req_togate;
assign slave_0_req = (slave_0_cmd == 1'b0) ? (slave_0_req_togate & (!slave_0_rdreq_full)) : slave_0_req_togate;
assign slave_1_req = (slave_1_cmd == 1'b0) ? (slave_1_req_togate & (!slave_1_rdreq_full)) : slave_1_req_togate;
assign slave_2_req = (slave_2_cmd == 1'b0) ? (slave_2_req_togate & (!slave_2_rdreq_full)) : slave_2_req_togate;
assign slave_3_req = (slave_3_cmd == 1'b0) ? (slave_3_req_togate & (!slave_3_rdreq_full)) : slave_3_req_togate;

wire slave_0_ack_gated, slave_1_ack_gated, slave_2_ack_gated, slave_3_ack_gated;
assign slave_0_ack_gated = slave_0_ack & slave_0_req;
assign slave_1_ack_gated = slave_1_ack & slave_1_req;
assign slave_2_ack_gated = slave_2_ack & slave_2_req;
assign slave_3_ack_gated = slave_3_ack & slave_3_req;

reqbuf reqbuf_slave_0
(
	.clk_i(clk_i),
	.rst_i(rst_i),

	.master_req_i(reqbuf_slave_0_req),
	.master_data_bi({reqbuf_slave_0_mnum, reqbuf_slave_0_cmd, reqbuf_slave_0_addr, reqbuf_slave_0_wdata}),
	.master_ack_o(reqbuf_slave_0_ack),

	.slave_req_o(slave_0_req_togate),
	.slave_data_bo({slave_0_mnum, slave_0_cmd, slave_0_addr, slave_0_wdata}),
	.slave_ack_i(slave_0_ack_gated)
);

reqbuf reqbuf_slave_1
(
	.clk_i(clk_i),
	.rst_i(rst_i),

	.master_req_i(reqbuf_slave_1_req),
	.master_data_bi({reqbuf_slave_1_mnum, reqbuf_slave_1_cmd, reqbuf_slave_1_addr, reqbuf_slave_1_wdata}),
	.master_ack_o(reqbuf_slave_1_ack),

	.slave_req_o(slave_1_req_togate),
	.slave_data_bo({slave_1_mnum, slave_1_cmd, slave_1_addr, slave_1_wdata}),
	.slave_ack_i(slave_1_ack_gated)
);

reqbuf reqbuf_slave_2
(
	.clk_i(clk_i),
	.rst_i(rst_i),

	.master_req_i(reqbuf_slave_2_req),
	.master_data_bi({reqbuf_slave_2_mnum, reqbuf_slave_2_cmd, reqbuf_slave_2_addr, reqbuf_slave_2_wdata}),
	.master_ack_o(reqbuf_slave_2_ack),

	.slave_req_o(slave_2_req_togate),
	.slave_data_bo({slave_2_mnum, slave_2_cmd, slave_2_addr, slave_2_wdata}),
	.slave_ack_i(slave_2_ack_gated)
);

reqbuf reqbuf_slave_3
(
	.clk_i(clk_i),
	.rst_i(rst_i),

	.master_req_i(reqbuf_slave_3_req),
	.master_data_bi({reqbuf_slave_3_mnum, reqbuf_slave_3_cmd, reqbuf_slave_3_addr, reqbuf_slave_3_wdata}),
	.master_ack_o(reqbuf_slave_3_ack),

	.slave_req_o(slave_3_req_togate),
	.slave_data_bo({slave_3_mnum, slave_3_cmd, slave_3_addr, slave_3_wdata}),
	.slave_ack_i(slave_3_ack_gated)
);

endmodule
