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


module reqbuf
#(
	parameter WIDTH = 32
)
(
	input clk_i, input rst_i,

	input 			master_req_i,
	input [66:0]	master_data_bi,
	output			master_ack_o,

	output reg 			slave_req_o,
	output reg [66:0] 	slave_data_bo,
	input 				slave_ack_i
);

wire ready;
assign ready = (slave_req_o == 1'b0) || ( (slave_req_o == 1'b1) && (slave_ack_i == 1'b1) );
assign master_ack_o = master_req_i & ready;

always @(posedge clk_i)
	begin
	if (rst_i)
		begin
		slave_req_o 	<= 1'b0;
		slave_data_bo 	<= 67'h0;
		end
	else
		begin
		if (ready)
			begin
			slave_req_o <= master_req_i;
			slave_data_bo <= master_data_bi;
			end
		end
	end

endmodule
