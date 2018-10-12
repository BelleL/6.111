`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 03:37:59 PM
// Design Name: 
// Module Name: tb_divider
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


module tb_divider;
    // Inputs
    reg clock;
    reg start;

    // Outputs
    wire clock2;
    
    // Instantiate the Unit Under Test (UUT)
    divider uut (
        .master_clk(clock),
        .start_timer(start),
        .one_hz_enable(clock2)
    );
    
    initial begin   // system clock
        forever #5 clock = !clock;
    end
    initial begin
        // Initialize Inputs
        clock = 0;
        start = 0;
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        start= 1;
        #10 start = 0;
        #5;    
        
        #300
        start= 1;
        #10 start = 0;
        #5;    
       //   $stop; // Pause simulation   
    end


endmodule
