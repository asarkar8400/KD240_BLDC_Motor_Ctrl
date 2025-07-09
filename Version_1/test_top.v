`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2025 06:20:08 PM
// Design Name: 
// Module Name: test_top
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


module test_top(
  output motor_en,
  input hallA,
  input hallB,
  input hallC,
  output phaseA,
  output phaseB,
  output phaseC
    );
    
    
  wire [7:0]gpio_rtl_tri_o;
  wire hallA_0;
  wire hallB_0;
  wire hallC_0;
  wire phaseA_0;
  wire phaseB_0;
  wire phaseC_0;

  design_1 design_1_i
       (.gpio_rtl_tri_o(gpio_rtl_tri_o),
        .hallA_0 (hallA),
        .hallB_0 (hallB),
        .hallC_0 (hallC),
        .phaseA_0(phaseA),
        .phaseB_0(phaseB),
        .phaseC_0(phaseC));
        
  assign motor_en = gpio_rtl_tri_o[0];      
            
endmodule
