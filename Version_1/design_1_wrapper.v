//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Tue Jul  8 12:04:20 2025
//Host        : WPS-175354 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (gpio_rtl_tri_o,
    hallA_0,
    hallB_0,
    hallC_0,
    phaseA_0,
    phaseB_0,
    phaseC_0);
  output [7:0]gpio_rtl_tri_o;
  input hallA_0;
  input hallB_0;
  input hallC_0;
  output phaseA_0;
  output phaseB_0;
  output phaseC_0;

  wire [7:0]gpio_rtl_tri_o;
  wire hallA_0;
  wire hallB_0;
  wire hallC_0;
  wire phaseA_0;
  wire phaseB_0;
  wire phaseC_0;

  design_1 design_1_i
       (.gpio_rtl_tri_o(gpio_rtl_tri_o),
        .hallA_0(hallA_0),
        .hallB_0(hallB_0),
        .hallC_0(hallC_0),
        .phaseA_0(phaseA_0),
        .phaseB_0(phaseB_0),
        .phaseC_0(phaseC_0));
endmodule
