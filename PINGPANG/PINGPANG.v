module PINGPANG
(
	input 	wire 			clk		,
	input 	wire 			rst		,
	
	output	wire [15:0]     data_out
);
 
wire 				clk_25m			;
wire 				clk_50m			;
 
wire 	[15:0] 	    ram1_data		;
wire 	[15:0] 	    ram2_data		;
wire 				data_en			;
wire 	[7:0]		data_in			;
	
wire 				ram1_wr_en		;
wire 	[6:0]  	    ram1_wr_addr	;
wire 	[7:0]  	    ram1_wr_data	;
wire 				ram1_rd_en		;
wire 	[5:0]  	    ram1_rd_addr	;
	
wire 				ram2_wr_en		;
wire 	[6:0]  	    ram2_wr_addr	;
wire 	[7:0]  	    ram2_wr_data	;
wire 				ram2_rd_en		;
wire 	[5:0]  	    ram2_rd_addr	;
	
wire 	[7:0]  	    data_in_reg		;


CLK_GEN clk_gen_inst(
    .inclk0(clk),
    .areset(rst),
    .c0(clk_50m),
    .c1(clk_25m)
);

DATA_GEN data_gen_inst
(
	.clk		(clk_50m		),	//50MHZ	
	.rst		(rst	    ),
		
	.data_en	(data_en		),
	.data		(data_in		)		
);
RAM_CTRL ram_ctrl_inst
(
	.clk_25m		(clk_25m		),
	.clk_50m		(clk_50m		),
	.rst			(rst			),
	.ram1_data		(ram1_data		),
	.ram2_data		(ram2_data		),
	.data_en	    (data_en		),
	.data_in		(data_in		),
		
	.ram1_wr_en		(ram1_wr_en		),
	.ram1_wr_addr	(ram1_wr_addr	),
	.ram1_wr_data	(ram1_wr_data	),
	.ram1_rd_en		(ram1_rd_en		),
	.ram1_rd_addr	(ram1_rd_addr	),
		
	.ram2_wr_en		(ram2_wr_en		),
	.ram2_wr_addr	(ram2_wr_addr	),
	.ram2_wr_data	(ram2_wr_data	),
	.ram2_rd_en		(ram2_rd_en		),
	.ram2_rd_addr	(ram2_rd_addr	),
		
	.data_in_reg	(data_in_reg	),
		
	.data_out		(data_out		)
);
RAM ram1_inst
(
	.data			(ram1_wr_data	),
	.rdaddress	    (ram1_rd_addr	),
	.rdclock		(clk_25m		),
	.rden			(ram1_rd_en		),
	.wraddress	    (ram1_wr_addr	),
	.wrclock		(clk_50m		),
	.wren			(ram1_wr_en		),
	.q				(ram1_data		)
);
RAM ram2_inst
(
	.data			(ram2_wr_data	),
	.rdaddress	    (ram2_rd_addr	),
	.rdclock		(clk_25m		),
	.rden			(ram2_rd_en		),
	.wraddress	    (ram2_wr_addr	),
	.wrclock		(clk_50m		),
	.wren			(ram2_wr_en		),
	.q				(ram2_data		)
);
 
endmodule
