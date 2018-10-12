`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 01:16:34 PM
// Design Name: 
// Module Name: time_parameters
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


module time_parameters(
    input clk,
    input reprogram,
    input [3:0] time_value,
    input [1:0] time_param,
    input [1:0] interval,
    output [3:0] value_out
    );
    //power on default
    reg [3:0] t_arm_delay = 4'd6;
    reg [3:0] t_driver_delay = 4'd8;
    reg [3:0] t_passenger_delay = 4'd15;
    reg [3:0] t_alarm_on = 4'd10; 
    parameter ARM_DELAY = 2'b00;
    parameter DRIVER_DELAY = 2'b01;
    parameter PASSENGER_DELAY = 2'b10;
    parameter ALARM_ON = 2'b11;
    //selecting value to output to timer module
     reg [3:0] mux;
     assign value_out = mux;
    //reprogram
    always @(posedge clk or posedge reprogram) begin 
        if(reprogram) begin
            case (interval)
                ARM_DELAY : t_arm_delay <= time_value;// T_ARM_DELAY
                DRIVER_DELAY : t_driver_delay <= time_value;//T_DRIVER_DELAY
                PASSENGER_DELAY :  t_passenger_delay <= time_value;// T_PASSENGER_DELAY
                ALARM_ON : t_alarm_on <= time_value;//T_ALARM_ON
            endcase
        end
        case(interval)
                ARM_DELAY : mux <= t_arm_delay;// T_ARM_DELAY
                DRIVER_DELAY : mux <= t_driver_delay;//T_DRIVER_DELAY
                PASSENGER_DELAY : mux <= t_passenger_delay;// T_PASSENGER_DELAY
                ALARM_ON : mux <= t_alarm_on;//T_ALARM_ON
        endcase
    end

    
        
endmodule
