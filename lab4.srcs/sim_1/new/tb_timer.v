`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 02:56:16 PM
// Design Name: 
// Module Name: tb_timer
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


module tb_timer;
    // Inputs
	reg clock;
	reg clock2;
	reg start;
	reg [3:0] value;

	// Outputs
	wire done;
	wire [3:0] countdown;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.value(value), 
		.clk(clock),
		.one_hz_enable(clock2),
        .start_timer(start),
        .expired(done),
        .count(countdown)
	);
	
	initial begin   // system clock
        forever #5 clock = !clock;
    end
    initial begin   // system clock
            forever #10 clock2 = !clock2;
        end
    initial begin
        // Initialize Inputs
        clock = 0;
        clock2 = 0;
        start = 0;
        value = 0;
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        start= 1;
        value = 15;
        #10 start = 0;
        #10 value = 0;
        #5;    
        
        #300
        start= 1;
        value = 5;
        #10 start = 0;
        #10 value = 0;
        #5;    
       //   $stop; // Pause simulation   
    end

endmodule
