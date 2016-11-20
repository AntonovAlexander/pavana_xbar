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


module arbiter_4x4_rr_comb
#(
	parameter WIDTH = 32
)
(
	input clk_i, rst_i,

	// master interfaces
	input master_0_req,
	input [1:0] master_0_snum,
	input [WIDTH-1:0] master_0_data,
	output reg master_0_ack,

	input master_1_req,
	input [1:0] master_1_snum,
	input [WIDTH-1:0] master_1_data,
	output reg master_1_ack,

	input master_2_req,
	input [1:0] master_2_snum,
	input [WIDTH-1:0] master_2_data,
	output reg master_2_ack,

	input master_3_req,
	input [1:0] master_3_snum,
	input [WIDTH-1:0] master_3_data,
	output reg master_3_ack,

	// slave interfaces
	output reg slave_0_req,
	output reg [WIDTH-1:0] slave_0_data,
	input slave_0_ack,
	output reg [1:0] slave_0_mnum,

	output reg slave_1_req,
	output reg [WIDTH-1:0] slave_1_data,
	input slave_1_ack,
	output reg [1:0] slave_1_mnum,

	output reg slave_2_req,
	output reg [WIDTH-1:0] slave_2_data,
	input slave_2_ack,
	output reg [1:0] slave_2_mnum,

	output reg slave_3_req,
	output reg [WIDTH-1:0] slave_3_data,
	input slave_3_ack,
	output reg [1:0] slave_3_mnum
);


// Requests decoding
reg m0_s0_req, m0_s1_req, m0_s2_req, m0_s3_req;
reg m1_s0_req, m1_s1_req, m1_s2_req, m1_s3_req;
reg m2_s0_req, m2_s1_req, m2_s2_req, m2_s3_req;
reg m3_s0_req, m3_s1_req, m3_s2_req, m3_s3_req;

