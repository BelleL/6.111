`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 01:16:34 PM
// Design Name: 
// Module Name: timer
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


module timer(
    input [3:0] value,
    input clk, one_hz_enable,
    input start_timer,//pulse on master clk
    output expired, output [3:0] count 
    );   
    reg [3:0] counter = 0;
    reg expired_reg;
    assign count = counter;
    assign expired = expired_reg;
    // do all the logic on the 25mHz clock

    always @(posedge clk) begin

        if (start_timer && (value == 0)) begin
            expired_reg <= 1;
        end  else if(start_timer) begin 
            counter <= value;
            expired_reg <= 0;
        end
        // count down one Hz clock   
        if (one_hz_enable) begin
            if(counter > 0) begin
                counter <= counter -1;
            end else if (counter == 0) begin 
                expired_reg <= 1;
            end
        end else begin
            expired_reg <= 0;
        end
        
    end
     


endmodule
