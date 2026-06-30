`timescale 1ns/1ps
module tb_top_module;

reg clk_50mhz, rst;
wire [2:0] LED_1, LED_2;
wire [6:0] seg1_ch, seg1_dv, seg2_ch, seg2_dv;

// Giữ MAX=25000000 thật
top_module u_top (
    .clk_50mhz (clk_50mhz),
    .rst       (rst),
    .LED_1     (LED_1),
    .LED_2     (LED_2),
    .seg1_ch   (seg1_ch),
    .seg1_dv   (seg1_dv),
    .seg2_ch   (seg2_ch),
    .seg2_dv   (seg2_dv)
);

// Clock 50MHz → #10
initial clk_50mhz = 0;
always #10 clk_50mhz = ~clk_50mhz;


initial begin
    rst = 1;
    #100;
    rst = 0;
    #2_000_000_000; 
end

// Monitor output
initial
    $monitor("t=%0t | LED1=%b LED2=%b | seg1=%b%b | seg2=%b%b",
              $time, LED_1, LED_2, seg1_ch, seg1_dv, seg2_ch, seg2_dv);



endmodule
