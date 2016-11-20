module pavana_xbar_wrapper_4buf
(
	input clk_i, rst_i,

	input shiftdata_i,

	input rdcfg_i, 
	output shiftdata_o
);

wire master_0_req;
wire [31:0] master_0_addr;
wire master_0_cmd;
wire [31:0] master_0_wdata;
wire master_0_ack;
wire [31:0] master_0_rdata;
wire master_0_resp;

wire master_1_req;
wire [31:0] master_1_addr;
wire master_1_cmd;
wire [31:0] master_1_wdata;
wire master_1_ack;
wire [31:0] master_1_rdata;
wire master_1_resp;

wire master_2_req;
wire [31:0] master_2_addr;
wire master_2_cmd;
wire [31:0] master_2_wdata;
wire master_2_ack;
wire [31:0] master_2_rdata;
wire master_2_resp;

wire master_3_req;
wire [31:0] master_3_addr;
wire master_3_cmd;
wire [31:0] master_3_wdata;
wire master_3_ack;
wire [31:0] master_3_rdata;
wire master_3_resp;

wire slave_0_req;
wire [31:0] slave_0_addr;
wire slave_0_cmd;
wire [1:0] slave_0_reqtid;
wire [31:0] slave_0_wdata;
wire slave_0_ack;
wire [1:0] slave_0_resptid;
wire [31:0] slave_0_rdata;
wire slave_0_resp;

wire slave_1_req;
wire [31:0] slave_1_addr;
wire slave_1_cmd;
wire [1:0] slave_1_reqtid;
wire [31:0] slave_1_wdata;
wire slave_1_ack;
wire [1:0] slave_1_resptid;
wire [31:0] slave_1_rdata;
wire slave_1_resp;

wire slave_2_req;
wire [31:0] slave_2_addr;
wire slave_2_cmd;
wire [1:0] slave_2_reqtid;
wire [31:0] slave_2_wdata;
wire slave_2_ack;
wire [1:0] slave_2_resptid;
wire [31:0] slave_2_rdata;
wire slave_2_resp;

wire slave_3_req;
wire [31:0] slave_3_addr;
wire slave_3_cmd;
wire [1:0] slave_3_reqtid;
wire [31:0] slave_3_wdata;
wire slave_3_ack;
wire [1:0] slave_3_resptid;
wire [31:0] slave_3_rdata;
wire slave_3_resp;

reg [415:0] shiftdatareg_in;
always @(posedge clk_i)shiftdatareg_in <= {shiftdatareg_in[414:0], shiftdata_i};

assign master_0_addr 	= shiftdatareg_in[31:0];
assign master_0_wdata 	= shiftdatareg_in[63:0];
assign master_1_addr 	= shiftdatareg_in[95:64];
assign master_1_wdata 	= shiftdatareg_in[127:96];
assign master_2_addr 	= shiftdatareg_in[159:128];
assign master_2_wdata 	= shiftdatareg_in[191:160];
assign master_3_addr 	= shiftdatareg_in[223:192];
assign master_3_wdata 	= shiftdatareg_in[255:224];
assign slave_0_rdata 	= shiftdatareg_in[287:256];
assign slave_1_rdata 	= shiftdatareg_in[319:288];
assign slave_2_rdata 	= shiftdatareg_in[351:320];
assign slave_3_rdata 	= shiftdatareg_in[383:352];
assign master_0_req 	= shiftdatareg_in[384];
assign master_0_cmd 	= shiftdatareg_in[385];
assign master_1_req 	= shiftdatareg_in[386];
assign master_1_cmd 	= shiftdatareg_in[387];
assign master_2_req 	= shiftdatareg_in[388];
assign master_2_cmd 	= shiftdatareg_in[389];
assign master_3_req 	= shiftdatareg_in[390];
assign master_3_cmd 	= shiftdatareg_in[391];
assign slave_0_ack 		= shiftdatareg_in[392];
assign slave_1_ack 		= shiftdatareg_in[393];
assign slave_2_ack 		= shiftdatareg_in[394];
assign slave_3_ack 		= shiftdatareg_in[395];
assign slave_0_resp 	= shiftdatareg_in[396];
assign slave_1_resp		= shiftdatareg_in[397];
assign slave_2_resp		= shiftdatareg_in[398];
assign slave_3_resp		= shiftdatareg_in[399];
assign slave_0_reqtid 	= shiftdatareg_in[401:400];
assign slave_0_resptid 	= shiftdatareg_in[403:402];
assign slave_1_reqtid 	= shiftdatareg_in[405:404];
assign slave_1_resptid 	= shiftdatareg_in[407:406];
assign slave_2_reqtid 	= shiftdatareg_in[409:408];
assign slave_2_resptid 	= shiftdatareg_in[411:410];
assign slave_3_reqtid 	= shiftdatareg_in[413:412];
assign slave_3_resptid 	= shiftdatareg_in[415:414];

