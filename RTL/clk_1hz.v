`timescale 1ns/1ps
module clk_1hz (
    input  clk_50mhz, 
    input  rst,
    output reg clk_1hz
);

// SIMULATION: MAX=5 de chay nhanh
// SYNTHESIS:  MAX=5_000_000 (50MHz / 2*MAX = 1Hz)
parameter MAX = 25000000;


reg [25:0] cnt;

always @(posedge clk_50mhz or posedge rst)
begin
    if (rst) begin
        cnt     <= 0;
        clk_1hz <= 0;
    end
    else begin
        if (cnt == MAX - 1) begin
            cnt     <= 0;
            clk_1hz <= ~clk_1hz;
        end
        else
            cnt <= cnt + 1;
    end
end

endmodule