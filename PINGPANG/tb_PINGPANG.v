`timescale 1ns/1ns
module tb_PINGPANG();


reg clk;
reg rst;
wire data_out;

always #10 clk = ~clk;

initial begin
    rst <= 1'b0;
    clk <= 1'b0;
    #3
    rst <= 1'b1;
    #60_00
    #100
    $finish;
end


initial begin
    $fsdbDumpfile("pingpang.fsdb");
    $fsdbDumpvars(0,tb_PINGPANG);
end


PINGPANG dut(
            .rst(rst),
            .clk(clk),
            .data_out(data_out)
);


endmodule

