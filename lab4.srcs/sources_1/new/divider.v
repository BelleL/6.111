`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 01:16:34 PM
// Design Name: 
// Module Name: divider
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


module divider(
    input master_clk, start_timer,
    output one_hz_enable
    );
    reg [24:0] counter = 0;
    reg enable;
    assign one_hz_enable = enable;
    //need 25 bit counter for 25 million
    always @(posedge master_clk) begin 
        if (start_timer) begin
            counter <= 0;
            enable <= 0;
        end else if (counter < 25000000 )begin
            counter <= counter +1;
            enable <= 0;           
        end else if (counter == 25000000) begin
            counter <= 0;
            enable <= 1;            
        end 
        
    end
endmodule
