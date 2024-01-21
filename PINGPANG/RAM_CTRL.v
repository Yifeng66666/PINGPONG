module RAM_CTRL
(
	input wire 				clk_25m			,
	input wire 				clk_50m			,
	input wire 				rst				,
	input wire 	[15:0] 	    ram1_data		,
	input wire 	[15:0] 	    ram2_data		,
	input wire 				data_en			,
	input wire 	[7:0]		data_in			,
	
	output wire 			ram1_wr_en		,
	output reg  [6:0]  	    ram1_wr_addr	,
	output wire	[7:0]  	    ram1_wr_data	,
	output wire 			ram1_rd_en		,
	output reg  [5:0]  	    ram1_rd_addr	,
		
	output wire 			ram2_wr_en		,
	output reg  [6:0] 	    ram2_wr_addr	,
	output wire [7:0] 	    ram2_wr_data	,
	output wire 			ram2_rd_en		,
	output reg  [5:0]  	    ram2_rd_addr	,
	
	output reg 	[7:0] 	    data_in_reg		,
	
	output wire [15:0] 	    data_out
);
 
parameter	IDLE 	= 4'b0001,
			WRAM1 = 4'b0010,
			R1_W2 = 4'b0100,
			W1_R2 = 4'b1000;
				
reg [3:0] state,next_state;
 
//data_in_reg:读取数据并打拍
always@(posedge clk_50m or negedge rst)
	if(!rst)
		data_in_reg <= 8'b0;
	else if(data_en == 1'b1)
		data_in_reg <= data_in;
 
//state:现态转移
always@(posedge clk_50m or negedge rst)
	if(!rst)
		state <= IDLE;
	else
		state <= next_state;
		
//next_state:次态改变
always@(*)
	case(state)
		IDLE  : next_state = WRAM1;
		WRAM1 : next_state = (data_in_reg == 'd99 )?R1_W2:WRAM1;
		R1_W2 : next_state = (data_in_reg == 'd199)?W1_R2:R1_W2;
		W1_R2 : next_state = (data_in_reg == 'd99 )?R1_W2:W1_R2;
		default : next_state = IDLE;
	endcase
//ram1、ram2读写使能
assign ram1_wr_en = (state == WRAM1 || state == W1_R2);
assign ram1_rd_en = (next_state == R1_W2 || state == R1_W2);
assign ram2_wr_en = (state == R1_W2);
assign ram2_rd_en = (next_state == W1_R2 || state == W1_R2);
//ram1_wr_addr,ram2_wr_addr:写地址计数
always@(posedge clk_50m or negedge rst)
	if(!rst)
		begin
			ram1_wr_addr <= 7'b0;
			ram2_wr_addr <= 7'b0;
		end
	else if(ram1_wr_addr == 'd99 || ram2_wr_addr == 'd99)
		begin
			ram1_wr_addr <= 7'b0;
			ram2_wr_addr <= 7'b0;
		end
	else
		case(state)
			WRAM1 : ram1_wr_addr <= ram1_wr_addr + 1'b1;
			R1_W2 : ram2_wr_addr <= ram2_wr_addr + 1'b1;
			W1_R2 : ram1_wr_addr <= ram1_wr_addr + 1'b1;	
			default :
				begin
					ram1_wr_addr <= 7'b0;
					ram2_wr_addr <= 7'b0;
				end			
		endcase
//ram1_rd_addr,ram2_rd_addr:读地址计数
always@(posedge clk_25m or negedge rst)
	if(!rst)
		begin
			ram1_rd_addr <= 6'b0;
			ram2_rd_addr <= 6'b0;
		end
	else if(ram1_rd_addr == 'd49 || ram2_rd_addr == 'd49)
		begin
			ram1_rd_addr <= 6'b0;
			ram2_rd_addr <= 6'b0;
		end
	else
		case(state)
			R1_W2 : ram1_rd_addr <= ram1_rd_addr + 1'b1;
			W1_R2 : ram2_rd_addr <= ram2_rd_addr + 1'b1;	
			default :
				begin
					ram1_rd_addr <= 6'b0;
					ram2_rd_addr <= 6'b0;
				end			
		endcase
 
//ram1、ram2输入数据选择		
assign ram1_wr_data = (state == WRAM1 || state == W1_R2) ? data_in_reg:8'b0;
assign ram2_wr_data = (state == R1_W2) ? data_in_reg:8'b0;
 
//ram1、ram2输出数据选择
assign data_out = (state == R1_W2) ? ram1_data:((state == W1_R2) ? ram2_data:16'b0);
 
		
endmodule
