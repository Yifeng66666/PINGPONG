//dual port RAM   
module RAM (
   output reg [15:0] q,                 //output data
   input  [7:0] data,                 //input data
   input  [6:0] wraddress,                //write data address signal
   input  [5:0] rdaddress,               //output data address signal
   input  wren,                   //write data contral signal
   input  rden,                //read data contral signal
   input  wrclock,                  //write data clock
   input  rdclock                  //read data clock
 );
 reg    [7:0] mem [127:0];      
 
   always@(posedge wrclock)
     begin
        if(wren) begin
        mem[wraddress] <= data;
        end
     end
   always@(posedge rdclock)
     begin
        if(rden) begin
        q <= {mem[2*rdaddress+1'b1],mem[2*rdaddress]};
        end   
     end
endmodule
