`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2025 18:19:19
// Design Name: 
// Module Name: top
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


module top(input up1,up2,down1,down2,clk,reset,enter,output [11:0] rgb,output hsync,vsync);
parameter A = 3'd0,B=3'd1,C=3'd2,D=3'd3,E=3'd4;
wire [9:0] x,y;
wire video_on;
wire p_tick;
reg inc;
wire [7:0] score;
wire [3:0] scoreA,scoreB;
assign score = {scoreA,scoreB};
wire [11:0] rgb_single1,rgb_handle,rgb_dig1,rgb_digl,rgb_heart,rgb_over,rgb_continue,rgb_multi1,rgb_heart_multi;
wire [11:0] rgb_start;
reg [11:0] rgb_single,rgb_multi;
wire [1:0] life;
wire over;
wire [1:0] life1,life2;
wire over_multi;
wire won;
wire [1:0] up,down;
assign up = {up1,up2};
assign down = {down1,down2};
assign won = (life1==2'b0);
assign over  = (life == 2'b0);
assign over_multi = (life1==2'b0||life2==2'b0);
vga_controller vga(.clk_100MHz(clk),.x(x),.y(y),.hsync(hsync),.vsync(vsync),.p_tick(p_tick),.video_on(video_on),.reset(reset));
start start1 (.up1(up1),.down1(down1),.enter(enter),.reset(reset),.clk(clk),.p_tick(p_tick),.video_on(video_on),.x(x),.y(y),.rgb_start(rgb_start),.start_on(start_on),.multi(multi),.single(single));
single_fsm s1(.clk(clk),.rst(reset),.up1(up1),.down1(down1),.pixel_x(x),.pixel_y(y),.rgb(rgb_single1),.miss(miss),.hit(hit),.video_on(video_on),.p_tick(p_tick),.single_on(single_on));
life_counter l1(.clk(clk),.miss(miss),.reset(reset),.dig0(life));
score_life_handler s2(.clk(clk),.x(x),.y(y),.score({scoreA}),.video_on(video_on),.rgb(rgb_handle),.sl_on(sl_on));
score_counter s3(.clk(clk),.hit(inc),.reset(reset),.dig0(scoreB),.dig1(scoreA));
dig1 d1(.clk(clk),.x(x),.y(y),.score(scoreB),.rgb(rgb_dig1),.dig1_on(dig1_on));
digl d2(.clk(clk),.x(x),.y(y),.life(life),.rgb(rgb_digl),.digl_on(digl_on));
life_heart h1(.clk(clk),.lives(life),.rgb(rgb_heart),.x(x),.y(y),.heart_on(heart_on));
gameover g1 (.x(x),.y(y),.enter(enter),.clk(clk),.up1(up1),.down1(down1),.video_on(video_on),.p_tick(p_tick),.rgb_over(rgb_over),.restart(restart),.over_on(over_on));
multi m1(.clk(clk),.p_tick(p_tick),.reset(reset),.video(video_on),.up(up),.down(down),.pix_x(x),.pix_y(y),.miss1(miss1),.miss2(miss2),.rgb(rgb_multi1),.graphics(multi_on));
life_counter l2(.clk(clk),.miss(miss1),.reset(reset),.dig0(life1));
life_counter l3(.clk(clk),.miss(miss2),.reset(reset),.dig0(life2));
heart_multi h2(.clk(clk),.lives1(life1),.lives2(life2),.x(x),.y(y),.rgb(rgb_heart_multi),.heart_on(heart_multi_on));
continue c1(.x(x),.y(y),.up1(up1),.down1(down1),.clk(clk),.won(won),.reset(reset),.video_on(video_on),.p_tick(p_tick),.enter(enter),.rgb_continue(rgb_continue),.continue_on(continue_on),.yes(yes),.no(no));
reg [2:0] state , next_state;
initial state = A;
always@(*)
begin
case(state)
A:next_state = single?B:multi?D:A;
B:next_state = over?C:B;
C:next_state = restart?A:C;
D:next_state  =over_multi?E:D;
E:next_state = yes?D:no?A:E;
default:next_state = state;
endcase
end
always@(posedge clk) if(p_tick) state<=next_state;
always@(*)
begin
if(state == B )
begin
if(!video_on) rgb_single = 12'd0;
else if(single_on) rgb_single = rgb_single1;
else if(sl_on) rgb_single  = rgb_handle;
else if(dig1_on) rgb_single  = rgb_dig1;
else if(digl_on) rgb_single  = rgb_digl;
else if(heart_on) rgb_single = rgb_heart;
else rgb_single = 12'd0;
end
else rgb_single = 12'd0;
if(state == D)
begin
if(!video_on) rgb_multi = 12'd0;
else if(multi_on) rgb_multi = rgb_multi1;
else if(heart_multi_on) rgb_multi  = rgb_heart_multi;
else rgb_multi = 12'd0;
end
else rgb_multi = 12'd0;
end
always@(*)
begin
inc  = 1'b0;
if(hit) inc = 1'b1;
end
assign rgb = (state==A)?rgb_start:(state==B)?rgb_single:(state==C)?rgb_over:(state==D)?rgb_multi:(state==E)?rgb_continue:12'd0;
endmodule
