`timescale 1ns / 1ps

module axi_slave_memory (
    input clk, reset,

    // Read Address Channel
    input [31:0] ARADDR,
    input ARVALID,
    output reg ARREADY,

    // Read Data Channel
    output reg [31:0] RDATA,
    output reg RVALID,
    input RREADY,

    // Write Address Channel
    input [31:0] AWADDR,
    input AWVALID,
    output reg AWREADY,

    // Write Data Channel
    input [31:0] WDATA,
    input WVALID,
    output reg WREADY,

    // Write Response Channel
    output reg BVALID,
    input BREADY
);

reg [31:0] mem [0:255];
reg [7:0] read_addr, write_addr;


initial begin
    mem[4] = 32'hAABBCCDD; 
    mem[5] = 32'h11223344;
    mem[6] = 32'h55667788;
    mem[7] = 32'h99AABBCC;
    mem[8] = 32'hA1B2C3D4;
    mem[9] = 32'h5678ABCD;
end   

//READ Slave FSM
reg [1:0] read_state;
parameter R_IDLE = 2'b00, R_DATA = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        ARREADY   <= 0;  
        RVALID    <= 0;
        read_addr <= 0;
        read_state<= R_IDLE;
    end 
    else begin
        if(ARVALID) ARREADY <= 1;
        
        if(ARREADY && ARVALID) begin
            ARREADY <= 0;
            RVALID <= 1;
        end
        
        if(RVALID)    RDATA <= mem[ARADDR[9:2]];

        if(RVALID && RREADY)  RVALID <= 0;    


    end
end

//WRITE Slave FSM
reg [1:0] write_state;
parameter W_IDLE = 2'b00, W_DATA = 2'b01, W_RESP = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        AWREADY    <= 0;
        WREADY     <= 0;
        BVALID     <= 0;
        write_addr <= 0;
    end 
    
    else begin
        if(AWVALID) AWREADY <= 1;
        
        if(AWREADY && AWVALID) begin
            AWREADY <= 0;
            WREADY <= 1;            
        end
        
        if(WVALID && WREADY) begin
            mem[AWADDR[9:2]] <= WDATA;
            WREADY <= 0;
            BVALID <= 1; 
        end
        
        if(BVALID && BREADY) begin
            BVALID <= 0;
        end
    end
end

endmodule
