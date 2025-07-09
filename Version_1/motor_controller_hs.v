`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2025 06:22:13 PM
// Design Name: 
// Module Name: motor_controller_hs
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


//https://www.hackster.io/whitney-knitter/getting-started-with-bldcs-on-kria-kd240-motor-kit-part-1-c18318


module motor_controller_hs(
    input clk,
    input rst_n,
    input hallA,
    input hallB,
    input hallC, 
    output reg phaseA,
    output reg phaseB,
    output reg phaseC
    );
    
    reg motor_pwm; 
    reg [21:0] motor_speed_interval;
    parameter speed_2000rpm = 22'd3000000;
    
    wire [2:0] hall_code;
    assign hall_code[2:2] = hallA; 
    assign hall_code[1:1] = hallB; 
    assign hall_code[0:0] = hallC; 
    
    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            phaseA <= 1'bz;
            phaseB <= 1'bz;
            phaseC <= 1'bz;
        end
        else begin 
            case (hall_code[2:0])
                1 : begin 
                    phaseA <= 1'bz;
                    phaseB <= 1'b0;
                    phaseC <= motor_pwm; //1'b1;
                end     
                
                2 : begin 
                    phaseA <= 1'b0;
                    phaseB <= motor_pwm; //1'b1;
                    phaseC <= 1'bz;
                end 
                
                3 : begin
                    phaseA <= 1'b0;
                    phaseB <= 1'bz;
                    phaseC <= motor_pwm; //1'b1;
                end
                
                4 : begin
                    phaseA <= motor_pwm; //1'b1;
                    phaseB <= 1'bz;
                    phaseC <= 1'b0;
                end
                
                5 : begin
                    phaseA <= motor_pwm; //1'b1;
                    phaseB <= 1'b0;
                    phaseC <= 1'bz;
                end 
                
                6 : begin
                    phaseA <= 1'bz;
                    phaseB <= motor_pwm; //1'b1;
                    phaseC <= 1'b0;
                end 
                
                default : begin 
                    phaseA <= 1'bz;
                    phaseB <= 1'bz;
                    phaseC <= 1'bz;
                end 
                
            endcase
        end 
    end
    
    // PWM 
    always @ (posedge clk or negedge rst_n) begin 
        if (rst_n == 1'b0) begin
            motor_speed_interval <= 22'd0;
            motor_pwm <= 1'b0;
        end 
        else begin
            if (motor_speed_interval == speed_2000rpm) begin
                motor_speed_interval <= 22'd0;
                motor_pwm <= ~motor_pwm;
            end
            else begin
                motor_speed_interval <= motor_speed_interval + 1;
            end 
        end 
    end    
     
    
endmodule
