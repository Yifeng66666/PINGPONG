module DATA_GEN
(
	input wire          clk		,	//50MHZ
	
	input wire 		    rst		,
	
	output wire         data_en	,
	
	output reg  [7:0]   data		
);
 
 
 
always@(posedge clk or negedge rst)
	if(~rst)
		data <= 8'b0;
	else if(data == 'd199)
		data <= 8'b0;
	else
		data <= data + 1'b1;
		
assign data_en = (rst== 1'b1);
 
endmodule
