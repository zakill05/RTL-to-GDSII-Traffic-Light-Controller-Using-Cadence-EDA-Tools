`timescale 1ns/1ps
module fsm(
    input clk,
    input rst,
    output reg [2:0] LED_1,
    output reg [2:0] LED_2,
    output reg [8:0] time1,
    output reg [8:0] time2
);

parameter GREEN  = 8'd40;
parameter YELLOW = 8'd5;

reg [1:0] state;
reg [8:0] timer;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

// LED[2]=RED  LED[1]=YELLOW  LED[0]=GREEN
// LED_1: duong ngang | LED_2: duong doc

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= S0;
        timer <= 0;
    end
    else
    begin
        case(state)
        S0: if(timer < GREEN - 1)
                timer <= timer + 1;
            else
            begin
                state <= S1;
                timer <= 0;
            end
        S1: if(timer < YELLOW - 1)
                timer <= timer + 1;
            else
            begin
                state <= S2;
                timer <= 0;
            end
        S2: if(timer < GREEN - 1)
                timer <= timer + 1;
            else
            begin
                state <= S3;
                timer <= 0;
            end
        S3: if(timer < YELLOW - 1)
                timer <= timer + 1;
            else
            begin
                state <= S0;
                timer <= 0;
            end
        endcase
    end
end

// Output logic
always @*
begin
    case(state)
    S0: begin
        LED_1 = 3'b001;          
        LED_2 = 3'b100;           
        time1 = GREEN - timer;        
        time2 = GREEN + YELLOW - timer; 
    end
    S1: begin
        LED_1 = 3'b010;           
        LED_2 = 3'b100;           
        time1 = YELLOW - timer;        
        time2 = YELLOW - timer;       
    end
    S2: begin
        LED_1 = 3'b100;          
        LED_2 = 3'b001;          
        time1 = GREEN + YELLOW - timer; 
        time2 = GREEN - timer;        
    end
    S3: begin
        LED_1 = 3'b100;           
        LED_2 = 3'b010;          
        time1 = YELLOW - timer;        
        time2 = YELLOW - timer;       
    end
    default: begin
        LED_1 = 3'b100;
        LED_2 = 3'b100;
        time1 = 0;
        time2 = 0;
    end
    endcase
end

endmodule
