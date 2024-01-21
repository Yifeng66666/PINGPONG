module CLK_GEN(

input areset,
input inclk0,
output wire c0,
output reg c1
);


assign c0 = inclk0;

/*
reg cnt;:wq

always@(posedge inclk0 or negedge areset)begin
    if(~areset)begin
        cnt <= 1'b0;
        c1 <= 1'b0;
    end
    else begin
        cnt <= cnt == 1'b1 ? 1'b0 : cnt+ 1'b1;
        c1 <= (cnt == 1'b1 || cnt == 1'b0) ? ~c1 : c1;
    end
end
*/

always@(posedge inclk0 or negedge areset)begin
    if(~areset)begin
        c1 <= 1'b0;
    end
    else begin
        c1 <= ~c1;
    end
end

endmodule

