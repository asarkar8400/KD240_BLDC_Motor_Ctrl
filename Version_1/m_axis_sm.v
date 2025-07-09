`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2025 06:49:57 PM
// Design Name: 
// Module Name: m_axis_sm
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

module m_axis_sm(
    input clk,
    input rst_n, 
    input tdata_available, //map to start_cnv - which is tied to motor_ena
    input [11:0] adc_data,
    output reg [15:0] m_axis_tdata,
    output reg m_axis_tlast,
    input m_axis_tready,
    output reg m_axis_tvalid
    );
    
    reg [3:0] axis_state_reg; 
    parameter init                   = 4'd00;
    parameter GetADCdata             = 4'd01;
    parameter SetTvalidHigh          = 4'd02;
    parameter CheckTready            = 4'd04;
    parameter WaitState              = 4'd05;   
    parameter SetTlastHigh           = 4'd06;
    parameter SetTlastLow            = 4'd07;
    
    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) 
            begin   
                m_axis_tdata <= 16'd0;
                m_axis_tvalid <= 1'b0;
                axis_state_reg <= init; 
            end 
        else 
            begin 
                case(axis_state_reg)
                    init :
                        begin
                            m_axis_tdata <= 16'd0; 
                            m_axis_tvalid <= 1'b0;
                            axis_state_reg <= GetADCdata; 
                        end 
                        
                    GetADCdata : 
                        begin 
                            if (tdata_available == 1'b1)
                                begin 
                                    m_axis_tdata[15:12] <= 4'd0;
                                    m_axis_tdata[11:0] <= adc_data[11:0]; 
                                    axis_state_reg <= SetTvalidHigh; 
                                end
                            else 
                                begin
                                    m_axis_tvalid <= 1'b0;
                                    axis_state_reg <= GetADCdata;  
                                end
                        end 
                        
                    SetTvalidHigh : 
                        begin 
                            m_axis_tvalid <= 1'b1; 
                            axis_state_reg <= CheckTready; 
                        end 
                        
                    CheckTready :
                        begin 
                            if (m_axis_tready == 1'b1)
                                begin
                                    axis_state_reg <= WaitState;
                                end
                            else    
                                begin
                                    axis_state_reg <= CheckTready;
                                end 
                        end 
                        
                    WaitState :
                        begin 
                            if (tdata_available == 1'b0)
                                begin 
                                    axis_state_reg <= SetTlastHigh; 
                                end
                            else 
                                begin
                                    axis_state_reg <= GetADCdata; 
                                end
                        end 
                           
                    SetTlastHigh :
                        begin 
                            m_axis_tlast <= 1'b1;
                            axis_state_reg <= SetTlastLow; 
                        end
                        
                    SetTlastLow :
                        begin
                            m_axis_tlast <= 1'b0;
                            axis_state_reg <= GetADCdata;  
                        end
                endcase
            end 
    end
    
endmodule
