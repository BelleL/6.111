`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2018 01:16:34 PM
// Design Name: 
// Module Name: siren
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


module siren( input clk, status,
    output wave 
    );
    // status on is 1
    parameter full = 56820; // time period for 440 hz
    parameter half = 28410; // time period for 880 hz
    parameter slow = 25000000;
    //parameter slow = 2000;
    reg [15:0] count = 0;
    reg [15:0] thresh = full;
    reg [27:0] count2 = 0;
    reg [20:0] change = 0;
    reg wave_reg = 1;
    reg add = 0; // if add = 1 go from 440 to 880 else 880 to 440

    // 2 seconds of each freq
    assign wave = wave_reg;
    
    // count to threshold, reverse audio, reset count
     always @(posedge clk) begin
        if (status) begin
            if (count == thresh) begin
                wave_reg <= ~wave_reg;
                count <= 0;
            end else begin
                count <= count +1;
           end
           /* 
           if (count2 == slow) begin
                case (thresh) 
                    half : begin 
                        thresh <= full;
                    end
                    full : begin
                        thresh <= half;
                    end
                default : thresh <= full;
                endcase
                count2 <= 0;
            end
            */
            // change threshold every couple seconds based on a slow clock 
//            if (count2 == slow) begin
//                case (thresh) 
//                    half : begin 
//                        thresh <= full;
//                        add <= 0;
//                    end
//                    full : begin
//                        thresh <= half;
//                        add <= 1;
//                    end
//                    default : begin
//                        case(add) 
//                                1'b0 : thresh <= thresh - slow/2;
//                                1'b1 : thresh <= thresh + slow/2;
//                        endcase
//                    end
//                endcase
//                count2 <= 0;
//            end
            if(count2 == 3375000) begin
                count2 <= 0;                
                if(thresh <= full && thresh > half) begin
                      thresh <= thresh - full/8;
                end else if (thresh <= half) begin
                      thresh <= full; //thresh + full/8;
                end
            end else begin   
                count2 <= count2 + 1;
            end
            
        end
     end

    

endmodule