reg [399:0] shiftdatareg_out;
wire [399:0] shiftdatareg_sample;
assign shiftdata_o = shiftdatareg_out[0];
always @(posedge clk_i)
	begin
	if (rdcfg_i) shiftdatareg_out <= shiftdatareg_sample;
	else shiftdatareg_out <= {1'b0, shiftdatareg_out[399:1]};
	end

assign shiftdatareg_sample = {	master_0_ack,
								master_0_rdata,
								master_0_resp,
								master_1_ack,
								master_1_rdata,
								master_1_resp,
								master_2_ack,
								master_2_rdata,
								master_2_resp,
								master_3_ack,
								master_3_rdata,
								master_3_resp,
								slave_0_req,
								slave_0_addr,
								slave_0_cmd,
								slave_0_wdata,
								slave_1_req,
								slave_1_addr,
								slave_1_cmd,
								slave_1_wdata,
								slave_2_req,
								slave_2_addr,
								slave_2_cmd,
								slave_2_wdata,
								slave_3_req,
								slave_3_addr,
								slave_3_cmd,
								slave_3_wdata
							};

pavana_xbar_ooo_4buf pavana_xbar_ooo (
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
	.slave_0_reqtid(slave_0_reqtid),
	.slave_0_wdata(slave_0_wdata),
	.slave_0_ack(slave_0_ack),
	.slave_0_resptid(slave_0_resptid),
	.slave_0_rdata(slave_0_rdata),
	.slave_0_resp(slave_0_resp),

	.slave_1_req(slave_1_req),
	.slave_1_addr(slave_1_addr),
	.slave_1_cmd(slave_1_cmd),
	.slave_1_reqtid(slave_1_reqtid),
	.slave_1_wdata(slave_1_wdata),
	.slave_1_ack(slave_1_ack),
	.slave_1_resptid(slave_1_resptid),
	.slave_1_rdata(slave_1_rdata),
	.slave_1_resp(slave_1_resp),

	.slave_2_req(slave_2_req),
	.slave_2_addr(slave_2_addr),
	.slave_2_cmd(slave_2_cmd),
	.slave_2_reqtid(slave_2_reqtid),
	.slave_2_wdata(slave_2_wdata),
	.slave_2_ack(slave_2_ack),
	.slave_2_resptid(slave_2_resptid),
	.slave_2_rdata(slave_2_rdata),
	.slave_2_resp(slave_2_resp),

	.slave_3_req(slave_3_req),
	.slave_3_addr(slave_3_addr),
	.slave_3_cmd(slave_3_cmd),
	.slave_3_reqtid(slave_3_reqtid),
	.slave_3_wdata(slave_3_wdata),
	.slave_3_ack(slave_3_ack),
	.slave_3_resptid(slave_3_resptid),
	.slave_3_rdata(slave_3_rdata),
	.slave_3_resp(slave_3_resp)
);

endmodule
