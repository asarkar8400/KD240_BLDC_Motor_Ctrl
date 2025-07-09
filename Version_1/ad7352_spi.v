`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2025 06:47:49 PM
// Design Name: 
// Module Name: ad7352_spi
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

//https://www.hackster.io/whitney-knitter/getting-started-with-bldcs-on-kria-kd240-motor-kit-part-2-fb5ee0


`timescale 1ns / 1ps

module ad7352_spi(
    input  clk,
    input  rst_n, 
    input  start_cnv,
    output reg ad7352_sclk,
    output reg ad7352_cs,
    input  adcA_data_volt,
    input  adcA_data_curr,
    input  adcB_data_volt,
    input  adcB_data_curr,
    input  adcC_data_volt,
    input  adcC_data_curr,
    output [15:0] m_axis_voltA_tdata,
    output m_axis_voltA_tlast,
    input m_axis_voltA_tready,
    output m_axis_voltA_tvalid,
    output [15:0] m_axis_currA_tdata,
    output m_axis_currA_tlast,
    input m_axis_currA_tready,
    output m_axis_currA_tvalid,
    output [15:0] m_axis_voltB_tdata,
    output m_axis_voltB_tlast,
    input m_axis_voltB_tready,
    output m_axis_voltB_tvalid,
    output [15:0] m_axis_currB_tdata,
    output m_axis_currB_tlast,
    input m_axis_currB_tready,
    output m_axis_currB_tvalid,
    output [15:0] m_axis_voltC_tdata,
    output m_axis_voltC_tlast,
    input m_axis_voltC_tready,
    output m_axis_voltC_tvalid,
    output [15:0] m_axis_currC_tdata,
    output m_axis_currC_tlast,
    input m_axis_currC_tready,
    output m_axis_currC_tvalid 
    );
    
    reg [11:0] phaseA_voltage, phaseA_current;
    reg [11:0] phaseB_voltage, phaseB_current;
    reg [11:0] phaseC_voltage, phaseC_current;
    
    reg [3:0] state_reg;
    parameter init                   = 4'd00;
    parameter WaitForStart           = 4'd01;
    parameter ChipSelectLow          = 4'd02;
    parameter SclkSetup              = 4'd03;
    parameter FirstFallingEdge       = 4'd04;
    parameter SclkHigh               = 4'd05;
    parameter SclkLow                = 4'd06; 
    parameter ChipSelectHigh         = 4'd07;
    parameter WaitOneState           = 4'd08;
    parameter SclkHighDone           = 4'd09;

    reg [1:0] sclk_period_counter;   
    parameter sclk_half_period       = 2'd01; //2 counts = 50MHz SCLK

    reg [3:0] sclk_counter; 
    parameter complete_conversion    = 4'd13;
    
    // sync reg for start_cnv from motor_en
    (* ASYNC_REG = "TRUE" *) reg sync_0, start_cnv_sync;
    always @ (posedge clk) begin
        start_cnv_sync <= sync_0;
        sync_0 <= start_cnv;
    end 

    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) 
            begin
                ad7352_cs <= 1'b1;
                ad7352_sclk <= 1'b1;
                sclk_counter <= complete_conversion;
                sclk_period_counter <= 2'd00;
                phaseA_voltage <= 12'd00;
                phaseA_current <= 12'd00;
                phaseB_voltage <= 12'd00;
                phaseB_current <= 12'd00;
                phaseC_voltage <= 12'd00;
                phaseC_current <= 12'd00;
                state_reg <= init;
            end
        else
            begin
                case(state_reg)
                    init :
                        begin
                            ad7352_cs <= 1'b1;
                            ad7352_sclk <= 1'b1;
                            sclk_counter <= complete_conversion;
                            sclk_period_counter <= 2'd00;
                            phaseA_voltage <= 12'd00;
                            phaseA_current <= 12'd00;
                            phaseB_voltage <= 12'd00;
                            phaseB_current <= 12'd00;
                            phaseC_voltage <= 12'd00;
                            phaseC_current <= 12'd00;
                            state_reg <= WaitForStart;
                        end

                    WaitForStart : 
                        begin
                            ad7352_cs <= 1'b1;

                            if (start_cnv_sync == 1'b1)
                                begin
                                    state_reg <= ChipSelectLow;
                                end
                            else
                                begin
                                    state_reg <= WaitForStart;
                                end
                        end

                    ChipSelectLow : 
                        begin
                            ad7352_cs <= 1'b0;
                            state_reg <= SclkSetup;
                        end

                    SclkSetup : 
                        begin
                            state_reg <= FirstFallingEdge;
                        end

                    FirstFallingEdge : 
                        begin
                            ad7352_sclk <= 1'b0;

                            if (sclk_period_counter == sclk_half_period)
                                begin
                                    sclk_period_counter <= 2'd00;
                                    state_reg <= SclkHigh;
                                end
                            else
                                begin 
                                    sclk_period_counter <= sclk_period_counter + 1;
                                    state_reg <= FirstFallingEdge;
                                end 
                        end

                    SclkHigh :
                        begin
                            ad7352_sclk <= 1'b1;

                            if (sclk_period_counter == sclk_half_period)
                                begin
                                    sclk_period_counter <= 2'd00;
                                    state_reg <= SclkLow;
    
                                    if (sclk_counter < complete_conversion) // account for 2 leading zeros
                                        begin 
                                            phaseA_voltage[sclk_counter] <= adcA_data_volt;
                                            phaseA_current[sclk_counter] <= adcA_data_curr;
                                            phaseB_voltage[sclk_counter] <= adcB_data_volt;
                                            phaseB_current[sclk_counter] <= adcB_data_curr;
                                            phaseC_voltage[sclk_counter] <= adcC_data_volt;
                                            phaseC_current[sclk_counter] <= adcC_data_curr;
                                        end 
                                    else
                                        begin
                                            phaseA_voltage <= phaseA_voltage;
                                            phaseA_current <= phaseA_current;
                                            phaseB_voltage <= phaseB_voltage;
                                            phaseB_current <= phaseB_current;
                                            phaseC_voltage <= phaseC_voltage;
                                            phaseC_current <= phaseC_current;
                                        end 
                                end 
                            else
                                begin 
                                    sclk_period_counter <= sclk_period_counter + 1;
                                    state_reg <= SclkHigh;
                                end 
                        end

                    SclkLow : 
                        begin 
                            ad7352_sclk <= 1'b0;

                            if (sclk_period_counter == sclk_half_period && sclk_counter == 4'd00)
                                begin 
                                    sclk_period_counter <= 2'd00;
                                    sclk_counter <= complete_conversion;
                                    state_reg <= ChipSelectHigh;
                                end 
                            else if (sclk_period_counter == sclk_half_period)
                                begin 
                                    sclk_period_counter <= 2'd00;
                                    sclk_counter <= sclk_counter - 1;
                                    state_reg <= SclkHigh;
                                end 
                            else
                                begin 
                                    sclk_period_counter <= sclk_period_counter + 1;
                                    sclk_counter <= sclk_counter;
                                    state_reg <= SclkLow;
                                end 
                        end 

                    ChipSelectHigh : 
                        begin 
                            ad7352_cs <= 1'b1;
                            state_reg <= WaitOneState;
                        end 

                    WaitOneState : 
                        begin 
                            state_reg <= SclkHighDone;
                        end 

                    SclkHighDone : 
                        begin
                            ad7352_sclk <= 1'b1;
                            state_reg <= WaitForStart;
                        end 
                endcase 
            end 
    end 
    
    m_axis_sm m_axis_voltA(
        .clk(clk),
        .rst_n(rst_n), 
        .tdata_available(start_cnv_sync), //map to start_cnv - which is tied to motor_ena
        .adc_data(phaseA_voltage),
        .m_axis_tdata(m_axis_voltA_tdata),
        .m_axis_tlast(m_axis_voltA_tlast),
        .m_axis_tready(m_axis_voltA_tready),
        .m_axis_tvalid(m_axis_voltA_tvalid)
    );
    
    m_axis_sm m_axis_currA(
        .clk(clk),
        .rst_n(rst_n), 
        .tdata_available(start_cnv_sync), //map to start_cnv - which is tied to motor_ena
        .adc_data(phaseA_current),
        .m_axis_tdata(m_axis_currA_tdata),
        .m_axis_tlast(m_axis_currA_tlast),
        .m_axis_tready(m_axis_currA_tready),
        .m_axis_tvalid(m_axis_currA_tvalid)
    );
    
    m_axis_sm m_axis_voltB(
        .clk(clk),
        .rst_n(rst_n), 
        .tdata_available(start_cnv_sync), //map to start_cnv - which is tied to motor_ena
        .adc_data(phaseB_voltage),
        .m_axis_tdata(m_axis_voltB_tdata),
        .m_axis_tlast(m_axis_voltB_tlast),
        .m_axis_tready(m_axis_voltB_tready),
        .m_axis_tvalid(m_axis_voltB_tvalid)
    );
    
    m_axis_sm m_axis_currB(
        .clk(clk),
        .rst_n(rst_n), 
        .tdata_available(start_cnv_sync), //map to start_cnv - which is tied to motor_ena
        .adc_data(phaseB_current),
        .m_axis_tdata(m_axis_currB_tdata),
        .m_axis_tlast(m_axis_currB_tlast),
        .m_axis_tready(m_axis_currB_tready),
        .m_axis_tvalid(m_axis_currB_tvalid)
    );
    
    m_axis_sm m_axis_voltC(
        .clk(clk),
        .rst_n(rst_n), 
        .tdata_available(start_cnv_sync), //map to start_cnv - which is tied to motor_ena
        .adc_data(phaseC_voltage),
        .m_axis_tdata(m_axis_voltC_tdata),
        .m_axis_tlast(m_axis_voltC_tlast),
        .m_axis_tready(m_axis_voltC_tready),
        .m_axis_tvalid(m_axis_voltC_tvalid)
    );
    
    m_axis_sm m_axis_currC(
        .clk(clk),
        .rst_n(rst_n), 
        .tdata_available(start_cnv_sync), //map to start_cnv - which is tied to motor_ena
        .adc_data(phaseC_current),
        .m_axis_tdata(m_axis_currC_tdata),
        .m_axis_tlast(m_axis_currC_tlast),
        .m_axis_tready(m_axis_currC_tready),
        .m_axis_tvalid(m_axis_currC_tvalid)
    );
    
endmodule
