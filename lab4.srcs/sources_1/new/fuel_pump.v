`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 01:16:34 PM
// Design Name: 
// Module Name: fuel_pump
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


module fuel_pump(
    input brake, clk,
    input hidden,
    input ig_switch,// off is 0
    output power // off is 0
    );
    reg [1:0] state = 0;
    reg [1:0] state;
    reg power_reg;
    parameter OFF = 2'b00;
    parameter WAIT = 2'b01;
    parameter ON = 2'b10;
    assign power = power_reg;
    always @(posedge clk) begin
        case(state) 
            OFF:begin
                if(ig_switch) state <= WAIT;
                power_reg <= 0;
            end
            WAIT: begin
                if(hidden & brake) state <= ON;
                if(~ig_switch) state <= OFF;
            end
            ON: begin
                if(~ig_switch) state <= OFF;
                power_reg <= 1;
            end
            default : state <= OFF;        
        endcase
    end
endmodule 
