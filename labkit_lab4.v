`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Updated 9/29/2017 V2.0
// Create Date: 10/1/2015 V1.0
// Design Name: 
// Module Name: labkit
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


module labkit(
   input CLK100MHZ,
   input[15:0] SW, 
   input BTNC, BTNU, BTNL, BTNR, BTND,
   output[3:0] VGA_R, 
   output[3:0] VGA_B, 
   output[3:0] VGA_G,
   output[7:0] JA, 
   output VGA_HS, 
   output VGA_VS, 
   output LED16_B, LED16_G, LED16_R,
   output LED17_B, LED17_G, LED17_R,
   output[15:0] LED,
   output[7:0] SEG,  // segments A-G (0-6), DP (7)
   output[7:0] AN    // Display 0-7
   );
   

// create 25mhz system clock
    wire clock_25mhz;
    clock_quarter_divider clockgen(.clk100_mhz(CLK100MHZ), .clock_25mhz(clock_25mhz));

//  instantiate 7-segment display;  
    wire [31:0] data;
    wire [6:0] segments;
    display_8hex display(.clk(clock_25mhz),.data(data), .seg(segments), .strobe(AN));    
    assign SEG[6:0] = segments;
    assign SEG[7] = 1'b1;

//////////////////////////////////////////////////////////////////////////////////
// switches 
    wire ig_switch, dr_door, pr_door, brake, hidden, reprogram; // input
    wire [3:0] time_value; // input
    wire [1:0] time_param;
    wire power, siren, expired, start_timer;
    wire [1:0] status;
    wire [1:0] status_out;
    wire [1:0] interval;
    wire [3:0] value;
    wire one_hz_enable, sys_reset;
    wire [7:0] state;
    
    
    // show output
    assign LED[0] = status_out;     
    assign LED[1] = power;
    assign data[7:0] = state; //lsb 1st and 2nd bits
    
    //timer output for debugging
    wire [3:0] countdown;
    wire expired_test;
    assign data[15:8] = countdown; // 3rd 4th bit
    //assign start_timer = SW[13]; // debugging
    assign LED[14] = ~expired_test;
    assign data[19:16] = interval;

    //finish assigning!!
      
    
    
    //instantiate all modules
    
    //DEBOUNCER + assign switches to inputs
    
    debouncer deb_ig (.reset (SW[7]) ,.clk(clock_25mhz), .switch_noisy(SW[7]) , .switch(ig_switch));
    debouncer deb_dr (.reset (BTNL) ,.clk(clock_25mhz), .switch_noisy(BTNL) , .switch(dr_door));
    debouncer deb_pr (.reset (BTNR) ,.clk(clock_25mhz), .switch_noisy(BTNR) , .switch(pr_door));
    debouncer deb_brake (.reset (BTND) ,.clk(clock_25mhz), .switch_noisy(BTND) , .switch(brake));
    debouncer deb_hidden (.reset (BTNU) ,.clk(clock_25mhz), .switch_noisy(BTNU) , .switch(hidden));
    debouncer deb_reprogram (.reset (BTNC) ,.clk(clock_25mhz), .switch_noisy(BTNC) , .switch(reprogram));
    debouncer deb_time_param (.reset (SW[5:4]) ,.clk(clock_25mhz), .switch_noisy(SW[5:4]) , .switch(time_param));
    debouncer deb_time_value (.reset (SW[3:0]) ,.clk(clock_25mhz), .switch_noisy(SW[3:0]) , .switch(time_value));
    debouncer deb_sys_reset (.reset (SW[15]) ,.clk(clock_25mhz), .switch_noisy(SW[15]) , .switch(sys_reset));
    
    
    //FUEL PUMP
    fuel_pump fp ( .brake(brake), .clk(clock_25mhz), .hidden(hidden),.ig_switch(ig_switch),.power(power));
    
    //ANTI- THEFT FSM
    anti_theft fsm (.clk(clock_25mhz), .ig_switch(ig_switch), .dr_door(dr_door), .pr_door(pr_door), .reprogram(reprogram), 
    .expired(expired), .interval(interval), .siren(siren), .start_timer(start_timer), .status(status), .state_output(state),.sys_reset(sys_reset));
    
    
    //TIME PARAMETERS
    time_parameters time_parameter (
    .clk(clock_25mhz), 
    .reprogram(reprogram), 
    .time_value(time_value),
    .time_param(time_param), 
    .interval(interval),
    .value_out(value));
    
     //DIVIDER
     divider d (.master_clk(clock_25mhz), .one_hz_enable(one_hz_enable),.start_timer(start_timer));      
       
    //TIMER
    timer t (.value(value),.clk(clock_25mhz), .one_hz_enable(one_hz_enable),.start_timer(start_timer),.expired(expired),.count(countdown));   
    //timer t (.value(4'hF),.clk(clock_25mhz), .one_hz_enable(one_hz_enable),.start_timer(start_timer),.expired(expired_test),.count(countdown));   
    
    //status light
    status_light sl(.status(status),.one_hz_enable(one_hz_enable),.clk(clock_25mhz),.status_out(status_out)); //LED[0]
    // SIREN
    siren test (.clk(clock_25mhz) , .status(siren) , .wave (JA[0]));
    
    
   
    //debugging
    
    


    





//  remove these lines and insert your lab here
/*
    //assign LED = SW;     
    assign JA[7:0] = 8'b0;
    
    assign data = {28'h0123456, SW[3:0]};   // display 0123456 + SW
    assign LED16_R = BTNL;                  // left button -> red led
    assign LED16_G = BTNC;                  // center button -> green led
    assign LED16_B = BTNR;                  // right button -> blue led
    assign LED17_R = BTNL;
    assign LED17_G = BTNC;
    assign LED17_B = BTNR; 
    
    //test timer and divider
    reg [3:0] countdown = 1'hF;
    wire one_hz;     
    assign LED[0] = one_hz;
    wire start_timer;
    assign SW[0] = start_timer;
    wire expired;
    assign LED[2] = expired;
    divider test_d (.master_clk(clock_25mhz), .one_hz_enable(one_hz));
    timer test (.value(countdown),.clk(clock_25mhz), .one_hz_enable(one_hz),.start_timer(start_timer), .expired(expired)); 
    assign data = countdown;

*/
//
//////////////////////////////////////////////////////////////////////////////////




 
//////////////////////////////////////////////////////////////////////////////////
// sample Verilog to generate color bars
    
    wire [9:0] hcount;
    wire [9:0] vcount;
    wire hsync, vsync, at_display_area;
    vga vga1(.vga_clock(clock_25mhz),.hcount(hcount),.vcount(vcount),
          .hsync(hsync),.vsync(vsync),.at_display_area(at_display_area));
        
    assign VGA_R = at_display_area ? {4{hcount[7]}} : 0;
    assign VGA_G = at_display_area ? {4{hcount[6]}} : 0;
    assign VGA_B = at_display_area ? {4{hcount[5]}} : 0;
    assign VGA_HS = ~hsync;
    assign VGA_VS = ~vsync;
endmodule

module clock_quarter_divider(input clk100_mhz, output reg clock_25mhz = 0);
    reg counter = 0;

    // VERY BAD VERILOG
    // VERY BAD VERILOG
    // VERY BAD VERILOG
    // But it's a quick and dirty way to create a 25Mhz clock
    // Please use the IP Clock Wizard under FPGA Features/Clocking
    //
    // For 1 Hz pulse, it's okay to use a counter to create the pulse as in
    // assign onehz = (counter == 100_000_000); 
    // be sure to have the right number of bits.

    always @(posedge clk100_mhz) begin
        counter <= counter + 1;
        if (counter == 0) begin
            clock_25mhz <= ~clock_25mhz;
        end
    end
endmodule

module vga(input vga_clock,
            output reg [9:0] hcount = 0,    // pixel number on current line
            output reg [9:0] vcount = 0,    // line number
            output reg vsync, hsync, 
            output at_display_area);

   // Comments applies to XVGA 1024x768, left in for reference
   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   reg hblank,vblank;
   wire hsyncon,hsyncoff,hreset,hblankon;
   assign hblankon = (hcount == 639);    // active H  1023
   assign hsyncon = (hcount == 655);     // active H + FP 1047
   assign hsyncoff = (hcount == 751);    // active H + fp + sync  1183
   assign hreset = (hcount == 799);      // active H + fp + sync + bp 1343

   // vertical: 806 lines total
   // display 768 lines
   wire vsyncon,vsyncoff,vreset,vblankon;
   assign vblankon = hreset & (vcount == 479);    // active V   767
   assign vsyncon = hreset & (vcount ==490 );     // active V + fp   776
   assign vsyncoff = hreset & (vcount == 492);    // active V + fp + sync  783
   assign vreset = hreset & (vcount == 523);      // active V + fp + sync + bp 805

   // sync and blanking
   wire next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always @(posedge vga_clock) begin
      hcount <= hreset ? 0 : hcount + 1;
      hblank <= next_hblank;
      hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync;  // active low

      vcount <= hreset ? (vreset ? 0 : vcount + 1) : vcount;
      vblank <= next_vblank;
      vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;  // active low

   end

   assign at_display_area = ((hcount >= 0) && (hcount < 640) && (vcount >= 0) && (vcount < 480));

endmodule

