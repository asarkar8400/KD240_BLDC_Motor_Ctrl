


####################################################################################################
##################################### Motor Phase Gate Drivers #####################################
#################################################################################################### 
## HDA05 - Bank  26 VCCO - VCCO_HDA - IO_L2N_AD10N_26
set_property PACKAGE_PIN G9       [get_ports motor_en];
set_property IOSTANDARD  LVCMOS33 [get_ports motor_en];

## HDA04 - Bank  26 VCCO - VCCO_HDA - IO_L2P_AD10P_26
set_property PACKAGE_PIN G10      [get_ports phaseC];
set_property IOSTANDARD  LVCMOS33 [get_ports phaseC];

## HDA03 - Bank  26 VCCO - VCCO_HDA - IO_L1N_AD11N_26
set_property PACKAGE_PIN H9       [get_ports phaseB];
set_property IOSTANDARD  LVCMOS33 [get_ports phaseB];

## HDA02 - Bank  26 VCCO - VCCO_HDA - IO_L1P_AD11P_26
set_property PACKAGE_PIN H10      [get_ports phaseA];
set_property IOSTANDARD  LVCMOS33 [get_ports phaseA];

####################################################################################################
####################################### Hall Sensor Inputs #########################################
####################################################################################################
## HDA11 - Bank  26 VCCO - VCCO_HDA - IO_L4N_AD8N_26
set_property PACKAGE_PIN E9       [get_ports hallA];
set_property IOSTANDARD  LVCMOS33 [get_ports hallA];

## HDA12 - Bank  26 VCCO - VCCO_HDA - IO_L7P_HDGC_AD5P_26
set_property PACKAGE_PIN F13      [get_ports hallB];
set_property IOSTANDARD  LVCMOS33 [get_ports hallB];

## HDA13 - Bank  26 VCCO - VCCO_HDA - IO_L7N_HDGC_AD5N_26
set_property PACKAGE_PIN E12      [get_ports hallC];
set_property IOSTANDARD  LVCMOS33 [get_ports hallC];



####################################################################################################
########################################### AD7352 ADCs ############################################
####################################################################################################

set_property PACKAGE_PIN N6 [get_ports ad7352_sclk]
set_property IOSTANDARD  LVCMOS18 [get_ports ad7352_sclk]

set_property PACKAGE_PIN U5 [get_ports ad7352_cs]
set_property IOSTANDARD  LVCMOS18 [get_ports ad7352_cs]

set_property PACKAGE_PIN P6 [get_ports adcA_data_volt]
set_property IOSTANDARD  LVCMOS18 [get_ports adcA_data_volt]

set_property PACKAGE_PIN N4 [get_ports adcA_data_curr]
set_property IOSTANDARD  LVCMOS18 [get_ports adcA_data_curr]

set_property PACKAGE_PIN P4 [get_ports adcB_data_volt]
set_property IOSTANDARD  LVCMOS18 [get_ports adcB_data_volt]

set_property PACKAGE_PIN M7 [get_ports adcB_data_curr]
set_property IOSTANDARD  LVCMOS18 [get_ports adcB_data_curr]

set_property PACKAGE_PIN N7 [get_ports adcC_data_volt]
set_property IOSTANDARD  LVCMOS18 [get_ports adcC_data_volt]

set_property PACKAGE_PIN T6 [get_ports adcC_data_curr]
set_property IOSTANDARD  LVCMOS18 [get_ports adcC_data_curr]

####################################################################################################
# ASYNC registers
####################################################################################################
#create_clock -name pl_clk0 -period 10.000 [get_ports k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk0]
#create_clock -name pl_clk1 -period 10.000 [get_ports k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk1]
#set_clock_groups -name async_pl_clk0_clk1 -asynchronous -group [get_clocks -include_generated_clocks k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk0] -group [get_clocks -include_generated_clocks k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk1]
#set_false_path -from [get_clocks k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk0] -to [get_clocks k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk1]

#create_clock -name clk_pl_0 -period 10.000 [get_ports k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk0]
#create_clock -name clk_pl_1 -period 10.000 [get_ports k24_kd240_design_i/zynq_ultra_ps_e_0/pl_clk1]
#set_clock_groups -name async_clk0_clk1 -asynchronous -group {clk_pl_0} -group {clk_pl_1}

set_false_path -from [get_clocks clk_pl_0] -to [get_clocks clk_pl_1]

set_property ASYNC_REG TRUE [get_cells k24_kd240_design_i/ad7352_spi_0/inst/sync_0_reg]
set_property ASYNC_REG TRUE [get_cells k24_kd240_design_i/ad7352_spi_0/inst/start_cnv_sync_reg]

