`timescale 1ns/1ps
module tb_clk_1hz;

reg  clk_50mhz;
reg  rst;
wire clk_1hz;

// MAX=25000000 nhu that
clk_1hz u_clk (
    .clk_50mhz (clk_50mhz),
    .rst       (rst),
    .clk_1hz   (clk_1hz)
);

// Clock 50MHz
initial clk_50mhz = 0;
always #10 clk_50mhz = ~clk_50mhz;

// Reset and run
initial begin
    rst = 1;
    #100;
    rst = 0;
    #2_000_000_000; // 2 giay -> thay 2 toggle
    $finish;
end

// Monitor
initial
    $monitor("t=%0t | clk_1hz=%b", $time, clk_1hz);

// Dump waveform
initial begin
    $dumpfile("tb_clk_1hz.vcd");
    $dumpvars(0, tb_clk_1hz);
end

endmodule
