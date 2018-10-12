`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2018 11:52:48 PM
// Design Name: 
// Module Name: status_light
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


module status_light(
    input [1:0] status,
    input one_hz_enable,clk,
    output status_out   
    );
    
    reg out;
    reg flag;
    assign status_out = out;
    always @(posedge clk) begin
        if (one_hz_enable) begin
             case(status)
               2'b00: 
                    out <= 0; // off
               2'b10:
                    out <= 1; // on
               2'b01: begin
                    //blink
                    case(flag)
                        1'b0: flag <= 1;
                        1'b1: flag <= 0;
                    endcase
                    out <= flag;
                end
             endcase
        end    
    end
endmodule