always @*
	begin
	m0_s0_req = 1'b0;
	m0_s1_req = 1'b0;
	m0_s2_req = 1'b0;
	m0_s3_req = 1'b0;

	if (master_0_req == 1'b1)
		begin
		case (master_0_snum)
			2'b00: m0_s0_req = 1'b1;
			2'b01: m0_s1_req = 1'b1;
			2'b10: m0_s2_req = 1'b1;
			2'b11: m0_s3_req = 1'b1;
		endcase
		end
	end

always @*
	begin
	m1_s0_req = 1'b0;
	m1_s1_req = 1'b0;
	m1_s2_req = 1'b0;
	m1_s3_req = 1'b0;

	if (master_1_req == 1'b1)
		begin
		case (master_1_snum)
			2'b00: m1_s0_req = 1'b1;
			2'b01: m1_s1_req = 1'b1;
			2'b10: m1_s2_req = 1'b1;
			2'b11: m1_s3_req = 1'b1;
		endcase
		end
	end

always @*
	begin
	m2_s0_req = 1'b0;
	m2_s1_req = 1'b0;
	m2_s2_req = 1'b0;
	m2_s3_req = 1'b0;

	if (master_2_req == 1'b1)
		begin
		case (master_2_snum)
			2'b00: m2_s0_req = 1'b1;
			2'b01: m2_s1_req = 1'b1;
			2'b10: m2_s2_req = 1'b1;
			2'b11: m2_s3_req = 1'b1;
		endcase
		end
	end

always @*
	begin
	m3_s0_req = 1'b0;
	m3_s1_req = 1'b0;
	m3_s2_req = 1'b0;
	m3_s3_req = 1'b0;

	if (master_3_req == 1'b1)
		begin
		case (master_3_snum)
			2'b00: m3_s0_req = 1'b1;
			2'b01: m3_s1_req = 1'b1;
			2'b10: m3_s2_req = 1'b1;
			2'b11: m3_s3_req = 1'b1;
		endcase
		end
	end

// #### slave logic ####

//// slave 0 ////

reg [1:0] slave_0_rr_state;

always @(posedge clk_i)
	begin
	if (rst_i) slave_0_rr_state <= 2'b00;
	else if (slave_0_req && slave_0_ack) slave_0_rr_state <= slave_0_mnum + 2'b01;
	end

// master req switch
always @*
	begin

	slave_0_req = 1'b0;
	slave_0_data = 0;
	slave_0_mnum = 2'b00;

	case (slave_0_rr_state)

		2'b00:
			begin
			if (m0_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_0_data;
				slave_0_mnum = 2'b00;
				end
			else if (m1_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_1_data;
				slave_0_mnum = 2'b01;
				end
			else if (m2_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_2_data;
				slave_0_mnum = 2'b10;
				end
			else if (m3_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_3_data;
				slave_0_mnum = 2'b11;
				end
			end

		2'b01:
			begin
			if (m1_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_1_data;
				slave_0_mnum = 2'b01;
				end
			else if (m2_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_2_data;
				slave_0_mnum = 2'b10;
				end
			else if (m3_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_3_data;
				slave_0_mnum = 2'b11;
				end
			else if (m0_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_0_data;
				slave_0_mnum = 2'b00;
				end
			end

		2'b10:
			begin
			if (m2_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_2_data;
				slave_0_mnum = 2'b10;
				end
			else if (m3_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_3_data;
				slave_0_mnum = 2'b11;
				end
			else if (m0_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_0_data;
				slave_0_mnum = 2'b00;
				end
			else if (m1_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_1_data;
				slave_0_mnum = 2'b01;
				end
			end

		2'b11:
			begin
			if (m3_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_3_data;
				slave_0_mnum = 2'b11;
				end
			else if (m0_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_0_data;
				slave_0_mnum = 2'b00;
				end
			else if (m1_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_1_data;
				slave_0_mnum = 2'b01;
				end
			else if (m2_s0_req)
				begin
				slave_0_req = 1'b1;
				slave_0_data = master_2_data;
				slave_0_mnum = 2'b10;
				end
			end

	endcase
	end

//// slave 1 ////

reg [1:0] slave_1_rr_state;

always @(posedge clk_i)
	begin
	if (rst_i) slave_1_rr_state <= 2'b00;
	else if (slave_1_req && slave_1_ack) slave_1_rr_state <= slave_1_mnum + 2'b01;
	end

// master req switch
always @*
	begin

	slave_1_req = 1'b0;
	slave_1_data = 0;
	slave_1_mnum = 2'b00;

	case (slave_1_rr_state)

		2'b00:
			begin
			if (m0_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_0_data;
				slave_1_mnum = 2'b00;
				end
			else if (m1_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_1_data;
				slave_1_mnum = 2'b01;
				end
			else if (m2_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_2_data;
				slave_1_mnum = 2'b10;
				end
			else if (m3_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_3_data;
				slave_1_mnum = 2'b11;
				end
			end

		2'b01:
			begin
			if (m1_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_1_data;
				slave_1_mnum = 2'b01;
				end
			else if (m2_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_2_data;
				slave_1_mnum = 2'b10;
				end
			else if (m3_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_3_data;
				slave_1_mnum = 2'b11;
				end
			else if (m0_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_0_data;
				slave_1_mnum = 2'b00;
				end
			end

		2'b10:
			begin
			if (m2_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_2_data;
				slave_1_mnum = 2'b10;
				end
			else if (m3_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_3_data;
				slave_1_mnum = 2'b11;
				end
			else if (m0_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_0_data;
				slave_1_mnum = 2'b00;
				end
			else if (m1_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_1_data;
				slave_1_mnum = 2'b01;
				end
			end

		2'b11:
			begin
			if (m3_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_3_data;
				slave_1_mnum = 2'b11;
				end
			else if (m0_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_0_data;
				slave_1_mnum = 2'b00;
				end
			else if (m1_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_1_data;
				slave_1_mnum = 2'b01;
				end
			else if (m2_s1_req)
				begin
				slave_1_req = 1'b1;
				slave_1_data = master_2_data;
				slave_1_mnum = 2'b10;
				end
			end

	endcase
	end

//// slave 2 ////

reg [1:0] slave_2_rr_state;

always @(posedge clk_i)
	begin
	if (rst_i) slave_2_rr_state <= 2'b00;
	else if (slave_2_req && slave_2_ack) slave_2_rr_state <= slave_2_mnum + 2'b01;
	end

// master req switch
always @*
	begin

	slave_2_req = 1'b0;
	slave_2_data = 0;
	slave_2_mnum = 2'b00;

	case (slave_2_rr_state)

		2'b00:
			begin
			if (m0_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_0_data;
				slave_2_mnum = 2'b00;
				end
			else if (m1_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_1_data;
				slave_2_mnum = 2'b01;
				end
			else if (m2_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_2_data;
				slave_2_mnum = 2'b10;
				end
			else if (m3_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_3_data;
				slave_2_mnum = 2'b11;
				end
			end

		2'b01:
			begin
			if (m1_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_1_data;
				slave_2_mnum = 2'b01;
				end
			else if (m2_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_2_data;
				slave_2_mnum = 2'b10;
				end
			else if (m3_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_3_data;
				slave_2_mnum = 2'b11;
				end
			else if (m0_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_0_data;
				slave_2_mnum = 2'b00;
				end
			end

		2'b10:
			begin
			if (m2_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_2_data;
				slave_2_mnum = 2'b10;
				end
			else if (m3_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_3_data;
				slave_2_mnum = 2'b11;
				end
			else if (m0_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_0_data;
				slave_2_mnum = 2'b00;
				end
			else if (m1_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_1_data;
				slave_2_mnum = 2'b01;
				end
			end

		2'b11:
			begin
			if (m3_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_3_data;
				slave_2_mnum = 2'b11;
				end
			else if (m0_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_0_data;
				slave_2_mnum = 2'b00;
				end
			else if (m1_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_1_data;
				slave_2_mnum = 2'b01;
				end
			else if (m2_s2_req)
				begin
				slave_2_req = 1'b1;
				slave_2_data = master_2_data;
				slave_2_mnum = 2'b10;
				end
			end

	endcase
	end

//// slave 3 ////

reg [1:0] slave_3_rr_state;

always @(posedge clk_i)
	begin
	if (rst_i) slave_3_rr_state <= 2'b00;
	else if (slave_3_req && slave_3_ack) slave_3_rr_state <= slave_3_mnum + 2'b01;
	end

// master req switch
always @*
	begin

	slave_3_req = 1'b0;
	slave_3_data = 0;
	slave_3_mnum = 2'b00;

	case (slave_3_rr_state)

		2'b00:
			begin
			if (m0_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_0_data;
				slave_3_mnum = 2'b00;
				end
			else if (m1_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_1_data;
				slave_3_mnum = 2'b01;
				end
			else if (m2_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_2_data;
				slave_3_mnum = 2'b10;
				end
			else if (m3_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_3_data;
				slave_3_mnum = 2'b11;
				end
			end

		2'b01:
			begin
			if (m1_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_1_data;
				slave_3_mnum = 2'b01;
				end
			else if (m2_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_2_data;
				slave_3_mnum = 2'b10;
				end
			else if (m3_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_3_data;
				slave_3_mnum = 2'b11;
				end
			else if (m0_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_0_data;
				slave_3_mnum = 2'b00;
				end
			end

		2'b10:
			begin
			if (m2_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_2_data;
				slave_3_mnum = 2'b10;
				end
			else if (m3_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_3_data;
				slave_3_mnum = 2'b11;
				end
			else if (m0_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_0_data;
				slave_3_mnum = 2'b00;
				end
			else if (m1_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_1_data;
				slave_3_mnum = 2'b01;
				end
			end

		2'b11:
			begin
			if (m3_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_3_data;
				slave_3_mnum = 2'b11;
				end
			else if (m0_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_0_data;
				slave_3_mnum = 2'b00;
				end
			else if (m1_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_1_data;
				slave_3_mnum = 2'b01;
				end
			else if (m2_s3_req)
				begin
				slave_3_req = 1'b1;
				slave_3_data = master_2_data;
				slave_3_mnum = 2'b10;
				end
			end

	endcase
	end

// master ack switch
always @*
	begin
	master_0_ack = 1'b0;
	if ((m0_s0_req == 1'b1) && (slave_0_mnum == 2'b00)) master_0_ack = slave_0_ack;
	if ((m0_s1_req == 1'b1) && (slave_1_mnum == 2'b00)) master_0_ack = slave_1_ack;
	if ((m0_s2_req == 1'b1) && (slave_2_mnum == 2'b00)) master_0_ack = slave_2_ack;
	if ((m0_s3_req == 1'b1) && (slave_3_mnum == 2'b00)) master_0_ack = slave_3_ack;
	end

always @*
	begin
	master_1_ack = 1'b0;
	if ((m1_s0_req == 1'b1) && (slave_0_mnum == 2'b01)) master_1_ack = slave_0_ack;
	if ((m1_s1_req == 1'b1) && (slave_1_mnum == 2'b01)) master_1_ack = slave_1_ack;
	if ((m1_s2_req == 1'b1) && (slave_2_mnum == 2'b01)) master_1_ack = slave_2_ack;
	if ((m1_s3_req == 1'b1) && (slave_3_mnum == 2'b01)) master_1_ack = slave_3_ack;
	end

always @*
	begin
	master_2_ack = 1'b0;
	if ((m2_s0_req == 1'b1) && (slave_0_mnum == 2'b10)) master_2_ack = slave_0_ack;
	if ((m2_s1_req == 1'b1) && (slave_1_mnum == 2'b10)) master_2_ack = slave_1_ack;
	if ((m2_s2_req == 1'b1) && (slave_2_mnum == 2'b10)) master_2_ack = slave_2_ack;
	if ((m2_s3_req == 1'b1) && (slave_3_mnum == 2'b10)) master_2_ack = slave_3_ack;
	end

always @*
	begin
	master_3_ack = 1'b0;
	if ((m3_s0_req == 1'b1) && (slave_0_mnum == 2'b11)) master_3_ack = slave_0_ack;
	if ((m3_s1_req == 1'b1) && (slave_1_mnum == 2'b11)) master_3_ack = slave_1_ack;
	if ((m3_s2_req == 1'b1) && (slave_2_mnum == 2'b11)) master_3_ack = slave_2_ack;
	if ((m3_s3_req == 1'b1) && (slave_3_mnum == 2'b11)) master_3_ack = slave_3_ack;
	end

endmodule
