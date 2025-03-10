`timescale 1ns / 1ps

module tb;

    reg clk, reset, trigger;
    reg [4:0] length;  // Total bytes to transfer
    reg [31:0] source_address, destination_address;
    wire done;

    // AXI4-Lite signals
    wire ARREADY, ARVALID;
    wire [31:0] ARADDR;
    wire RVALID, RREADY;
    wire [31:0] RDATA;
    wire AWREADY, AWVALID;
    wire [31:0] AWADDR;
    wire WREADY, WVALID;
    wire [31:0] WDATA;
    wire BVALID, BREADY;

    // Instantiate DMA Master
    dma_master uut (.clk(clk), .reset(reset), .trigger(trigger),
        .length(length), .source_address(source_address), .destination_address(destination_address),.done(done),
        .ARREADY(ARREADY), .ARVALID(ARVALID), .ARADDR(ARADDR),
        .RVALID(RVALID), .RREADY(RREADY), .RDATA(RDATA),
        .AWREADY(AWREADY), .AWVALID(AWVALID), .AWADDR(AWADDR),
        .WREADY(WREADY), .WVALID(WVALID), .WDATA(WDATA),
        .BVALID(BVALID), .BREADY(BREADY) );

    // Instantiate AXI4-Lite Synchronous Slave Memory
    axi_slave_memory  slave_mem(.clk(clk), .reset(reset),
        .ARADDR(ARADDR), .ARVALID(ARVALID), .ARREADY(ARREADY),
        .RDATA(RDATA), .RVALID(RVALID), .RREADY(RREADY),
        .AWADDR(AWADDR), .AWVALID(AWVALID), .AWREADY(AWREADY),
        .WDATA(WDATA), .WVALID(WVALID), .WREADY(WREADY),
        .BVALID(BVALID), .BREADY(BREADY) );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        trigger = 0;
        length = 16; // 16 bytes -> 4 words
        source_address = 32'h00000010;
        destination_address = 32'h00000050;

        #20 reset = 0; // Release reset
        #10 trigger = 1;
        #10 trigger = 0;
        #500;

    end

endmodule
