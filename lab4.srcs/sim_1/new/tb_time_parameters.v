`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 04:50:16 PM
// Design Name: 
// Module Name: tb_time_parameters
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


module tb_time_parameters;
// Inputs
    reg clock;
    reg start;
    reg time_value;
    reg time_param;
    reg [1:0] interval;

    // Outputs
    wire [3:0] value_out;
    
    // Instantiate the Unit Under Test (UUT)
    time_parameters uut (
        .clk(clock),
        .reprogram(start),
        .time_value(time_value),
        .time_param(time_param),
        .interval(interval),
        .value_out(value_out)
    );
    
    initial begin   // system clock
        forever #5 clock = !clock;
    end
    initial begin
        // Initialize Inputs
        clock = 0;
        interval = 0;
        start = 0;
        time_value = 0;
        time_param = 0;
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        //give all four different modes and see if default value
        interval = 0;
        #20  interval = 0;
        #80;
        interval = 1;
        #20 interval = 0;
        #80;    
        interval = 2;
        #20  interval = 0;
        #80;
        interval = 3;
        #20 interval = 0;
        #80;          
        //try to reprogram
        #300
        start= 1;
        #10 start = 0;
        #5;    
       //   $stop; // Pause simulation   
    end
endmodule
