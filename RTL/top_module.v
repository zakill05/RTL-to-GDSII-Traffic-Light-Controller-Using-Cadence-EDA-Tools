`timescale 1ns/1ps
module top_module (
    input        clk_50mhz,
    input        rst,
    output [2:0] LED_1,
    output [2:0] LED_2,
    output [6:0] seg1_ch,
    output [6:0] seg1_dv,
    output [6:0] seg2_ch,
    output [6:0] seg2_dv
);

wire clk_1hz;
wire [8:0] time1, time2;

clk_1hz u_clk (
    .clk_50mhz (clk_50mhz),
    .rst       (rst),
    .clk_1hz   (clk_1hz)
);

fsm u_fsm (
    .clk   (clk_1hz),
    .rst   (rst),
    .LED_1 (LED_1),
    .LED_2 (LED_2),
    .time1 (time1),
    .time2 (time2)
);
display_2digit_cross u_disp (
    .in_A     (time1[7:0]),
    .in_B     (time2[7:0]),
    .seg_ch_A (seg1_ch),
    .seg_dv_A (seg1_dv),
    .seg_ch_B (seg2_ch),
    .seg_dv_B (seg2_dv)
);
endmodule