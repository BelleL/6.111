`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 01:16:34 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer (input reset, clk, switch_noisy, //a switch
	output switch);
	//debounce all the switches
	wire mid;
	debounce deb (.reset(switch_noisy), .clock(clk), .noisy(switch_noisy), .clean(mid));
	//feed debounce output into sync input
	synchronize sync (.clk(clk), .in(mid), .out(switch));
endmodule 