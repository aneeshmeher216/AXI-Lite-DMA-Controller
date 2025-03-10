`timescale 1ns / 1ps

module sync_fifo(
    input clk, rst, 
    input [31:0] d_in,
    output reg [31:0] d_out,
    input RD_EN, WR_EN,
    output FULL, EMPTY
);
    
reg [31:0] fifo_mem[15:0] ;
reg [3:0] WR_PTR, RD_PTR;
integer i;

assign FULL = ((WR_PTR + 1'b1) == RD_PTR) ;
assign EMPTY = (WR_PTR == RD_PTR) ;

//Writing data in FIFO
always @(posedge clk ) begin
    if (rst) begin
        WR_PTR <= 4'b0;
    end 
    else if (WR_EN && !FULL) begin
        fifo_mem[WR_PTR] <= d_in;
        WR_PTR <= WR_PTR + 1;
    end
end

//Reading data from FIFO
always @(posedge clk) begin
    if (rst) begin
        RD_PTR <= 4'b0;
//            d_out  <= 32'b0;
    end 
    else if (RD_EN && !EMPTY) begin
        d_out <= fifo_mem[RD_PTR];
//        fifo_mem[RD_PTR] <= 32'd0;
        RD_PTR <= RD_PTR + 1;
    end
end

endmodule
