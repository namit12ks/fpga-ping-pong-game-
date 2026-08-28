`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2024 23:25:49
// Design Name: 
// Module Name: lfsr_rando_numero
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
module lfsr(
input sel,input reset,input clk,
output[7:0] random_value
);
reg [7:0] lfsr_data =8'b10100010;
reg xor_data;
wire sel_out;
wire reset_out;
debounce d1(.sel_in(sel),.sel_out(sel_out),.clk(clk));
debounce d2(.sel_in(reset),.sel_out(reset_out),.clk(clk));
always@(posedge sel_out,posedge reset_out)
begin
if(reset_out)
lfsr_data<=8'b10101010;
else
lfsr_data<={lfsr_data[6:0],xor_data}; 
end

always@(*)
begin
xor_data = lfsr_data[6] ^lfsr_data[4] ^lfsr_data[2] ^lfsr_data[0];
end
assign random_value = lfsr_data;
endmodule

module debounce(input sel_in,clk,output sel_out);
wire slow_clk;
wire Q1,Q2,Q2_bar,Q0;
clock_div u1(clk,slow_clk);
my_dff d0(slow_clk, pb_1,Q0 );

my_dff d1(slow_clk, Q0,Q1 );
my_dff d2(slow_clk, Q1,Q2 );
assign Q2_bar = ~Q2;
assign pb_out = Q1 & Q2_bar;
endmodule
// Slow clock for debouncing 
module clock_div(input clk, output reg slow_clk

    );
    reg [26:0]counter=0;
    always @(posedge clk)
    begin
        counter <= (counter>=249999)?0:counter+1;
        slow_clk <= (counter < 125000)?1'b0:1'b1;
    end
endmodule
// D-flip-flop for debouncing module 
module my_dff(input clk, D, output reg Q);

    always @ (posedge clk) begin
        Q <= D;
    end

endmodule