`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 16:43:19
// Design Name: 
// Module Name: heart_multi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module heart_multi(
input clk, 
input [1:0]lives1,lives2,input [9:0] x,y,
output reg [11:0] rgb,
output heart_on
    );
    localparam heart1_x1=512;
    localparam heart1_x2=536;
    localparam heart2_x1=551;   
    localparam heart2_x2=574;
    localparam heart3_x1=586;
    localparam heart3_x2=608;
    localparam heart_y1=30;
    localparam heart_y2=53;
    localparam heart2_1_x1=55;
    localparam heart2_1_x2=79;
    localparam heart2_2_x1=94;   
    localparam heart2_2_x2=118;
    localparam heart2_3_x1=133;
    localparam heart2_3_x2=157;
   
    wire heart1_on, heart2_on,heart3_on;
    wire heart2_1_on, heart2_2_on,heart2_3_on;
    wire cond1,cond2,cond3;
    wire cond2_1,cond2_2,cond2_3;
    assign cond1=(lives1>0);
    assign cond2=(lives1>1);
    assign cond3=(lives1>2);
    assign cond2_1=(lives2>0);
    assign cond2_2=(lives2>1);
    assign cond2_3=(lives2>2);
    assign heart1_on = (x>heart1_x1) && (x<heart1_x2)&& (y>heart_y1) && (y<heart_y2) && cond1;
    assign heart2_on = (x>heart2_x1) && (x<heart2_x2)&& (y>heart_y1) && (y<heart_y2)&& cond2;
    assign heart3_on = (x>heart3_x1) && (x<heart3_x2)&& (y>heart_y1) && (y<heart_y2)&& cond3;
    assign heart2_1_on = (x>heart2_1_x1) && (x<heart2_1_x2)&& (y>heart_y1) && (y<heart_y2) && cond2_1;
    assign heart2_2_on = (x>heart2_2_x1) && (x<heart2_2_x2)&& (y>heart_y1) && (y<heart_y2)&& cond2_2;
    assign heart2_3_on = (x>heart2_3_x1) && (x<heart2_3_x2)&& (y>heart_y1) && (y<heart_y2)&& cond2_3;
    wire [4:0] col1,col2,col3;
    wire [4:0] col2_1,col2_2,col2_3;
    wire [4:0] row1;
    assign col1= x-heart1_x1;
    assign col2= x-heart2_x1;
    assign col3= x-heart3_x1;
    assign row1= y-heart_y1;
    assign col2_1= x-heart2_1_x1;
    assign col2_2= x-heart2_2_x1;
    assign col2_3= x-heart2_3_x1;
    wire[11:0] rgb_h1,rgb_h2,rgb_h3;
    wire[11:0] rgb_2_h1,rgb_2_h2,rgb_2_h3;
   heart_rom h1(.clk(clk),.row(row1),.col(col1),.color_data(rgb_h1));
    heart_rom h2(.clk(clk),.row(row1),.col(col2),.color_data(rgb_h2));
    heart_rom h3(.clk(clk),.row(row1),.col(col3),.color_data(rgb_h3));
     heart_rom h2_1(.clk(clk),.row(row1),.col(col2_1),.color_data(rgb_2_h1));
    heart_rom h2_2(.clk(clk),.row(row1),.col(col2_2),.color_data(rgb_2_h2));
    heart_rom h2_3(.clk(clk),.row(row1),.col(col2_3),.color_data(rgb_2_h3));
    always@(*)begin
       if(heart1_on ) rgb=rgb_h1;
       else if(heart2_on) rgb=rgb_h2;
       else if(heart3_on) rgb=rgb_h3;
       else if(heart2_1_on ) rgb=rgb_2_h1;
       else if(heart2_2_on) rgb=rgb_2_h2;
       else if(heart2_3_on) rgb=rgb_2_h3;
       else rgb=0;
    end
    assign heart_on= heart1_on || heart2_on || heart3_on||heart2_1_on||heart2_2_on||heart2_3_on;
endmodule
