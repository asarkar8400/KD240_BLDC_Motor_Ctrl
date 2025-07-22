#include <stdio.h>
#include "xgpio.h"
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"

// GPIO instances
XGpio MotorEnGpio;     // axi_gpio_0 - motor_en
XGpio PwmGpio;         // speed_ctrl_axi_gpio - pwm_interval[21:0]
XGpio MonitorGpio;     // hall_and_phase - hall_monitor (CH1), phase_monitor (CH2)

int main() {
    init_platform();
    xil_printf("Motor Control Program Start\n\r");

    // Initialize GPIOs
    if (XGpio_Initialize(&MotorEnGpio, XPAR_AXI_GPIO_0_DEVICE_ID) != XST_SUCCESS) {
        xil_printf("ERROR: MotorEnGpio Init Failed\n\r");
        return -1;
    }

    if (XGpio_Initialize(&PwmGpio, XPAR_SPEED_CTRL_AXI_GPIO_DEVICE_ID) != XST_SUCCESS) {
        xil_printf("ERROR: PwmGpio Init Failed\n\r");
        return -1;
    }

    if (XGpio_Initialize(&MonitorGpio, XPAR_HALL_AND_PHASE_DEVICE_ID) != XST_SUCCESS) {
        xil_printf("ERROR: MonitorGpio Init Failed\n\r");
        return -1;
    }

    // Set directions
    XGpio_SetDataDirection(&MotorEnGpio, 1, 0x0);      // Output
    XGpio_SetDataDirection(&PwmGpio,     1, 0x0);      // Output
    XGpio_SetDataDirection(&MonitorGpio, 1, 0xFFFFFFFF); // Channel 1 - hall (input)
    XGpio_SetDataDirection(&MonitorGpio, 2, 0xFFFFFFFF); // Channel 2 - phase (input)

    // Write PWM interval (try smaller value for initial test)
    u32 pwm_value = 50000;  // Adjust for ~100Hz PWM depending on clk
    XGpio_DiscreteWrite(&PwmGpio, 1, pwm_value);

    // Enable motor
    XGpio_DiscreteWrite(&MotorEnGpio, 1, 0x1);
    xil_printf("Motor ON\n\r");

    // Monitor hall and phase feedback
    for (int i = 0; i < 100; i++) {
        u8 hall = XGpio_DiscreteRead(&MonitorGpio, 1) & 0x7;
        u8 phase = XGpio_DiscreteRead(&MonitorGpio, 2) & 0x7;

        xil_printf("hall: %d%d%d, phase: %d%d%d\n\r",
            (hall >> 2) & 1, (hall >> 1) & 1, hall & 1,
            (phase >> 2) & 1, (phase >> 1) & 1, phase & 1
        );

        sleep(1);
    }

    // Turn off motor
    XGpio_DiscreteClear(&MotorEnGpio, 1, 0x1);
    xil_printf("Motor OFF\n\r");

    cleanup_platform();
    return 0;
}
