`timescale 1ns/1ps

module tb_fsm;

reg clk;
reg rst;
wire [2:0] LED_1;
wire [2:0] LED_2;
wire [8:0] time1;
wire [8:0] time2;

fsm uut (
    .clk(clk),
    .rst(rst),
    .LED_1(LED_1),
    .LED_2(LED_2),
    .time1(time1),
    .time2(time2)
);

initial clk = 0;
always #5 clk = ~clk;

initial
begin
    $dumpfile("tb_fsm.vcd");
    $dumpvars(0, tb_fsm);
    
    rst = 1;
    #20;
    rst = 0;
    #500;
    $finish;
end

endmodule
