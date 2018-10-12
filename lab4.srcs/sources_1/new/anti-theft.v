`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/10/2018 01:16:34 PM
// Design Name:
// Module Name: anti-theft
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


module anti_theft (input clk, ig_switch, dr_door, pr_door, reprogram, expired, sys_reset,
    output [1:0] interval, output siren, start_timer, output [1:0] status, output [7:0] state_output);
    //output port reg
    reg [1:0] interval_reg;
    reg siren_reg, start_timer_reg;
    reg [1:0] status_reg;
    assign interval = interval_reg;
    assign siren = siren_reg; // siren on = 1
    assign start_timer = start_timer_reg;
    assign status = status_reg; //on = 2, blink = 1, off = 0
    //switch on = 1, off = 0
    //door open = 1, door close = 0
    
    //states
    parameter param_num = 8;
    parameter ARMED = 0;
    parameter COUNT_TRIGGER = 1;
    parameter ALARM    = 2;
    parameter COUNT_ALARM = 3;
    parameter DISARMED = 4;
    parameter POST_DIS = 5;
    parameter DOOR_OPEN = 6;
    parameter COUNT_ARM = 7;
    parameter START_TIMER_TRIGGER = 8;
    parameter START_TIMER_ALARM= 9;
    parameter START_TIMER_ARM = 10;
    
    //timer stuff
    reg start_timer_reg = 0;
    assign start_timer = start_timer_reg;
    parameter ARM_DELAY = 2'b00;
    parameter DRIVER_DELAY = 2'b01;
    parameter PASSENGER_DELAY = 2'b10;
    parameter ALARM_ON = 2'b11;

    
    reg [param_num-1 : 0] state;
    reg [param_num-1 : 0] state;
    assign state_output = state; // debugging
    
    
    //logic for changing states
    //because all inputs are synchronized to clock, use posedge clock
    // QUESITONS : have to do state<= ? instaed of state <=? because nonblocking? will confuse state case statement?

    always @(posedge clk) begin
        case (state)
            ARMED : begin
                    siren_reg <= 0;   
                    status_reg <= 1;
                   //logic for changing states
                    if (pr_door || dr_door) begin
                        state <= START_TIMER_TRIGGER;//Logic for which interval dr_door vs pr_door // fix this!!
                            if (dr_door) begin
                               interval_reg <= DRIVER_DELAY;
                           end else if (pr_door) begin
                               interval_reg <= PASSENGER_DELAY;
                           end
                    end else if (ig_switch) begin
                        state <= DISARMED;
                    end    
                end    
            // make new state to force start_timer                    
            START_TIMER_TRIGGER : begin
                start_timer_reg <= 1;
                state <= COUNT_TRIGGER;
            end
           
            COUNT_TRIGGER :begin                
               // status light on, siren off
                status_reg <= 2;
                siren_reg <= 0;
                start_timer_reg <= 0;
                //logic for changing states
                if (ig_switch) begin
                    state <= DISARMED;
                end else if (expired) begin 
                    state <= ALARM;
                end
            end
            ALARM : begin
                status_reg <= 2;
                siren_reg <= 1;
                
                //logic for changing states
                if (ig_switch) begin
                    state <= DISARMED;
                end else if(!dr_door) begin
                    state <= START_TIMER_ALARM;
                    interval_reg <= ALARM_ON;
                end
            end
            START_TIMER_ALARM : begin
               start_timer_reg <= 1;
               state <= COUNT_ALARM;
           end
            COUNT_ALARM :begin
            
               start_timer_reg <= 0;
               siren_reg <=  1;
               status_reg <= 2;
                //logic for changing states
                if (expired) begin // fix this
                    state <= ARMED;
                end
            end
            DISARMED :begin
                status_reg <= 0;
                siren_reg <= 0;
                if (!ig_switch) begin
                    state <= POST_DIS;
                end
            end
            POST_DIS :
                //logic for changing states
                if (dr_door || pr_door) begin
                    state <= DOOR_OPEN;
                end
            DOOR_OPEN:
                //logic for changing states
                if (~dr_door || ~pr_door) begin
                    state <= START_TIMER_ARM;
                end 
            START_TIMER_ARM : begin
                 start_timer_reg <= 1;
                 state <= COUNT_ARM;

            end
            COUNT_ARM : begin
                interval_reg <= ARM_DELAY;
                start_timer_reg <= 0; 
                //logic for changing states
                if (dr_door ||  pr_door) begin 
                    state <= DOOR_OPEN;
                end else if (expired) begin
                    state <= ARMED;
                end
            end
             default : begin
                state <= ARMED;
             start_timer_reg <= 0;
             end
        endcase
        //transition to next state
        if (reprogram || sys_reset) begin // question : power on??
            state <= ARMED;            
        end 
        if (ig_switch) begin
            state <= DISARMED;
        end
        

        
    end

endmodule
